<?php

class AuthController
{
    public static function login(PDO $pdo, array $body): void
    {
        if (!isset($body['role']) || !in_array($body['role'], ['employer', 'worker'])) {
            http_response_code(400);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'VALIDATION',
                    'message' => 'Role must be employer or worker'
                ]
            ]);

            return;
        }

        $stmt = $pdo->prepare("
            SELECT id, role, name, token
            FROM users
            WHERE role = :role
            LIMIT 1
        ");

        $stmt->execute([
            ':role' => $body['role']
        ]);

        $user = $stmt->fetch();

        if (!$user) {
            http_response_code(404);

            echo json_encode([
                'ok' => false,
                'error' => [
                    'code' => 'USER_NOT_FOUND',
                    'message' => 'User not found'
                ]
            ]);

            return;
        }

        echo json_encode([
            'ok' => true,
            'data' => [
                'token' => $user['token'],
                'role' => $user['role']
            ]
        ]);
    }
}