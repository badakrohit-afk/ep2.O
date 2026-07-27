<?php
// api/import_questions.php — AJAX Endpoint to Import Questions from Excel/CSV
require_once dirname(__DIR__) . '/config.php';
require_once dirname(__DIR__) . '/includes/functions.php';

header('Content-Type: application/json; charset=utf-8');

if (!is_logged_in() || (!has_role('faculty') && !has_role('admin'))) {
    echo json_encode(['success' => false, 'message' => 'Unauthorized access.']);
    exit;
}

$user_id = (int)$_SESSION['user_id'];
$exam_id = (int)($_POST['exam_id'] ?? 0);

if ($exam_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Please select a valid exam first.']);
    exit;
}

// Verify exam ownership / access
$exam = get_exam_by_id($exam_id);
if (!$exam) {
    echo json_encode(['success' => false, 'message' => 'Selected exam not found.']);
    exit;
}

if (!has_role('admin') && (int)$exam['created_by'] !== $user_id) {
    echo json_encode(['success' => false, 'message' => 'You do not have permission to modify this exam.']);
    exit;
}

if (empty($_FILES['excel_file']['tmp_name']) || $_FILES['excel_file']['error'] !== UPLOAD_ERR_OK) {
    echo json_encode(['success' => false, 'message' => 'Please choose a valid Excel (.xlsx/.xls) or CSV (.csv) file to upload.']);
    exit;
}

$file_tmp  = $_FILES['excel_file']['tmp_name'];
$file_name = $_FILES['excel_file']['name'];
$file_ext  = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));

$allowed_exts = ['csv', 'txt', 'xlsx', 'xls'];
if (!in_array($file_ext, $allowed_exts)) {
    echo json_encode(['success' => false, 'message' => 'Invalid file format. Please upload a .xlsx, .xls, or .csv file.']);
    exit;
}

$rows = [];

// Parse CSV or XLSX
if (in_array($file_ext, ['csv', 'txt'])) {
    $content = file_get_contents($file_tmp);
    // Auto-detect delimiter
    $delimiter = ',';
    if (substr_count($content, "\t") > substr_count($content, ",")) {
        $delimiter = "\t";
    } elseif (substr_count($content, ";") > substr_count($content, ",")) {
        $delimiter = ";";
    }
    
    $handle = fopen($file_tmp, 'r');
    if ($handle) {
        while (($data = fgetcsv($handle, 0, $delimiter)) !== false) {
            // Filter empty lines
            if (array_filter($data)) {
                $rows[] = array_map('trim', $data);
            }
        }
        fclose($handle);
    }
} elseif (in_array($file_ext, ['xlsx', 'xls'])) {
    // Attempt PhpSpreadsheet if installed via vendor/autoload.php
    $vendor_autoload = dirname(__DIR__) . '/vendor/autoload.php';
    if (file_exists($vendor_autoload)) {
        require_once $vendor_autoload;
    }
    
    if (class_exists('PhpOffice\PhpSpreadsheet\IOFactory')) {
        try {
            $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($file_tmp);
            $worksheet = $spreadsheet->getActiveSheet();
            foreach ($worksheet->getRowIterator() as $row) {
                $cellIterator = $row->getCellIterator();
                $cellIterator->setIterateOnlyExistingCells(false);
                $rowData = [];
                foreach ($cellIterator as $cell) {
                    $rowData[] = trim((string)$cell->getValue());
                }
                if (array_filter($rowData)) {
                    $rows[] = $rowData;
                }
            }
        } catch (Throwable $e) {
            echo json_encode(['success' => false, 'message' => 'Error reading Excel file: ' . $e->getMessage()]);
            exit;
        }
    } else {
        // Fallback XLSX Simple XML Unzip Parser
        if (class_exists('ZipArchive')) {
            $zip = new ZipArchive();
            if ($zip->open($file_tmp) === true) {
                $strings = [];
                if (($sharedStringXML = $zip->getFromName('xl/sharedStrings.xml')) !== false) {
                    $xml = simplexml_load_string($sharedStringXML);
                    foreach ($xml->si as $val) {
                        $strings[] = (string)$val->t;
                    }
                }
                
                if (($sheetXML = $zip->getFromName('xl/worksheets/sheet1.xml')) !== false) {
                    $xml = simplexml_load_string($sheetXML);
                    foreach ($xml->sheetData->row as $r) {
                        $rowData = [];
                        foreach ($r->c as $c) {
                            $v = (string)$c->v;
                            if (isset($c['t']) && (string)$c['t'] === 's') {
                                $v = $strings[(int)$v] ?? $v;
                            }
                            $rowData[] = trim($v);
                        }
                        if (array_filter($rowData)) {
                            $rows[] = $rowData;
                        }
                    }
                }
                $zip->close();
            }
        }
        
        if (empty($rows)) {
            echo json_encode(['success' => false, 'message' => 'Unable to parse Excel file directly. Please save your file as CSV (.csv) and try again.']);
            exit;
        }
    }
}

if (empty($rows)) {
    echo json_encode(['success' => false, 'message' => 'The uploaded file is empty.']);
    exit;
}

// Process Rows
$imported_count = 0;
$skipped_count  = 0;
$invalid_count  = 0;
$details        = [];

// Check if first row is header
$first_row = array_map('strtolower', $rows[0]);
$is_header = false;
foreach ($first_row as $cell) {
    if (strpos($cell, 'question') !== false || strpos($cell, 'option') !== false || strpos($cell, 'answer') !== false) {
        $is_header = true;
        break;
    }
}

$start_index = $is_header ? 1 : 0;
global $pdo;

// Fetch existing questions for duplicate checking
$existing_stmt = $pdo->prepare("SELECT LOWER(TRIM(question)) FROM questions WHERE exam_id = ?");
$existing_stmt->execute([$exam_id]);
$existing_questions = array_flip($existing_stmt->fetchAll(PDO::FETCH_COLUMN));

for ($i = $start_index; $i < count($rows); $i++) {
    $row_num = $i + 1;
    $row = $rows[$i];
    
    $q_text  = $row[0] ?? '';
    $opt1    = $row[1] ?? '';
    $opt2    = $row[2] ?? '';
    $opt3    = $row[3] ?? '';
    $opt4    = $row[4] ?? '';
    $ans_raw = $row[5] ?? '';
    $marks   = max(1, (int)($row[6] ?? 1));

    // Validate required fields
    if (empty($q_text) || empty($opt1) || empty($opt2) || empty($opt3) || empty($opt4) || empty($ans_raw)) {
        $invalid_count++;
        $details[] = "Row {$row_num}: Skipped (Missing required fields: question, options, or answer).";
        continue;
    }

    // Duplicate Check
    $q_normalized = strtolower(trim($q_text));
    if (isset($existing_questions[$q_normalized])) {
        $skipped_count++;
        $details[] = "Row {$row_num}: Skipped (Duplicate question already exists in this exam).";
        continue;
    }

    // Resolve Correct Answer -> opt1, opt2, opt3, opt4
    $ans_upper = strtoupper(trim($ans_raw));
    $ans_val = '';
    
    if ($ans_upper === 'A' || $ans_upper === '1' || $ans_upper === 'OPTION A' || $ans_upper === 'OPT1') {
        $ans_val = 'opt1';
    } elseif ($ans_upper === 'B' || $ans_upper === '2' || $ans_upper === 'OPTION B' || $ans_upper === 'OPT2') {
        $ans_val = 'opt2';
    } elseif ($ans_upper === 'C' || $ans_upper === '3' || $ans_upper === 'OPTION C' || $ans_upper === 'OPT3') {
        $ans_val = 'opt3';
    } elseif ($ans_upper === 'D' || $ans_upper === '4' || $ans_upper === 'OPTION D' || $ans_upper === 'OPT4') {
        $ans_val = 'opt4';
    } elseif ($ans_raw === $opt1) {
        $ans_val = 'opt1';
    } elseif ($ans_raw === $opt2) {
        $ans_val = 'opt2';
    } elseif ($ans_raw === $opt3) {
        $ans_val = 'opt3';
    } elseif ($ans_raw === $opt4) {
        $ans_val = 'opt4';
    } else {
        $ans_val = 'opt1';
    }

    // Insert Question
    try {
        add_question([
            'exam_id'  => $exam_id,
            'question' => $q_text,
            'opt1'     => $opt1,
            'opt2'     => $opt2,
            'opt3'     => $opt3,
            'opt4'     => $opt4,
            'answer'   => $ans_val,
            'marks'    => $marks
        ]);
        
        $imported_count++;
        $existing_questions[$q_normalized] = true;
    } catch (Throwable $e) {
        $invalid_count++;
        $details[] = "Row {$row_num}: Database error ({$e->getMessage()}).";
    }
}

// Update exam total marks
if ($imported_count > 0) {
    $total_stmt = $pdo->prepare("SELECT SUM(marks) FROM questions WHERE exam_id = ?");
    $total_stmt->execute([$exam_id]);
    $total_marks = (int)$total_stmt->fetchColumn();
    $pdo->prepare("UPDATE exams SET total_marks = ? WHERE id = ?")->execute([$total_marks, $exam_id]);
}

$summary_msg = "Successfully imported {$imported_count} question(s)!";
if ($skipped_count > 0 || $invalid_count > 0) {
    $summary_msg .= " ({$skipped_count} skipped/duplicates, {$invalid_count} invalid).";
}

echo json_encode([
    'success'  => true,
    'imported' => $imported_count,
    'skipped'  => $skipped_count,
    'invalid'  => $invalid_count,
    'message'  => $summary_msg,
    'details'  => $details
]);
exit;
?>
