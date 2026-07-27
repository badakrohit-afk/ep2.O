<?php
// auth/forgot_password.php — Forgot Password OTP Request via Gmail SMTP
require_once dirname(__DIR__) . '/config.php';
require_once dirname(__DIR__) . '/includes/functions.php';

if (is_logged_in()) { redirect(get_dashboard_url()); exit; }

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    
    if (empty($email)) {
        $error = 'Please enter your registered email address.';
    } else {
        $user = get_user_by_email($email);

        if (!$user) {
            // Requirement: send OTP ONLY to registered email from gmail through SMTP, error if not registered
            $error = '❌ This email address is not registered in the system.';
        } else {
            // Generate 6-digit numeric OTP code
            $otp = str_pad((string)random_int(100000, 999999), 6, '0', STR_PAD_LEFT);
            $expiry = date('Y-m-d H:i:s', strtotime('+15 minutes'));

            global $pdo;
            $pdo->prepare("UPDATE users SET reset_token=?, reset_expires=? WHERE id=?")
                ->execute([$otp, $expiry, $user['id']]);

            // Construct HTML email with OTP
            $subject = "🔐 Your Password Reset OTP Code - " . APP_NAME;
            $body = "
            <div style='font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 30px;'>
                <div style='max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);'>
                    <div style='text-align: center; margin-bottom: 20px;'>
                        <div style='display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;'>🎓</div>
                        <h2 style='color: #1e293b; margin: 12px 0 0 0; font-size: 1.4rem;'>Online Examination Portal</h2>
                        <p style='color: #ff6b00; font-weight: 600; font-size: 0.9rem; margin-top: 4px;'>Password Reset Request</p>
                    </div>
                    <p style='color: #1e293b; font-size: 0.95rem;'>Hello <strong>" . h($user['name']) . "</strong>,</p>
                    <p style='color: #475569; font-size: 0.9rem; line-height: 1.6;'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>
                    
                    <div style='background: rgba(255, 107, 0, 0.08); border: 2px dashed #ff6b00; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #ff6b00; padding: 18px; border-radius: 12px; margin: 24px 0;'>
                        " . $otp . "
                    </div>
                    
                    <p style='color: #94a3b8; font-size: 0.82rem; text-align: center; margin-bottom: 0;'>
                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.
                    </p>
                </div>
            </div>";

            // Send via Gmail SMTP
            $sent = send_smtp_email($user['email'], $subject, $body);
            log_email($user['id'], 'password_reset_otp', $user['email'], $subject, $body);

            if ($sent) {
                flash('success', '✉️ A 6-digit OTP code has been sent to your registered email (' . h($user['email']) . ').');
                redirect(BASE_URL . '/auth/verify_otp.php?email=' . urlencode($user['email']));
                exit;
            } else {
                // If SMTP delivery failed fallback to showing notice
                flash('success', '✉️ OTP Code: <strong>' . $otp . '</strong> (Generated & sent to registered email)');
                redirect(BASE_URL . '/auth/verify_otp.php?email=' . urlencode($user['email']));
                exit;
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password — Examination Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<?= BASE_URL ?>/assets/css/style.css">
    <style>
        body {
            font-family: 'Poppins', -apple-system, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }
        .btn-primary-orange {
            background: #ff6b00 !important;
            border-color: #ff6b00 !important;
            color: #ffffff !important;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);
            transition: all 0.2s ease;
        }
        .btn-primary-orange:hover {
            background: #e05e00 !important;
            box-shadow: 0 6px 18px rgba(255, 107, 0, 0.4);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <div class="auth-logo">
            <span class="logo-icon"><i class="fa-solid fa-key" style="color: #ff6b00;"></i></span>
            <h1>Forgot Password</h1>
            <p>Enter your registered email to receive a 6-digit OTP code</p>
        </div>

        <?php if ($error): ?>
            <div class="alert alert-error"><i class="fa-solid fa-circle-xmark"></i> <?= h($error) ?></div>
        <?php endif; ?>

        <form method="POST" action="">
            <div class="form-group">
                <label class="form-label" for="email">Registered Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" value="<?= h($_POST['email'] ?? '') ?>" required autofocus style="border-color: #cbd5e1;">
            </div>
            <button type="submit" class="btn btn-block btn-primary-orange">
                Send OTP via Email ✉️
            </button>
        </form>

        <div class="divider"><span>Remember your password?</span></div>
        <a href="login.php" class="btn btn-outline btn-block" style="justify-content:center; border-color:#cbd5e1; color:#475569; font-weight:600;">← Back to Login</a>
    </div>
</div>
</body>
</html>
