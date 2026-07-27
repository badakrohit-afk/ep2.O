<?php
// api/download_sample_template.php — Download Clean Editable Sample Questions Excel / CSV Template
ini_set('display_errors', '0');
error_reporting(0);
while (ob_get_level()) {
    ob_end_clean();
}

require_once dirname(__DIR__) . '/config.php';

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="questions_import_template.csv"');
header('Pragma: no-cache');
header('Expires: 0');

// Output UTF-8 BOM so Excel and Numbers open it as a pristine table
echo "\xEF\xBB\xBF";

$output = fopen('php://output', 'w');

// Header row
fputcsv($output, ['Question', 'Option A', 'Option B', 'Option C', 'Option D', 'Correct Answer (A-D)', 'Marks'], ',', '"', '\\');

$sample_data = [
    [
        'Which of the following is the correct syntax to output "Hello World" in C++?',
        'cout << "Hello World";',
        'Console.WriteLine("Hello World");',
        'System.out.println("Hello World");',
        'print("Hello World");',
        'A',
        '1'
    ],
    [
        'Which header file is required for standard C++ input and output operations (cin/cout)?',
        '<stdio.h>',
        '<iostream>',
        '<stdlib.h>',
        '<conio.h>',
        'B',
        '1'
    ],
    [
        'What is the standard size of int data type in standard 32-bit/64-bit C++ compilers?',
        '2 Bytes',
        '4 Bytes',
        '8 Bytes',
        '1 Byte',
        'B',
        '1'
    ],
    [
        'Which feature of C++ Object Oriented Programming allows creating a new class from an existing class?',
        'Polymorphism',
        'Encapsulation',
        'Inheritance',
        'Abstraction',
        'C',
        '1'
    ],
    [
        'Which operator is used to allocate memory dynamically in C++?',
        'malloc',
        'alloc',
        'new',
        'create',
        'C',
        '1'
    ],
    [
        'Which keyword is used to define an unmodifiable constant variable in C++?',
        'constant',
        'final',
        'const',
        'static',
        'C',
        '1'
    ],
    [
        'Which access specifier makes class members accessible only within the same class definition?',
        'public',
        'protected',
        'private',
        'internal',
        'C',
        '1'
    ],
    [
        'What is the default required return type of the main() entry function in C++?',
        'void',
        'int',
        'float',
        'char',
        'B',
        '1'
    ],
    [
        'Which operator keyword is used to deallocate dynamic memory allocated with new in C++?',
        'free()',
        'delete',
        'remove()',
        'clear()',
        'B',
        '1'
    ],
    [
        'Which C++ concept allows multiple functions with the same name but different parameter lists?',
        'Function Overloading',
        'Function Overriding',
        'Virtual Functions',
        'Friend Functions',
        'A',
        '1'
    ]
];

foreach ($sample_data as $row) {
    fputcsv($output, $row, ',', '"', '\\');
}

fclose($output);
exit;
?>
