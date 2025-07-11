<?php
require_once 'config/database.php';
require_once 'config/session.php';
requireLogin();

header('Content-Type: application/json');

try {
    // Get date parameters from request
    $startDate = $_GET['start_date'] ?? null;
    $endDate = $_GET['end_date'] ?? null;
    
    // Log the date parameters for debugging
    error_log("Financial Report - Start Date: " . ($startDate ?? 'null'));
    error_log("Financial Report - End Date: " . ($endDate ?? 'null'));
    
    // Prepare WHERE clause for date filtering
    $whereClause = "";
    $params = [];
    
    if ($startDate && $endDate) {
        $whereClause = "WHERE tanggal_pengeluaran BETWEEN ? AND ?";
        $params = [$startDate, $endDate];
        error_log("Financial Report - Expenses WHERE clause: " . $whereClause);
        error_log("Financial Report - Expenses params: " . implode(', ', $params));
    }

    // Get expenses with date filter
    $stmtExpenses = $pdo->prepare("
        SELECT pengeluaran.*, user.name as user_name 
        FROM pengeluaran 
        JOIN user ON pengeluaran.id_user = user.id_user 
        {$whereClause}
        ORDER BY pengeluaran.tanggal_pengeluaran DESC
    ");
    $stmtExpenses->execute($params);
    $expenses = $stmtExpenses->fetchAll(PDO::FETCH_ASSOC);

    // Get total expenses with date filter
    $stmt = $pdo->prepare("SELECT COALESCE(SUM(jumlah_pengeluaran), 0) as total FROM pengeluaran {$whereClause}");
    $stmt->execute($params);
    $totalExpenses = $stmt->fetch(PDO::FETCH_ASSOC)['total'];

    // Prepare WHERE clause for transactions date filtering
    $transWhereClause = "";
    $transParams = [];
    
    if ($startDate && $endDate) {
        $transWhereClause = "WHERE t.tanggal_terima BETWEEN ? AND ?";
        $transParams = [$startDate, $endDate];
        error_log("Financial Report - Transactions WHERE clause: " . $transWhereClause);
        error_log("Financial Report - Transactions params: " . implode(', ', $transParams));
    }

    // Get transactions with date filter
    $stmtTransactions = $pdo->prepare("
        SELECT t.*, 
               p.name_pelanggan,
               l.jenis_laundry,
               u.name as user_name
        FROM transaksi t
        JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
        JOIN paket_laundry l ON t.id_paket = l.id_paket
        JOIN user u ON t.id_user = u.id_user
        {$transWhereClause}
        ORDER BY t.tanggal_terima DESC
    ");
    $stmtTransactions->execute($transParams);
    $transactions = $stmtTransactions->fetchAll(PDO::FETCH_ASSOC);

    // Get total transactions with date filter
    $stmt = $pdo->prepare("SELECT COALESCE(SUM(total_bayar), 0) as total FROM transaksi t {$transWhereClause}");
    $stmt->execute($transParams);
    $totalTransactions = $stmt->fetch(PDO::FETCH_ASSOC)['total'];

    $reportData = [
        'expenses' => $expenses,
        'totalExpenses' => $totalExpenses,
        'transactions' => $transactions,
        'totalTransactions' => $totalTransactions,
        'dateRange' => [
            'start_date' => $startDate,
            'end_date' => $endDate
        ]
    ];

    echo json_encode($reportData);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
    exit();
}
?> 