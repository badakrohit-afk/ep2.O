<?php
// router.php — Wasmer WebC / WASIX CGI Static & Dynamic Request Router
$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

$baseDir = __DIR__;
$subFolder = '/Examination-Portal-Examination_portal';
if (strpos($uri, $subFolder) === 0) {
    $relativePath = substr($uri, strlen($subFolder));
    if (file_exists($baseDir . $subFolder . $relativePath) && !is_dir($baseDir . $subFolder . $relativePath)) {
        $uri = $relativePath;
        $baseDir = $baseDir . $subFolder;
    }
}

$filePath = $baseDir . $uri;

// 1. Serve static asset files directly with correct MIME types
if ($uri !== '/' && file_exists($filePath) && !is_dir($filePath)) {
    $ext = strtolower(pathinfo($filePath, PATHINFO_EXTENSION));
    $mimeTypes = [
        'css'   => 'text/css',
        'js'    => 'application/javascript',
        'json'  => 'application/json',
        'png'   => 'image/png',
        'jpg'   => 'image/jpeg',
        'jpeg'  => 'image/jpeg',
        'gif'   => 'image/gif',
        'webp'  => 'image/webp',
        'svg'   => 'image/svg+xml',
        'ico'   => 'image/x-icon',
        'ttf'   => 'font/ttf',
        'woff'  => 'font/woff',
        'woff2' => 'font/woff2',
        'pdf'   => 'application/pdf',
        'sql'   => 'text/plain'
    ];
    
    if (isset($mimeTypes[$ext])) {
        header('Content-Type: ' . $mimeTypes[$ext]);
        readfile($filePath);
        exit;
    }
}

// 2. Serve directory root index files
if (is_dir($filePath)) {
    $indexPath = rtrim($filePath, '/') . '/index.php';
    if (file_exists($indexPath)) {
        require $indexPath;
        exit;
    }
}

// 3. Execute targeted PHP scripts
if (file_exists($filePath) && pathinfo($filePath, PATHINFO_EXTENSION) === 'php') {
    require $filePath;
    exit;
}

// 4. Default fallback to index.php
$mainIndex = $baseDir . '/index.php';
if (file_exists($mainIndex)) {
    require $mainIndex;
    exit;
}

http_response_code(404);
echo "404 Not Found";
?>
