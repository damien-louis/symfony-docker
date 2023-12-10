<?php

declare(strict_types=1);

return [
    'preset' => 'symfony',
    'exclude' => [
        'tests/bootstrap.php',
    ],
    'ide' => 'vscode',
    'requirements' => [
        'min-quality' => 100,
        'min-complexity' => 85,
        'min-architecture' => 100,
        'min-style' => 100,
        'disable-security-check' => true,
    ],
];
