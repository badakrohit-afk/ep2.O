<?php
// api/download_sample_template.php — Download Sample Questions CSV / Excel Template
require_once dirname(__DIR__) . '/config.php';

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="sample_questions_template.csv"');

$output = fopen('php://output', 'w');

// Header row
fputcsv($output, ['Question', 'Option A', 'Option B', 'Option C', 'Option D', 'Correct Answer (A-D)', 'Marks']);

// Sample row 1
fputcsv($output, [
    'What does PHP stand for?',
    'Personal Home Page',
    'Hypertext Preprocessor',
    'Preprocessed Home Page',
    'Programming Home Processor',
    'B',
    '1'
]);

// Sample row 2
fputcsv($output, [
    'Which keyword is used to declare a constant in PHP?',
    'var',
    'const',
    'define',
    'final',
    'B',
    '1'
]);

// Sample row 3
fputcsv($output, [
    'What will echo 5 + 3 * 2 output in PHP?',
    '16',
    '11',
    '10',
    '13',
    'B',
    '2'
]);

// Sample row 4
fputcsv($output, [
    'Which HTML tag is used to define an unordered list?',
    '<ul>',
    '<ol>',
    '<li>',
    '<list>',
    'A',
    '1'
]);

fclose($output);
exit;
?>
