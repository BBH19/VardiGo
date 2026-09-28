<?php

class OfferController
{
    public static function create(PDO $pdo, array $body): void
    {
        if (
            !isset($body['workerIds']) ||
            !is_array($body['workerIds']) ||
            count($body['workerIds']) === 0
        ) {
            http_response_code(400);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'VALIDATION',
                    'message' => 'workerIds is required'
                ]
            ]);

            return;
        }

        $created = [];

        foreach ($body['workerIds'] as $workerId) {

            // Vérifier que le candidat existe
            $stmt = $pdo->prepare("
                SELECT id
                FROM candidates
                WHERE id = :id
                LIMIT 1
            ");

            $stmt->execute([
                ':id' => $workerId
            ]);

            $candidate = $stmt->fetch();

            if (!$candidate) {
                http_response_code(404);

                echo json_encode([
                    'ok' => false,
                    'error' => [
                        'code' => 'NOT_FOUND',
                        'message' => 'Candidate not found'
                    ]
                ]);

                return;
            }

            // Vérifier s'il existe déjà une offre pending
            $stmt = $pdo->prepare("
                SELECT id
                FROM offers
                WHERE worker_id = :worker_id
                AND status = 'pending'
                LIMIT 1
            ");

            $stmt->execute([
                ':worker_id' => $workerId
            ]);

            $existingOffer = $stmt->fetch();

            if ($existingOffer) {
                http_response_code(409);

                echo json_encode([
                    'ok' => false,
                    'error' => [
                        'code' => 'OFFER_STATE',
                        'message' => 'An open pending offer already exists for this worker'
                    ]
                ]);

                return;
            }

            // Créer l'offre
            $offerId = 'o_' . uniqid();

            $stmt = $pdo->prepare("
                INSERT INTO offers (
                    id,
                    worker_id,
                    title,
                    place,
                    pay,
                    logo,
                    district,
                    when_text,
                    status,
                    expires_at
                )
                VALUES (
                    :id,
                    :worker_id,
                    'Garson',
                    'Zarif Cheff Restaurant',
                    '45.000',
                    'logos/zarif.svg',
                    'Kadıköy',
                    '16 Ağu · 12:00 - 16:00',
                    'pending',
                    :expires_at
                )
            ");

            $expiresAt = date('Y-m-d H:i:s', time() + (21 * 60 * 60 + 32 * 60));

            $stmt->execute([
                ':id' => $offerId,
                ':worker_id' => $workerId,
                ':expires_at' => $expiresAt
            ]);

            $created[] = [
                'id' => $offerId,
                'workerId' => $workerId,
                'status' => 'pending'
            ];
        }

        echo json_encode([
            'ok' => true,
            'data' => [
                'created' => $created
            ]
        ]);
    }
    public static function index(PDO $pdo, array $query): void
    {
        $status = $query['status'] ?? 'pending';

        if (!in_array($status, ['pending', 'answered', 'expired'])) {
            http_response_code(400);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'VALIDATION',
                    'message' => 'Invalid status'
                ]
            ]);

            return;
        }

        if ($status === 'answered') {
            $sql = "
                SELECT *
                FROM offers
                WHERE status IN ('accepted', 'rejected')
                ORDER BY id
            ";
        } else {
            $sql = "
                SELECT *
                FROM offers
                WHERE status = :status
                ORDER BY id
            ";
        }

        $stmt = $pdo->prepare($sql);

        if ($status === 'answered') {
            $stmt->execute();
        } else {
            $stmt->execute([
                ':status' => $status
            ]);
        }

        $offers = $stmt->fetchAll();

        $result = [];

        foreach ($offers as $offer) {

            $remain = null;

            if ($offer['status'] === 'pending') {
                $expiresAt = strtotime($offer['expires_at']);
                $remainingSeconds = $expiresAt - time();

                if ($remainingSeconds <= 0) {
                    $update = $pdo->prepare("
                        UPDATE offers
                        SET status = 'expired'
                        WHERE id = :id
                    ");

                    $update->execute([
                        ':id' => $offer['id']
                    ]);

                    continue;
                }

                $hours = floor($remainingSeconds / 3600);
                $minutes = floor(($remainingSeconds % 3600) / 60);

                $remain = $hours . ' saat ' . $minutes . ' dakika';
            }

            $result[] = [
                'id' => $offer['id'],
                'title' => $offer['title'],
                'place' => $offer['place'],
                'pay' => $offer['pay'],
                'logo' => $offer['logo'],
                'district' => $offer['district'],
                'when' => $offer['when_text'],
                'status' => $offer['status'],
                'remain' => $remain,
                'expiresAt' => $offer['expires_at']
            ];
        }

        $pendingStmt = $pdo->query("
            SELECT COUNT(*)
            FROM offers
            WHERE status = 'pending'
        ");

        $pendingCount = (int) $pendingStmt->fetchColumn();

        echo json_encode([
            'ok' => true,
            'data' => [
                'pendingCount' => $pendingCount,
                'offers' => $result
            ]
        ]);
    }
    public static function accept(PDO $pdo, string $offerId): void
    {
        self::updateStatus($pdo, $offerId, 'accepted');
    }

    public static function reject(PDO $pdo, string $offerId): void
    {
        self::updateStatus($pdo, $offerId, 'rejected');
    }

    private static function updateStatus(PDO $pdo, string $offerId, string $newStatus): void
    {
        $stmt = $pdo->prepare("
            SELECT id, status, expires_at
            FROM offers
            WHERE id = :id
            LIMIT 1
        ");

        $stmt->execute([
            ':id' => $offerId
        ]);

        $offer = $stmt->fetch();

        if (!$offer) {
            http_response_code(404);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'NOT_FOUND',
                    'message' => 'Offer not found'
                ]
            ]);

            return;
        }

        if ($offer['status'] !== 'pending') {
            http_response_code(409);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'OFFER_STATE',
                    'message' => 'Offer is not pending'
                ]
            ]);

            return;
        }

        if (strtotime($offer['expires_at']) <= time()) {

            $update = $pdo->prepare("
                UPDATE offers
                SET status = 'expired'
                WHERE id = :id
            ");

            $update->execute([
                ':id' => $offerId
            ]);

            http_response_code(409);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'OFFER_STATE',
                    'message' => 'Teklifin süresi doldu'
                ]
            ]);

            return;
        }

        $update = $pdo->prepare("
            UPDATE offers
            SET status = :status
            WHERE id = :id
        ");

        $update->execute([
            ':status' => $newStatus,
            ':id' => $offerId
        ]);

        echo json_encode([
            'ok' => true,
            'data' => [
                'id' => $offerId,
                'status' => $newStatus
            ]
        ]);
    }
}