<?php

class AuthMiddleware
{
    public static function user(PDO $pdo): ?array
    {
        $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';

        if (!preg_match('/Bearer\s+(.+)/i', $header, $matches)) {
            return null;
        }

        $token = trim($matches[1]);

        $stmt = $pdo->prepare("
            SELECT id, role, name, token
            FROM users
            WHERE token = :token
            LIMIT 1
        ");

        $stmt->execute([
            ':token' => $token
        ]);

        return $stmt->fetch() ?: null;
    }
}