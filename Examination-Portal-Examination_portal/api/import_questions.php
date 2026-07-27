<?php
// api/import_questions.php — Bulletproof AJAX Endpoint to Import Questions from Excel/CSV/Pasted Text
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
    echo json_encode(['success' => false, 'message' => 'Please select an exam before importing questions.']);
    exit;
}

$exam = get_exam_by_id($exam_id);
if (!$exam) {
    echo json_encode(['success' => false, 'message' => 'Selected exam not found.']);
    exit;
}

if (!has_role('admin') && (int)$exam['created_by'] !== $user_id) {
    echo json_encode(['success' => false, 'message' => 'You do not have permission to modify this exam.']);
    exit;
}

$raw_rows = [];

// Handle Copy-Pasted Text Mode
if (!empty($_POST['pasted_text'])) {
    $text_lines = explode("\n", $_POST['pasted_text']);
    foreach ($text_lines as $line) {
        $line = trim($line);
        if ($line === '') continue;
        $cols = (strpos($line, "\t") !== false) ? explode("\t", $line) : str_getcsv($line, ',');
        if (array_filter($cols)) {
            $raw_rows[] = array_map('trim', $cols);
        }
    }
}
// Handle File Upload Mode (.xlsx, .xls, .csv, .txt)
elseif (!empty($_FILES['excel_file']['tmp_name']) && $_FILES['excel_file']['error'] === UPLOAD_ERR_OK) {
    $file_tmp  = $_FILES['excel_file']['tmp_name'];
    $file_name = $_FILES['excel_file']['name'];
    $file_size = $_FILES['excel_file']['size'] ?? 0;
    $file_ext  = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));

    // Enforce 10 MB file size limit (10 * 1024 * 1024 bytes)
    if ($file_size > 10 * 1024 * 1024) {
        echo json_encode([
            'success' => false,
            'message' => 'File size exceeds the 10 MB limit. Please upload a file smaller than 10 MB.'
        ]);
        exit;
    }

    if (in_array($file_ext, ['csv', 'txt'])) {
        $content = file_get_contents($file_tmp);
        // Strip UTF-8 BOM
        $bom = pack('H*', 'EFBBBF');
        $content = preg_replace("/^$bom/", '', $content);
        
        $lines = explode("\n", $content);
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line === '') continue;
            $delimiter = (strpos($line, "\t") !== false) ? "\t" : ((strpos($line, ";") !== false) ? ";" : ",");
            $cols = str_getcsv($line, $delimiter, '"', '\\');
            if (array_filter($cols)) {
                $raw_rows[] = array_map('trim', $cols);
            }
        }
    } elseif (in_array($file_ext, ['xlsx', 'xls'])) {
        // Try Composer PhpSpreadsheet first if available
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
                        $raw_rows[] = $rowData;
                    }
                }
            } catch (Throwable $e) {
                // Ignore and fall back to ZipArchive XML Parser
            }
        }

        // Native ZipArchive XML Parser for .xlsx
        if (empty($raw_rows) && class_exists('ZipArchive')) {
            $zip = new ZipArchive();
            if ($zip->open($file_tmp) === true) {
                $strings = [];
                // Load Shared Strings
                if (($sharedStringXML = $zip->getFromName('xl/sharedStrings.xml')) !== false) {
                    $xml = @simplexml_load_string($sharedStringXML);
                    if ($xml) {
                        foreach ($xml->si as $val) {
                            if (isset($val->t)) {
                                $strings[] = (string)$val->t;
                            } elseif (isset($val->r)) {
                                $t_buf = '';
                                foreach ($val->r as $r_node) {
                                    $t_buf .= (string)$r_node->t;
                                }
                                $strings[] = $t_buf;
                            } else {
                                $strings[] = (string)$val;
                            }
                        }
                    }
                }

                // Load Worksheet XMLs
                for ($sheetIdx = 1; $sheetIdx <= 3; $sheetIdx++) {
                    if (($sheetXML = $zip->getFromName("xl/worksheets/sheet{$sheetIdx}.xml")) !== false) {
                        $xml = @simplexml_load_string($sheetXML);
                        if ($xml && isset($xml->sheetData->row)) {
                            foreach ($xml->sheetData->row as $r) {
                                $rowData = [];
                                foreach ($r->c as $c) {
                                    $v = (string)$c->v;
                                    $t = (string)($c['t'] ?? '');
                                    if ($t === 's' && isset($strings[(int)$v])) {
                                        $v = $strings[(int)$v];
                                    } elseif (isset($c->is->t)) {
                                        $v = (string)$c->is->t;
                                    }
                                    $rowData[] = trim($v);
                                }
                                if (array_filter($rowData)) {
                                    $raw_rows[] = $rowData;
                                }
                            }
                            if (!empty($raw_rows)) break;
                        }
                    }
                }
                $zip->close();
            }
        }
    }
}

if (empty($raw_rows)) {
    echo json_encode([
        'success' => false,
        'message' => 'No readable questions found in the file. Please check your file or try using the Copy & Paste option.'
    ]);
    exit;
}

// ── Smart Dynamic Column Indexing ─────────────────────────────────────────────
$col_q    = 0;
$col_opt1 = 1;
$col_opt2 = 2;
$col_opt3 = 3;
$col_opt4 = 4;
$col_ans  = 5;
$col_mark = 6;
$start_row_idx = 0;

// Inspect first 5 rows for header row
for ($r = 0; $r < min(5, count($raw_rows)); $r++) {
    $row_lower = array_map('strtolower', $raw_rows[$r]);
    $matched_cols = 0;
    
    foreach ($row_lower as $idx => $cell_val) {
        if (preg_match('/question|qtext|q_text|problem/i', $cell_val)) { $col_q = $idx; $matched_cols++; }
        elseif (preg_match('/option\s*a|opt\s*a|option\s*1|opt\s*1|choice\s*a/i', $cell_val)) { $col_opt1 = $idx; $matched_cols++; }
        elseif (preg_match('/option\s*b|opt\s*b|option\s*2|opt\s*2|choice\s*b/i', $cell_val)) { $col_opt2 = $idx; $matched_cols++; }
        elseif (preg_match('/option\s*c|opt\s*c|option\s*3|opt\s*3|choice\s*c/i', $cell_val)) { $col_opt3 = $idx; $matched_cols++; }
        elseif (preg_match('/option\s*d|opt\s*d|option\s*4|opt\s*4|choice\s*d/i', $cell_val)) { $col_opt4 = $idx; $matched_cols++; }
        elseif (preg_match('/answer|correct|key|ans/i', $cell_val)) { $col_ans = $idx; $matched_cols++; }
        elseif (preg_match('/mark|score|point/i', $cell_val)) { $col_mark = $idx; $matched_cols++; }
    }
    
    if ($matched_cols >= 3) {
        $start_row_idx = $r + 1; // Skip header row
        break;
    }
}

// ── Database & Duplicate Setup ────────────────────────────────────────────────
global $pdo;
$existing_stmt = $pdo->prepare("SELECT LOWER(TRIM(question)) FROM questions WHERE exam_id = ?");
$existing_stmt->execute([$exam_id]);
$existing_questions = array_flip($existing_stmt->fetchAll(PDO::FETCH_COLUMN));

$imported_count = 0;
$skipped_count  = 0;
$invalid_count  = 0;
$details        = [];

for ($i = $start_row_idx; $i < count($raw_rows); $i++) {
    $row_num = $i + 1;
    $row = $raw_rows[$i];

    $q_text  = $row[$col_q] ?? ($row[0] ?? '');
    $opt1    = $row[$col_opt1] ?? ($row[1] ?? '');
    $opt2    = $row[$col_opt2] ?? ($row[2] ?? '');
    $opt3    = $row[$col_opt3] ?? ($row[3] ?? 'N/A');
    $opt4    = $row[$col_opt4] ?? ($row[4] ?? 'N/A');
    $ans_raw = $row[$col_ans] ?? ($row[5] ?? 'A');
    $marks   = max(1, (int)($row[$col_mark] ?? ($row[6] ?? 1)));

    if ($opt3 === '') $opt3 = 'N/A';
    if ($opt4 === '') $opt4 = 'N/A';

    // Must have question text and at least 2 options
    if (empty($q_text) || empty($opt1) || empty($opt2)) {
        $invalid_count++;
        $details[] = "Row {$row_num}: Skipped (Missing question text or options).";
        continue;
    }

    // Duplicate Check
    $q_normalized = strtolower(trim($q_text));
    if (isset($existing_questions[$q_normalized])) {
        $skipped_count++;
        $details[] = "Row {$row_num}: Skipped (Duplicate question already exists).";
        continue;
    }

    // Smart Answer Mapper -> opt1, opt2, opt3, opt4
    $ans_norm = strtolower(trim($ans_raw));
    $ans_val  = 'opt1';

    if (in_array($ans_norm, ['a', '1', 'opt1', 'option a', 'option 1', 'opta', 'choice a'])) {
        $ans_val = 'opt1';
    } elseif (in_array($ans_norm, ['b', '2', 'opt2', 'option b', 'option 2', 'optb', 'choice b'])) {
        $ans_val = 'opt2';
    } elseif (in_array($ans_norm, ['c', '3', 'opt3', 'option c', 'option 3', 'optc', 'choice c'])) {
        $ans_val = 'opt3';
    } elseif (in_array($ans_norm, ['d', '4', 'opt4', 'option d', 'option 4', 'optd', 'choice d'])) {
        $ans_val = 'opt4';
    } elseif (strtolower($ans_raw) === strtolower($opt1)) {
        $ans_val = 'opt1';
    } elseif (strtolower($ans_raw) === strtolower($opt2)) {
        $ans_val = 'opt2';
    } elseif (strtolower($ans_raw) === strtolower($opt3)) {
        $ans_val = 'opt3';
    } elseif (strtolower($ans_raw) === strtolower($opt4)) {
        $ans_val = 'opt4';
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
        $details[] = "Row {$row_num}: DB Error ({$e->getMessage()}).";
    }
}

// Recalculate exam total marks
if ($imported_count > 0) {
    $total_stmt = $pdo->prepare("SELECT SUM(marks) FROM questions WHERE exam_id = ?");
    $total_stmt->execute([$exam_id]);
    $total_marks = (int)$total_stmt->fetchColumn();
    $pdo->prepare("UPDATE exams SET total_marks = ? WHERE id = ?")->execute([$total_marks, $exam_id]);
}

$summary_msg = "Successfully imported {$imported_count} question(s)!";
if ($skipped_count > 0 || $invalid_count > 0) {
    $summary_msg .= " ({$skipped_count} duplicates skipped, {$invalid_count} invalid).";
}

echo json_encode([
    'success'  => ($imported_count > 0 || ($skipped_count > 0 && $invalid_count == 0)),
    'imported' => $imported_count,
    'skipped'  => $skipped_count,
    'invalid'  => $invalid_count,
    'message'  => $summary_msg,
    'details'  => $details
]);
exit;
?>
