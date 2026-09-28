<?php

class CandidateController
{
    public static function index(PDO $pdo, array $query): void
    {
        $tab = $query['tab'] ?? null;
        $sort = $query['sort'] ?? 'recommended';

        $sql = "
            SELECT
                id,
                name,
                rating,
                attend,
                km,
                km_value,
                photo,
                online,
                perfect,
                score
            FROM candidates
        ";

        $conditions = [];
        $params = [];

        if ($tab === 'perfect') {
            $conditions[] = 'perfect = 1';
        } elseif ($tab === 'similar') {
            $conditions[] = 'perfect = 0';
        }

        if (!empty($conditions)) {
            $sql .= ' WHERE ' . implode(' AND ', $conditions);
        }

        switch ($sort) {
            case 'near':
                $sql .= ' ORDER BY km_value ASC';
                break;

            case 'rating':
                $sql .= ' ORDER BY CAST(rating AS REAL) DESC';
                break;

            case 'recommended':
            default:
                $sql .= ' ORDER BY score DESC';
                break;
        }

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);

        $candidates = $stmt->fetchAll();

        foreach ($candidates as &$candidate) {
            $candidate['online'] = (bool) $candidate['online'];
            $candidate['perfect'] = (bool) $candidate['perfect'];

            unset($candidate['km_value']);
        }

        echo json_encode([
            'ok' => true,
            'data' => [
                'totalPerfect' => 26,
                'totalSimilar' => 16,
                'selectedHint' => 1,
                'pendingCountLabel' => 12,
                'candidates' => $candidates
            ]
        ]);
    }
}