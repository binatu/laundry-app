<?php
// Simple test file to verify date filtering functionality
require_once 'config/database.php';

// Test with a specific date range
$startDate = '2024-01-01';
$endDate = '2024-12-31';

echo "<h2>Testing Date Filter Functionality</h2>";
echo "<p>Testing with date range: $startDate to $endDate</p>";

// Test expenses query
$whereClause = "WHERE tanggal_pengeluaran BETWEEN ? AND ?";
$params = [$startDate, $endDate];

$stmtExpenses = $pdo->prepare("
    SELECT pengeluaran.*, user.name as user_name 
    FROM pengeluaran 
    JOIN user ON pengeluaran.id_user = user.id_user 
    {$whereClause}
    ORDER BY pengeluaran.tanggal_pengeluaran DESC
");
$stmtExpenses->execute($params);
$expenses = $stmtExpenses->fetchAll(PDO::FETCH_ASSOC);

echo "<h3>Expenses in date range:</h3>";
echo "<p>Found " . count($expenses) . " expenses</p>";

// Test transactions query
$transWhereClause = "WHERE t.tanggal_terima BETWEEN ? AND ?";
$transParams = [$startDate, $endDate];

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

echo "<h3>Transactions in date range:</h3>";
echo "<p>Found " . count($transactions) . " transactions</p>";

// Test totals
$stmt = $pdo->prepare("SELECT COALESCE(SUM(jumlah_pengeluaran), 0) as total FROM pengeluaran {$whereClause}");
$stmt->execute($params);
$totalExpenses = $stmt->fetch(PDO::FETCH_ASSOC)['total'];

$stmt = $pdo->prepare("SELECT COALESCE(SUM(total_bayar), 0) as total FROM transaksi t {$transWhereClause}");
$stmt->execute($transParams);
$totalTransactions = $stmt->fetch(PDO::FETCH_ASSOC)['total'];

echo "<h3>Totals:</h3>";
echo "<p>Total Expenses: Rp " . number_format($totalExpenses, 0, ',', '.') . "</p>";
echo "<p>Total Transactions: Rp " . number_format($totalTransactions, 0, ',', '.') . "</p>";
echo "<p>Balance: Rp " . number_format($totalTransactions - $totalExpenses, 0, ',', '.') . "</p>";

echo "<h3>Test completed successfully!</h3>";
?> 