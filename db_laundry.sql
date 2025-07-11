-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 07 Jul 2025 pada 04.13
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_laundry`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi_log`
--

CREATE TABLE `notifikasi_log` (
  `id_log` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `pesan` text NOT NULL,
  `tanggal_kirim` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `notifikasi_log`
--

INSERT INTO `notifikasi_log` (`id_log`, `id_transaksi`, `pesan`, `tanggal_kirim`) VALUES
(1, 2, 'Halo Boni,\n\nStatus laundry Anda:\nPaket: Laundry + Setrika\nStatus: Dicuci\nPembayaran: Lunas\nTotal: Rp 15.000\n\nTerima kasih telah menggunakan jasa kami.', '2025-05-27 13:17:14'),
(2, 2, 'Halo Boni,\n\nStatus laundry Anda:\nPaket: Laundry + Setrika\nStatus: Dicuci\nPembayaran: Lunas\nTotal: Rp 15.000\n\nTerima kasih telah menggunakan jasa kami.', '2025-05-27 13:21:32');

-- --------------------------------------------------------

--
-- Struktur dari tabel `paket_laundry`
--

CREATE TABLE `paket_laundry` (
  `id_paket` int(11) NOT NULL,
  `jenis_laundry` varchar(50) NOT NULL,
  `estimasi_waktu` varchar(20) NOT NULL,
  `harga` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data untuk tabel `paket_laundry`
--

INSERT INTO `paket_laundry` (`id_paket`, `jenis_laundry`, `estimasi_waktu`, `harga`) VALUES
(1, 'Laundry + Setrika', '', 15000.00),
(2, 'Fast Laundry', '2 Hari', 20000.00),
(3, 'Regular', '7 Hari', 5000.00),
(4, 'Cuci Karpet', '2 Hari', 80000.00),
(5, 'Fast Laundry + Setrika', '2 Hari', 35000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `name_pelanggan` varchar(100) NOT NULL,
  `jenis_kelamin_pelanggan` enum('Laki-laki','Perempuan') NOT NULL,
  `alamat_pelanggan` text NOT NULL,
  `email_pelanggan` varchar(100) DEFAULT NULL,
  `no_telepon_pelanggan` varchar(15) NOT NULL,
  `pelanggan_Foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data untuk tabel `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `name_pelanggan`, `jenis_kelamin_pelanggan`, `alamat_pelanggan`, `email_pelanggan`, `no_telepon_pelanggan`, `pelanggan_Foto`) VALUES
(1, 'Boni', 'Laki-laki', 'Pontianak, Jl. ujung pandang gg. pare-pare', '20412575_andryanti_e@widyadharma.ac.id', '085161366047', '1747919981_vecteezy_cheerful-3d-avatar-with-glasses-for-digital-marketing_57357660.png'),
(2, 'emi', 'Perempuan', 'Jl. Ampera Gg. Nur ilahi no 31', 'email123@honeys.be', '081234567890', '1747919989_vecteezy_cheerful-3d-avatar-with-glasses-for-digital-marketing_57357660.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengeluaran`
--

CREATE TABLE `pengeluaran` (
  `id_pengeluaran` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `tanggal_pengeluaran` date NOT NULL,
  `jumlah_pengeluaran` decimal(10,2) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data untuk tabel `pengeluaran`
--

INSERT INTO `pengeluaran` (`id_pengeluaran`, `id_user`, `id_pelanggan`, `tanggal_pengeluaran`, `jumlah_pengeluaran`, `keterangan`) VALUES
(1, NULL, NULL, '2025-05-22', 50000.00, 'beli galon'),
(2, NULL, NULL, '2025-05-29', 14000.00, 'beli galon'),
(3, NULL, NULL, '2025-05-24', 150000.00, 'asdasd'),
(4, 12, NULL, '2025-05-29', 30000.00, 'beli mama lemon'),
(5, 12, NULL, '2025-06-21', 30000.00, 'beli lifeboy');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_pelanggan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_paket` int(11) DEFAULT NULL,
  `tanggal_terima` datetime NOT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `jumlah_kilo` decimal(5,2) NOT NULL,
  `catatan` text DEFAULT NULL,
  `total_bayar` decimal(10,2) NOT NULL,
  `status_laundry` enum('Diterima','Dicuci','Setrika','Selesai','Diambil') DEFAULT 'Diterima',
  `status_pembayaran` enum('Lunas','Belum Lunas') DEFAULT 'Belum Lunas',
  `status_pengembalian` enum('Sudah','Belum') DEFAULT 'Belum'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_pelanggan`, `id_user`, `id_paket`, `tanggal_terima`, `tanggal_selesai`, `jumlah_kilo`, `catatan`, `total_bayar`, `status_laundry`, `status_pembayaran`, `status_pengembalian`) VALUES
(1, 2, 2, 1, '2025-05-22 09:26:55', '2025-05-24 00:00:00', 15.00, 'asdjasdhasd', 225000.00, 'Diterima', 'Lunas', 'Sudah'),
(2, 1, 2, 1, '2025-05-22 09:37:03', '2025-05-28 00:00:00', 1.00, '', 15000.00, 'Selesai', 'Lunas', 'Sudah'),
(3, 1, 12, 1, '2025-05-29 12:53:14', '2025-07-05 00:00:00', 9.00, 'jangan sampai ketuker', 135000.00, 'Selesai', 'Lunas', 'Sudah'),
(4, 1, 12, 1, '2025-06-21 21:04:25', '2025-06-22 00:00:00', 3.60, 'jangan sampai ketukar', 54000.00, 'Selesai', 'Lunas', 'Sudah');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') NOT NULL,
  `alamat` text NOT NULL,
  `no_telepon` varchar(15) NOT NULL,
  `userFoto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `level` enum('Admin','Kasir') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `name`, `jenis_kelamin`, `alamat`, `no_telepon`, `userFoto`, `level`) VALUES
(2, 'kasir1', '$2y$10$WfdWEXk/5fE2eyZoxQJZ.O0.Fnb2oPe5PeWgOSJYXIz2xU1HFekBq', 'Kasir 1', 'Perempuan', 'Jl. Kasir 1', '081234567890', '1747918387_vecteezy_3d-student-boy-avatar-bring-tablete-icon_46634906.png', 'Kasir'),
(12, 'admin', '$2y$10$momHuKk8y3g0MGbfEkrlAuo8bN12ZhaPKPdAgjm9IwPLrX09bseKu', 'Admin Master', 'Laki-laki', 'Admin Office', '081234567890', '1747918372_vecteezy_3d-cartoon-man-with-glasses-and-beard-illustration_51767450.png', 'Admin'),
(13, 'kasir2', '$2y$10$7ZFPnaH85Zsy8suFQR.kHuisODfmsLhDUvuNSxAEguKyh4Zvh4Y9i', 'Kasir 2', 'Laki-laki', 'Jl. Kasir 2', '081234567890', '1751851166_vecteezy_cheerful-3d-avatar-with-glasses-for-digital-marketing_57357660.png', 'Kasir'),
(14, 'kasir3', '$2y$10$jKPEHI5nCAUv8RzVNxExL.NYGzb5RbKXSyBGJqTVlgykiESC2KWLi', 'Kasir 3', 'Perempuan', 'Jl. Kasir 3', '081234567890', '1751851176_vecteezy_3d-student-boy-avatar-bring-tablete-icon_46634906.png', 'Kasir'),
(15, 'kasir4', '$2y$10$6PqO.eWI8Yvq7YF50qkinO9y7gKcfosEChYQCG2jKTg3NbKMFQvOm', 'Kasir 4', 'Laki-laki', 'Jl. Kasir 4', '081234567890', '1751851186_vecteezy_cheerful-3d-avatar-with-glasses-for-digital-marketing_57357660.png', 'Kasir');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `notifikasi_log`
--
ALTER TABLE `notifikasi_log`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_transaksi` (`id_transaksi`);

--
-- Indeks untuk tabel `paket_laundry`
--
ALTER TABLE `paket_laundry`
  ADD PRIMARY KEY (`id_paket`);

--
-- Indeks untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indeks untuk tabel `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD PRIMARY KEY (`id_pengeluaran`),
  ADD KEY `fk_pengeluaran_user` (`id_user`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_laundry` (`id_paket`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `notifikasi_log`
--
ALTER TABLE `notifikasi_log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `pengeluaran`
--
ALTER TABLE `pengeluaran`
  MODIFY `id_pengeluaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `notifikasi_log`
--
ALTER TABLE `notifikasi_log`
  ADD CONSTRAINT `fk_notifikasi_transaksi` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD CONSTRAINT `fk_pengeluaran_user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `transaksi_ibfk_3` FOREIGN KEY (`id_paket`) REFERENCES `paket_laundry` (`id_paket`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
