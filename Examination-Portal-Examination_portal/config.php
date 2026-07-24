<?php
// config.php — Database & SMTP configuration for Online Examination Portal
// Wasmer & Environment Configuration
if (session_status() === PHP_SESSION_NONE) {
    $session_dir = sys_get_temp_dir() . '/sessions';
    if (!file_exists($session_dir)) {
        @mkdir($session_dir, 0777, true);
    }
    if (is_dir($session_dir) && is_writable($session_dir)) {
        session_save_path($session_dir);
    }
    session_start();
}
date_default_timezone_set(getenv('APP_TIMEZONE') ?: 'Asia/Kolkata');

// Ensure uploads directory exists for Wasmer filesystem
$upload_dir = __DIR__ . '/uploads';
if (!file_exists($upload_dir)) {
    @mkdir($upload_dir, 0777, true);
}

// Database Connection Settings (Wasmer Env & Local Fallback)
define('DB_HOST', getenv('DB_HOST') ?: '127.0.0.1');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') !== false ? getenv('DB_PASS') : '');
define('DB_NAME', getenv('DB_NAME') ?: 'exam_portal');

// Dynamic Base URL for Wasmer Edge & Local Server
$detected_host = isset($_SERVER['HTTP_HOST']) ? (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http') . '://' . $_SERVER['HTTP_HOST'] : 'http://localhost:8001';
define('BASE_URL', rtrim(getenv('BASE_URL') ?: $detected_host, '/'));

// SMTP Configuration (Gmail SMTP & Wasmer Env)
define('SMTP_HOST', getenv('SMTP_HOST') ?: 'smtp.gmail.com');
define('SMTP_PORT', (int)(getenv('SMTP_PORT') ?: 587));
define('SMTP_USER', getenv('SMTP_USER') ?: 'badakrohit@gmail.com');
define('SMTP_PASS', getenv('SMTP_PASS') ?: 'trkxotmhbbnkcofq');
define('SMTP_FROM', getenv('SMTP_FROM') ?: 'badakrohit@gmail.com');
define('SMTP_FROM_NAME', getenv('SMTP_FROM_NAME') ?: 'Online Examination Portal');

// Application settings
define('APP_NAME', getenv('APP_NAME') ?: 'Online Examination Portal');
define('ADMIN_EMAIL', getenv('ADMIN_EMAIL') ?: 'balajichaughule@gmail.com');

try {
    // First connect without DB to check if it exists
    $pdo = new PDO("mysql:host=" . DB_HOST . ";charset=utf8mb4", DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);

    $db_check = $pdo->query("SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '" . DB_NAME . "'");
    if (!$db_check->fetch()) {
        if (basename($_SERVER['PHP_SELF']) !== 'install.php') {
            header('Location: ' . BASE_URL . '/install.php');
            exit;
        }
    } else {
        $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4", DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    }
} catch (PDOException $e) {
    if (basename($_SERVER['PHP_SELF']) !== 'install.php') {
        header('Location: ' . BASE_URL . '/install.php?error=' . urlencode($e->getMessage()));
        exit;
    }
}
?>
