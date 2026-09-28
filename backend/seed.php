<?php

$pdo = require __DIR__ . '/src/config/database.php';

$seedFile = __DIR__ . '/data/04-seed.json';

if (!file_exists($seedFile)) {
    die("04-seed.json not found.\n");
}

$data = json_decode(file_get_contents($seedFile), true);

if ($data === null) {
    die("Invalid JSON in 04-seed.json.\n");
}

echo "Seed file loaded successfully.\n";

// Create users table
$pdo->exec("
    CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        role TEXT NOT NULL,
        name TEXT NOT NULL,
        token TEXT UNIQUE NOT NULL
    )
");

// Create candidates table
$pdo->exec("
    CREATE TABLE IF NOT EXISTS candidates (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        rating TEXT,
        attend TEXT,
        km TEXT,
        km_value REAL,
        photo TEXT,
        online INTEGER,
        perfect INTEGER,
        score INTEGER
    )
");

// Create offers table
$pdo->exec("
    CREATE TABLE IF NOT EXISTS offers (
        id TEXT PRIMARY KEY,
        worker_id TEXT NOT NULL,
        title TEXT NOT NULL,
        place TEXT NOT NULL,
        pay TEXT,
        pay_value REAL,
        logo TEXT,
        district TEXT,
        when_text TEXT,
        status TEXT,
        expires_at TEXT
    )
");

echo "Tables created.\n";

// Insert users
$userStmt = $pdo->prepare("
    INSERT OR REPLACE INTO users
    (id, role, name, token)
    VALUES (:id, :role, :name, :token)
");

foreach ($data['users'] as $user) {
    $userStmt->execute([
        ':id' => $user['id'],
        ':role' => $user['role'],
        ':name' => $user['name'],
        ':token' => $user['token']
    ]);
}

echo "Users inserted.\n";

// Insert candidates
$candidateStmt = $pdo->prepare("
    INSERT OR REPLACE INTO candidates
    (id, name, rating, attend, km, km_value, photo, online, perfect, score)
    VALUES
    (:id, :name, :rating, :attend, :km, :km_value, :photo, :online, :perfect, :score)
");

foreach ($data['candidates'] as $candidate) {
    $candidateStmt->execute([
        ':id' => $candidate['id'],
        ':name' => $candidate['name'],
        ':rating' => $candidate['rating'],
        ':attend' => $candidate['attend'],
        ':km' => $candidate['km'],
        ':km_value' => $candidate['kmValue'],
        ':photo' => $candidate['photo'],
        ':online' => $candidate['online'] ? 1 : 0,
        ':perfect' => $candidate['perfect'] ? 1 : 0,
        ':score' => $candidate['score']
    ]);
}

echo "Candidates inserted.\n";

// Insert offers
$offerStmt = $pdo->prepare("
    INSERT OR REPLACE INTO offers
    (id, worker_id, title, place, pay, pay_value, logo, district, when_text, status, expires_at)
    VALUES
    (:id, :worker_id, :title, :place, :pay, :pay_value, :logo, :district, :when_text, :status, :expires_at)
");

foreach ($data['offers'] as $offer) {
    $expiresAt = $offer['expiresAt'];

    if ($expiresAt === 'USE_NOW_PLUS_21H32M') {
        $expiresAt = date('Y-m-d H:i:s', time() + (21 * 60 * 60 + 32 * 60));
    }

    if ($expiresAt === 'USE_NOW_PLUS_18H00M') {
        $expiresAt = date('Y-m-d H:i:s', time() + (18 * 60 * 60));
    }
    $offerStmt->execute([
        ':id' => $offer['id'],
        ':worker_id' => $offer['workerId'],
        ':title' => $offer['title'],
        ':place' => $offer['place'],
        ':pay' => $offer['pay'],
        ':pay_value' => $offer['payValue'],
        ':logo' => $offer['logo'],
        ':district' => $offer['district'],
        ':when_text' => $offer['when'],
        ':status' => $offer['status'],
        ':expires_at' => $expiresAt
    ]);
}

echo "Offers inserted.\n";

echo "Database seeding completed successfully!\n";