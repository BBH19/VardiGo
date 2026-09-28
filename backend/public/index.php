<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$pdo = require __DIR__ . '/../src/config/database.php';

require_once __DIR__ . '/../src/controllers/AuthController.php';
require_once __DIR__ . '/../src/controllers/CandidateController.php';
require_once __DIR__ . '/../src/middleware/AuthMiddleware.php';
require_once __DIR__ . '/../src/controllers/OfferController.php';

$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$body = json_decode(file_get_contents('php://input'), true) ?? [];

if ($method === 'POST' && $path === '/api/auth/login') {
    AuthController::login($pdo, $body);
    exit;
}

if ($method === 'GET' && $path === '/api/candidates') {

    $user = AuthMiddleware::user($pdo);

    if (!$user) {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Authentication required'
            ]
        ]);

        exit;
    }

    if ($user['role'] !== 'employer') {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Employer access required'
            ]
        ]);

        exit;
    }

    CandidateController::index($pdo, $_GET);
    exit;
}

if ($method === 'POST' && $path === '/api/offers') {

    $user = AuthMiddleware::user($pdo);

    if (!$user) {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Authentication required'
            ]
        ]);

        exit;
    }

    if ($user['role'] !== 'employer') {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Employer access required'
            ]
        ]);

        exit;
    }

    OfferController::create($pdo, $body);
    exit;
}

if ($method === 'GET' && $path === '/api/offers') {

    $user = AuthMiddleware::user($pdo);

    if (!$user) {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Authentication required'
            ]
        ]);

        exit;
    }

    if ($user['role'] !== 'worker') {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Worker access required'
            ]
        ]);

        exit;
    }

    OfferController::index($pdo, $_GET);
    exit;
}

if ($method === 'POST' && preg_match('#^/api/offers/([^/]+)/accept$#', $path, $matches)) {

    $user = AuthMiddleware::user($pdo);

    if (!$user || $user['role'] !== 'worker') {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Worker access required'
            ]
        ]);

        exit;
    }

    OfferController::accept($pdo, $matches[1]);
    exit;
}

if ($method === 'POST' && preg_match('#^/api/offers/([^/]+)/reject$#', $path, $matches)) {

    $user = AuthMiddleware::user($pdo);

    if (!$user || $user['role'] !== 'worker') {
        http_response_code(401);

        echo json_encode([
            'ok' => false,
            'error' => [
                'code' => 'AUTH',
                'message' => 'Worker access required'
            ]
        ]);

        exit;
    }

    OfferController::reject($pdo, $matches[1]);
    exit;
}

http_response_code(404);

echo json_encode([
    'ok' => false,
    'error' => [
        'code' => 'NOT_FOUND',
        'message' => 'Endpoint not found'
    ]
]);