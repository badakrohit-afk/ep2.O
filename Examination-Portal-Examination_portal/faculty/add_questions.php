<?php
// faculty/add_questions.php — Add / edit / delete questions
require_once dirname(__DIR__) . '/config.php';
require_once dirname(__DIR__) . '/includes/functions.php';
require_role('faculty','admin');

$user_id = (int)$_SESSION['user_id'];
global $pdo;

// Get exams belonging to this user
$my_exams = get_exams_by_creator($user_id);

// Selected exam
$exam_id = (int)($_GET['exam_id'] ?? $_POST['exam_id'] ?? 0);
$exam = $exam_id ? get_exam_by_id($exam_id) : null;

$error   = '';
$success = '';

// ── Handle Actions ────────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';

    if ($action === 'add') {
        $question = trim($_POST['question'] ?? '');
        $opt1     = trim($_POST['opt1'] ?? '');
        $opt2     = trim($_POST['opt2'] ?? '');
        $opt3     = trim($_POST['opt3'] ?? '');
        $opt4     = trim($_POST['opt4'] ?? '');
        $answer   = trim($_POST['answer'] ?? '');
        $marks    = max(1, (int)($_POST['marks'] ?? 1));

        if (!$exam_id || !$question || !$opt1 || !$opt2 || !$opt3 || !$opt4 || !$answer) {
            $error = 'All fields are required.';
        } else {
            add_question(compact('exam_id','question','opt1','opt2','opt3','opt4','answer','marks'));
            // Update total marks
            $total = $pdo->prepare("SELECT SUM(marks) FROM questions WHERE exam_id=?");
            $total->execute([$exam_id]);
            $pdo->prepare("UPDATE exams SET total_marks=? WHERE id=?")->execute([$total->fetchColumn(), $exam_id]);
            flash('success', 'Question added successfully!');
            redirect($_SERVER['REQUEST_URI']);
        }
    }

    if ($action === 'delete') {
        $q_id = (int)($_POST['q_id'] ?? 0);
        delete_question($q_id);
        flash('success', 'Question deleted.');
        redirect($_SERVER['REQUEST_URI']);
    }

    if ($action === 'edit') {
        update_question([
            'id'       => (int)$_POST['q_id'],
            'question' => trim($_POST['question']),
            'opt1'     => trim($_POST['opt1']),
            'opt2'     => trim($_POST['opt2']),
            'opt3'     => trim($_POST['opt3']),
            'opt4'     => trim($_POST['opt4']),
            'answer'   => trim($_POST['answer']),
            'marks'    => max(1,(int)$_POST['marks']),
        ]);
        flash('success', 'Question updated!');
        redirect($_SERVER['REQUEST_URI']);
    }
}

$questions = $exam_id ? get_questions_by_exam($exam_id) : [];
$flash_s = get_flash('success');
$flash_e = get_flash('error');

$page_title = 'Add Questions';
require_once dirname(__DIR__) . '/includes/header.php';
?>

<div class="page-header flex-between">
    <div>
        <h2>❓ Manage Questions</h2>
        <p>Add, edit or delete MCQ questions for your exams</p>
    </div>
    <?php if ($exam): ?>
        <div style="display:flex; gap:10px; align-items:center;">
            <button type="button" class="btn btn-primary btn-sm" onclick="openImportExcelModal()" style="display:inline-flex; align-items:center; gap:6px; background:#FF6B00; border:none; color:#ffffff; font-weight:600; box-shadow:0 4px 12px rgba(255,107,0,0.25);">
                📥 Import Excel
            </button>
            <a href="create_exam.php" class="btn btn-outline btn-sm">+ New Exam</a>
        </div>
    <?php endif; ?>
</div>

<!-- Exam Selector -->
<div class="card mb-24">
    <div class="card-body">
        <form method="GET" style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap;width:100%;margin:0;">
            <div class="form-group mb-0" style="flex:1;min-width:200px;">
                <label class="form-label">Select Exam</label>
                <select name="exam_id" class="form-control" onchange="this.form.submit()" style="height: 42px;">
                    <option value="">— Choose an exam —</option>
                    <?php foreach ($my_exams as $e): ?>
                        <option value="<?= $e['id'] ?>" <?= $exam_id === (int)$e['id'] ? 'selected' : '' ?>>
                            <?= h($e['title']) ?> (<?= $e['question_count'] ?> Qs)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
        </form>
    </div>
</div>

<?php if ($flash_s): ?><div class="alert alert-success">✅ <?= h($flash_s) ?></div><?php endif; ?>
<?php if ($flash_e || $error): ?><div class="alert alert-error">❌ <?= h($flash_e ?: $error) ?></div><?php endif; ?>

<?php if ($exam): ?>
<div class="grid-2" style="align-items:start;">
    <!-- Add Question Form -->
    <div class="card">
        <div class="card-header"><h3>➕ Add New Question</h3></div>
        <div class="card-body">
            <form method="POST" action="" id="add-q-form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="exam_id" value="<?= $exam_id ?>">
                <div class="form-group">
                    <label class="form-label">Question *</label>
                    <textarea name="question" class="form-control" rows="3" required placeholder="Enter your question here..."></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Option A *</label>
                        <input type="text" name="opt1" class="form-control" placeholder="Option A" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Option B *</label>
                        <input type="text" name="opt2" class="form-control" placeholder="Option B" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Option C *</label>
                        <input type="text" name="opt3" class="form-control" placeholder="Option C" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Option D *</label>
                        <input type="text" name="opt4" class="form-control" placeholder="Option D" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Correct Answer *</label>
                        <select name="answer" id="answer-select" class="form-control" required>
                            <option value="">— Select correct option —</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Marks *</label>
                        <input type="number" name="marks" class="form-control" value="1" min="1" max="10" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Add Question →</button>
            </form>
        </div>
    </div>

    <!-- Questions List -->
    <div>
        <div class="card">
            <div class="card-header">
                <h3>📋 Questions (<?= count($questions) ?>)</h3>
                <span style="color:var(--text-muted);font-size:0.8rem;">Total Marks: <?= array_sum(array_column($questions,'marks')) ?></span>
            </div>
            <?php if ($questions): ?>
            <div style="max-height:600px;overflow-y:auto;">
                <?php foreach ($questions as $idx => $q): ?>
                <div style="padding:16px 20px;border-bottom:1px solid var(--border);">
                    <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:8px;margin-bottom:8px;">
                        <span style="font-size:0.75rem;color:var(--purple-3);font-weight:600;">Q<?= $idx+1 ?> · <?= $q['marks'] ?> mark<?= $q['marks']>1?'s':'' ?></span>
                        <div style="display:flex;gap:6px;">
                            <button onclick="editQuestion(<?= htmlspecialchars(json_encode($q)) ?>)"
                                    class="btn btn-warning btn-sm">Edit</button>
                            <form method="POST" style="display:inline;" onsubmit="return confirm('Delete this question?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="exam_id" value="<?= $exam_id ?>">
                                <input type="hidden" name="q_id" value="<?= $q['id'] ?>">
                                <button type="submit" class="btn btn-danger btn-sm">Del</button>
                            </form>
                        </div>
                    </div>
                    <p style="font-size:0.87rem;font-weight:500;margin-bottom:8px;"><?= h($q['question']) ?></p>
                    <div style="font-size:0.78rem;color:var(--text-muted);display:grid;grid-template-columns:1fr 1fr;gap:4px;">
                        <span>A: <?= h($q['opt1']) ?></span>
                        <span>B: <?= h($q['opt2']) ?></span>
                        <span>C: <?= h($q['opt3']) ?></span>
                        <span>D: <?= h($q['opt4']) ?></span>
                    </div>
                    <div style="margin-top:8px;font-size:0.78rem;color:var(--green);">✓ Correct: <?= h($q['answer']) ?></div>
                </div>
                <?php endforeach; ?>
            </div>
            <?php else: ?>
            <div class="card-body">
                <div class="empty-state" style="padding:30px;">
                    <span class="empty-icon">❓</span>
                    <h3>No questions yet</h3>
                    <p>Add your first question using the form.</p>
                </div>
            </div>
            <?php endif; ?>
        </div>

        <?php if (count($questions) > 0): ?>
        <div style="display:flex;gap:10px;margin-top:12px;">
            <a href="schedule_exam.php?exam_id=<?= $exam_id ?>" class="btn btn-warning">📅 Schedule This Exam</a>
        </div>
        <?php endif; ?>
    </div>
</div>

<!-- Edit Modal -->
<div id="edit-modal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.8);z-index:500;align-items:center;justify-content:center;">
    <div style="background:#0f0f20;border:1px solid var(--border);border-radius:16px;padding:28px;width:90%;max-width:600px;max-height:90vh;overflow-y:auto;">
        <h3 style="margin-bottom:20px;">✏️ Edit Question</h3>
        <form method="POST" action="">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="exam_id" value="<?= $exam_id ?>">
            <input type="hidden" name="q_id" id="edit-q-id">
            <div class="form-group">
                <label class="form-label">Question</label>
                <textarea name="question" id="edit-question" class="form-control" rows="3" required></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Option A</label>
                    <input type="text" name="opt1" id="edit-opt1" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Option B</label>
                    <input type="text" name="opt2" id="edit-opt2" class="form-control" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Option C</label>
                    <input type="text" name="opt3" id="edit-opt3" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Option D</label>
                    <input type="text" name="opt4" id="edit-opt4" class="form-control" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Correct Answer</label>
                    <select name="answer" id="edit-answer" class="form-control" required></select>
                </div>
                <div class="form-group">
                    <label class="form-label">Marks</label>
                    <input type="number" name="marks" id="edit-marks" class="form-control" min="1" required>
                </div>
            </div>
            <div style="display:flex;gap:10px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <button type="button" onclick="closeModal()" class="btn btn-outline">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
// Dynamically populate answer select from options
const addForm = document.getElementById('add-q-form');
const answerSel = document.getElementById('answer-select');
['opt1','opt2','opt3','opt4'].forEach(function(f){
    document.querySelector('[name="'+f+'"]').addEventListener('input', refreshSelect);
});
function refreshSelect() {
    const opts = ['opt1','opt2','opt3','opt4'].map(f => document.querySelector('[name="'+f+'"]').value).filter(v=>v);
    const cur = answerSel.value;
    answerSel.innerHTML = '<option value="">— Select correct option —</option>';
    opts.forEach(o => { const op = document.createElement('option'); op.value=o; op.textContent=o; if(o===cur)op.selected=true; answerSel.appendChild(op); });
}

function editQuestion(q) {
    document.getElementById('edit-q-id').value    = q.id;
    document.getElementById('edit-question').value = q.question;
    document.getElementById('edit-opt1').value     = q.opt1;
    document.getElementById('edit-opt2').value     = q.opt2;
    document.getElementById('edit-opt3').value     = q.opt3;
    document.getElementById('edit-opt4').value     = q.opt4;
    document.getElementById('edit-marks').value    = q.marks;
    const sel = document.getElementById('edit-answer');
    sel.innerHTML = '';
    [q.opt1,q.opt2,q.opt3,q.opt4].forEach(o => {
        const op = document.createElement('option'); op.value=o; op.textContent=o;
        if(o===q.answer)op.selected=true; sel.appendChild(op);
    });
    const modal = document.getElementById('edit-modal');
    modal.style.display='flex';
}
function closeModal() { document.getElementById('edit-modal').style.display='none'; }
document.getElementById('edit-modal').addEventListener('click', function(e){if(e.target===this)closeModal();});
</script>

<!-- Import Excel / CSV Modal -->
<div id="importExcelModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.65); backdrop-filter:blur(4px); z-index:9999; justify-content:center; align-items:center; padding:20px;">
    <div style="background:#ffffff; border-radius:16px; width:100%; max-width:540px; box-shadow:0 20px 40px rgba(0,0,0,0.25); overflow:hidden; border:1px solid #e2e8f0; animation:fadeIn 0.25s ease;">
        
        <!-- Modal Header -->
        <div style="background:#1e293b; color:#ffffff; padding:18px 24px; display:flex; justify-content:space-between; align-items:center;">
            <h3 style="margin:0; font-size:1.15rem; font-weight:600; display:flex; align-items:center; gap:8px;">
                <span>📥</span> Import Questions from Excel / CSV
            </h3>
            <button type="button" onclick="closeImportExcelModal()" style="background:none; border:none; color:#94a3b8; font-size:1.5rem; cursor:pointer; line-height:1; transition:color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#94a3b8'">&times;</button>
        </div>
        
        <!-- Modal Body -->
        <div style="padding:24px; color:#1e293b;">
            
            <!-- Sample Download Template -->
            <div style="background:#f8fafc; border:1px solid #e2e8f0; border-left:4px solid #FF6B00; border-radius:10px; padding:14px 16px; margin-bottom:20px; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:10px;">
                <div>
                    <strong style="color:#1e293b; font-size:0.9rem;">Need a sample file?</strong>
                    <p style="margin:2px 0 0 0; color:#64748b; font-size:0.8rem;">Download template with pre-filled columns</p>
                </div>
                <a href="<?= BASE_URL ?>/api/download_sample_template.php" class="btn btn-sm" style="background:#fff; border:1.5px solid #FF6B00; color:#FF6B00; font-weight:600; font-size:0.82rem; text-decoration:none; padding:6px 14px; border-radius:8px;">
                    ⬇️ Download Template
                </a>
            </div>

            <!-- File Drop Zone -->
            <form id="importExcelForm" enctype="multipart/form-data" onsubmit="handleImportExcelSubmit(event)">
                <input type="hidden" name="exam_id" value="<?= (int)$exam_id ?>">
                
                <div id="excel_dropzone" style="border:2px dashed #cbd5e1; border-radius:12px; padding:30px 20px; text-align:center; background:#fafafa; cursor:pointer; transition:all 0.2s;" onclick="document.getElementById('excel_file_input').click()" ondragover="event.preventDefault(); this.style.borderColor='#FF6B00'; this.style.background='rgba(255,107,0,0.04)';" ondragleave="this.style.borderColor='#cbd5e1'; this.style.background='#fafafa';" ondrop="handleExcelFileDrop(event)">
                    
                    <div style="font-size:2.5rem; margin-bottom:8px;">📊</div>
                    <p style="margin:0; font-weight:600; color:#334155; font-size:0.95rem;">Click to upload or drag & drop</p>
                    <p style="margin:4px 0 0 0; color:#94a3b8; font-size:0.8rem;">Supports .xlsx, .xls, or .csv files</p>
                    
                    <input type="file" id="excel_file_input" name="excel_file" accept=".xlsx,.xls,.csv" style="display:none;" onchange="handleExcelFileSelect(this)">
                    
                    <div id="excel_file_info" style="display:none; margin-top:12px; padding:8px 12px; background:#fff; border:1px solid #e2e8f0; border-radius:8px; align-items:center; gap:8px; color:#FF6B00; font-weight:600; font-size:0.85rem;">
                        <span id="excel_file_name">selected_file.xlsx</span>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div id="import_progress_container" style="display:none; margin-top:16px;">
                    <div style="display:flex; justify-content:space-between; font-size:0.8rem; color:#64748b; margin-bottom:6px;">
                        <span>Uploading & Parsing file...</span>
                        <span id="import_progress_percent">0%</span>
                    </div>
                    <div style="background:#e2e8f0; border-radius:99px; height:8px; overflow:hidden;">
                        <div id="import_progress_bar" style="background:#FF6B00; height:100%; width:0%; transition:width 0.3s ease;"></div>
                    </div>
                </div>

                <!-- Alert Result Summary Box -->
                <div id="import_result_box" style="display:none; margin-top:16px; border-radius:10px; padding:14px; font-size:0.85rem;"></div>

                <!-- Modal Footer Actions -->
                <div style="margin-top:24px; display:flex; justify-content:flex-end; gap:12px;">
                    <button type="button" onclick="closeImportExcelModal()" class="btn btn-outline" style="border-color:#cbd5e1; color:#475569;">Cancel</button>
                    <button type="submit" id="btn_import_submit" class="btn" style="background:#FF6B00; color:#fff; font-weight:600; padding:10px 24px; border:none; border-radius:8px; cursor:pointer;">
                        🚀 Start Import
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openImportExcelModal() {
    document.getElementById('importExcelModal').style.display = 'flex';
}
function closeImportExcelModal() {
    document.getElementById('importExcelModal').style.display = 'none';
    document.getElementById('import_result_box').style.display = 'none';
    document.getElementById('import_progress_container').style.display = 'none';
}
function handleExcelFileSelect(input) {
    if (input.files && input.files[0]) {
        document.getElementById('excel_file_name').innerText = '📄 ' + input.files[0].name;
        document.getElementById('excel_file_info').style.display = 'inline-flex';
    }
}
function handleExcelFileDrop(e) {
    e.preventDefault();
    document.getElementById('excel_dropzone').style.borderColor = '#cbd5e1';
    document.getElementById('excel_dropzone').style.background = '#fafafa';
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
        const input = document.getElementById('excel_file_input');
        input.files = e.dataTransfer.files;
        handleExcelFileSelect(input);
    }
}
function handleImportExcelSubmit(e) {
    e.preventDefault();
    const fileInput = document.getElementById('excel_file_input');
    if (!fileInput.files || !fileInput.files[0]) {
        alert('Please select an Excel or CSV file to upload.');
        return;
    }

    const btn = document.getElementById('btn_import_submit');
    const progressBox = document.getElementById('import_progress_container');
    const progressBar = document.getElementById('import_progress_bar');
    const progressPercent = document.getElementById('import_progress_percent');
    const resultBox = document.getElementById('import_result_box');

    btn.disabled = true;
    btn.innerText = 'Importing...';
    progressBox.style.display = 'block';
    progressBar.style.width = '40%';
    progressPercent.innerText = '40%';
    resultBox.style.display = 'none';

    const formData = new FormData(document.getElementById('importExcelForm'));

    fetch('<?= BASE_URL ?>/api/import_questions.php', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        progressBar.style.width = '100%';
        progressPercent.innerText = '100%';
        btn.disabled = false;
        btn.innerText = '🚀 Start Import';

        if (data.success) {
            resultBox.style.background = 'rgba(16,185,129,0.08)';
            resultBox.style.border = '1px solid rgba(16,185,129,0.3)';
            resultBox.style.color = '#059669';
            
            let html = '<strong>' + data.message + '</strong>';
            if (data.details && data.details.length > 0) {
                html += '<ul style="margin:8px 0 0 0; padding-left:18px; font-size:0.8rem; color:#475569; max-height:120px; overflow-y:auto;">';
                data.details.forEach(d => { html += '<li>' + d + '</li>'; });
                html += '</ul>';
            }
            resultBox.innerHTML = html;
            resultBox.style.display = 'block';

            if (data.imported > 0) {
                setTimeout(() => {
                    window.location.reload();
                }, 1600);
            }
        } else {
            resultBox.style.background = 'rgba(239,68,68,0.08)';
            resultBox.style.border = '1px solid rgba(239,68,68,0.3)';
            resultBox.style.color = '#dc2626';
            resultBox.innerHTML = '<strong>❌ Import Failed:</strong> ' + (data.message || 'Unknown error');
            resultBox.style.display = 'block';
        }
    })
    .catch(err => {
        btn.disabled = false;
        btn.innerText = '🚀 Start Import';
        resultBox.style.background = 'rgba(239,68,68,0.08)';
        resultBox.style.border = '1px solid rgba(239,68,68,0.3)';
        resultBox.style.color = '#dc2626';
        resultBox.innerHTML = '<strong>❌ Request Error:</strong> ' + err.message;
        resultBox.style.display = 'block';
    });
}
document.getElementById('importExcelModal').addEventListener('click', function(e){if(e.target===this)closeImportExcelModal();});
</script>

<?php endif; // if $exam ?>

<?php require_once dirname(__DIR__) . '/includes/footer.php'; ?>
