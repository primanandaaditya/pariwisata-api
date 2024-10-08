-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 09, 2024 at 07:39 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pariwisata`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `SP_KategoriAll`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_KategoriAll` ()   SELECT * FROM kategori ORDER by nama$$

DROP PROCEDURE IF EXISTS `SP_KategoriDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_KategoriDelete` (IN `pid` INT)   DELETE FROM kategori WHERE id_kategori = pid$$

DROP PROCEDURE IF EXISTS `SP_KategoriEdit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_KategoriEdit` (IN `pid` INT, IN `pnama` VARCHAR(100))   UPDATE kategori SET nama = pnama WHERE id_kategori = pid$$

DROP PROCEDURE IF EXISTS `SP_KategoriInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_KategoriInsert` (IN `pnama` VARCHAR(100), OUT `phasil` VARCHAR(100))   IF ((select count(nama) from kategori where nama = pnama) > 0) THEN  
        set phasil = 'Data duplikat';   
    ELSE 
        INSERT INTO kategori (nama) VALUES (pnama);
        set phasil = 'Data berhasil disimpan'; 
    END IF$$

DROP PROCEDURE IF EXISTS `SP_Login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Login` (IN `pnama` VARCHAR(100), IN `ppassword` VARCHAR(200))   if (SELECT COUNT(nama) FROM users WHERE nama = pnama AND password = ppassword AND active = '1' ) = 0 THEN
BEGIN
       SELECT true as error, '0' as id_user, '' as role, '' as nama, '' as password, '' as alamat, '' as tempat, '' as tgllahir, '' as gender;
    END;
ELSE
BEGIN
    SELECT false as error, id_user, role, nama, password, alamat, tempat, tgllahir, gender from users where nama = pnama and password = ppassword;
    END;
END IF$$

DROP PROCEDURE IF EXISTS `SP_TempatAll`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatAll` ()   SELECT t.id_tempat, t.id_kategori, 
k.nama as nama_kategori,
t.nama, t.alamat, t.detail, t.foto,
t.latitude, t.longitude
FROM tempat t 
INNER JOIN kategori k
ON t.id_kategori = k.id_kategori
ORDER BY t.nama$$

DROP PROCEDURE IF EXISTS `SP_TempatByKategori`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatByKategori` (IN `pid_kategori` INT)   SELECT t.id_tempat, t.id_kategori, 
k.nama as nama_kategori,
t.nama, t.alamat, t.detail, t.foto,
t.latitude, t.longitude
FROM tempat t 
INNER JOIN kategori k
ON t.id_kategori = k.id_kategori
WHERE t.id_kategori = pid_kategori
ORDER BY t.nama$$

DROP PROCEDURE IF EXISTS `SP_TempatDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatDelete` (IN `pid` INT)   DELETE FROM tempat WHERE id_tempat = pid$$

DROP PROCEDURE IF EXISTS `SP_TempatEdit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatEdit` (IN `palamat` VARCHAR(100), IN `pdetail` TEXT, IN `pid_kategori` INT, IN `platitude` DOUBLE, IN `plongitude` DOUBLE, IN `pnama` VARCHAR(100), IN `pid` INT)   UPDATE tempat set
alamat = palamat,
detail = pdetail,
id_kategori = pid_kategori,
latitude = platitude,
longitude = plongitude,
nama = pnama
where id_tempat = pid$$

DROP PROCEDURE IF EXISTS `SP_TempatInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatInsert` (IN `palamat` VARCHAR(100), IN `pdetail` TEXT, IN `pfoto` VARCHAR(100), IN `pid_kategori` INT, IN `platitude` DOUBLE, IN `plongitude` DOUBLE, IN `pnama` VARCHAR(100), OUT `phasil` VARCHAR(100))   IF ((select count(nama) from tempat where nama = pnama) > 0) THEN  
        set phasil = 'Data duplikat';   
    ELSE 
         INSERT INTO tempat (alamat,detail,foto,id_kategori,latitude,longitude,nama) 
         VALUES (palamat,pdetail,pfoto,pid_kategori,platitude,plongitude,pnama);
        set phasil = 'Data berhasil disimpan'; 
    END IF$$

DROP PROCEDURE IF EXISTS `SP_TempatSearch`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatSearch` (IN `pkey` VARCHAR(100))   SELECT t.id_tempat, t.id_kategori, 
k.nama as nama_kategori,
t.nama, t.alamat, t.detail, t.foto,
t.latitude, t.longitude
FROM tempat t 
INNER JOIN kategori k
ON t.id_kategori = k.id_kategori
where t.nama like CONCAT('%',pkey,'%')
ORDER BY t.nama$$

DROP PROCEDURE IF EXISTS `SP_TempatTerdekat`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TempatTerdekat` (IN `platitude` DOUBLE, IN `plongitude` DOUBLE)   SELECT t.*, k.nama as nama_kategori,
   ROUND(111.111 *
    DEGREES(ACOS(LEAST(1.0, COS(RADIANS(platitude))
         * COS(RADIANS(t.latitude))
         * COS(RADIANS(plongitude - t.longitude))
         + SIN(RADIANS(platitude))
         * SIN(RADIANS(t.latitude))))),2) AS jarak
 FROM kategori k
 INNER JOIN tempat t
 ON t.id_kategori = k.id_kategori
 ORDER by jarak$$

DROP PROCEDURE IF EXISTS `SP_UserDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UserDelete` (IN `pid` INT)   UPDATE users SET active = '0' where id_user = pid$$

DROP PROCEDURE IF EXISTS `SP_UserExceptAdmin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UserExceptAdmin` ()   select * from users where nama <> 'ADMIN' and active = '1' order by nama$$

DROP PROCEDURE IF EXISTS `SP_UserUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UserUpdate` (IN `ptipe` VARCHAR(1), IN `prole` VARCHAR(20), IN `pnama` VARCHAR(100), IN `ppassword` VARCHAR(200), IN `palamat` VARCHAR(200), IN `ptempat` VARCHAR(100), IN `ptgllahir` VARCHAR(20), IN `pgender` VARCHAR(20), IN `pid` INT)   IF (ptipe=1) THEN
    IF ((select count(nama) from users where nama = pnama and active = '1') > 0) THEN  
        select true as error, 'Data duplikat' as pesan;   
    ELSE 
         INSERT INTO users (role,nama,password,alamat,tempat,tgllahir,gender,active) VALUES (prole,pnama,md5(ppassword),palamat,ptempat,ptgllahir,pgender,'1');
        select false as error, 'Data berhasil disimpan' as pesan;  
    END IF;
ELSE
    UPDATE users set nama = pnama, alamat = palamat, tempat = ptempat, tgllahir = ptgllahir, gender = pgender where id_user = pid;
     select false as error, 'Data berhasil diedit' as pesan;
END IF$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
CREATE TABLE IF NOT EXISTS `kategori` (
  `id_kategori` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) DEFAULT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_kategori`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama`, `create_date`, `create_by`) VALUES
(3, 'Mall', '2024-05-31 09:39:03', NULL),
(4, 'Pasar Malam', '2024-05-31 09:39:10', NULL),
(6, 'Pasar pagi', '2024-05-31 10:37:11', NULL),
(7, 'Sungai', '2024-05-31 13:43:07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tempat`
--

DROP TABLE IF EXISTS `tempat`;
CREATE TABLE IF NOT EXISTS `tempat` (
  `id_tempat` int NOT NULL AUTO_INCREMENT,
  `id_kategori` int NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `detail` text,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_tempat`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tempat`
--

INSERT INTO `tempat` (`id_tempat`, `id_kategori`, `nama`, `alamat`, `detail`, `latitude`, `longitude`, `foto`, `create_date`, `create_by`) VALUES
(1, 3, 'Grand Indonesia', 'Jalan M.H. Thamrin No.1, RT.1/RW.5\r\nKelurahan Menteng, Kecamatan Menteng\r\nKota Jakarta Pusat 10310 (', 'Grand Indonesia (atau biasa disingkat GI) merupakan sebuah pusat perbelanjaan di Jakarta, Indonesia, yang dibuka pada tahun 2007, oleh Presiden Susilo Bambang Yudhoyono. Ini merupakan sebuah kompleks multi-guna yang terdiri dari pusat perbelanjaan (Grand Indonesia), gedung perkantoran (Menara BCA), apartemen (Kempinski Residence) dan Hotel Indonesia Kempinski.\r\nGrand Indonesia terdiri dari tiga bagian: East Mall, West Mall dan sebuah jembatan penyebrangan orang yang menghubungkan kedua bagian tersebut, menjadikannya sebagai mal terbesar di Jakarta Pusat, terbesar kedua di Jakarta setelah Mal Kelapa Gading di Jakarta Utara dan terbesar keempat di Indonesia setelah Pakuwon Mall dan Tunjungan Plaza di Surabaya. Skybridge tersedia di lantai 1, 2, 3, 3A, dan 5. Sebuah foodcourt yang terdapat pada West Mall yang bernama Foodprint berada di lantai 5. West Mall Grand Indonesia telah dibuka untuk umum pada April 2007.\r\nPada tanggal 9 Januari 2017, majalah bisnis asal Amerika Serikat Forbes, memasukan Grand Indonesia dalam daftar lima pusat perbelanjaan terbaik di Jakarta.', -6.1951851, 106.816837, 'grandindonesia.jpg', '2024-05-31 11:11:12', NULL),
(4, 3, 'Kuningan City Mall', 'Jl. Prof. DR. Satrio No.Kav. 18, Kuningan, Karet Kuningan, Kecamatan Setiabudi, Kota Jakarta Selatan', 'Kuningan City adalah kompleks superblock serbaguna di Karet Kuningan, Setiabudi, Jakarta Selatan, Indonesia, yang terdiri dari 1 pusat perbelanjaan Mall Kuningan City, 2 menara apartemen exclusive, dan 1 menara perkantoran. Kuningan City terletak di Jl. Prof. DR. Satrio No.Kav', -6.224778951034036, 106.8296066378621, '1717137646.jpg', '2024-05-31 13:40:45', NULL),
(5, 7, 'Sungai Ciliwung', 'Gunung Gede, Gunung Pangrango', 'Ciliwung adalah sungai bersejarah yang membentang dari hulu di Bogor, meliputi kawasan Gunung Gede, Gunung Pangrango, dan Cisarua lalu mengalir ke hilir di pantai utara Jakarta. Sungai ini memiliki panjang 120 kilometer dengan luas Daerah Aliran Sungai (DAS) 387 kilometer persegi.', -6.1204716, 106.824816, '1717138136.jpg', '2024-05-31 13:48:55', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `role` varchar(20) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `tempat` varchar(100) DEFAULT NULL,
  `tgllahir` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `active` varchar(1) DEFAULT NULL,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `role`, `nama`, `password`, `alamat`, `tempat`, `tgllahir`, `gender`, `active`, `create_date`) VALUES
(1, NULL, 'Andi', 'ppp', 'jakarta', 'jakarta', '2000-01-01', 'pria', '0', '2024-08-09 09:38:00'),
(2, 'guest', 'Lala Karmela', 'abc', 'sby', 'sby', '1995-07-02', 'pria', '0', '2024-08-09 09:39:33'),
(3, 'guest', 'Dian', 'abc', 'sukabumi', 'sukabumi', '1988-08-03', 'pria', '1', '2024-08-09 10:47:01'),
(4, 'guest', 'Diana', 'abc', 'sukabumi', 'sukabumi', '1988-08-03', 'wanita', '1', '2024-08-09 10:51:45'),
(5, 'guest', 'Lina', '$2y$10$zOmiT8yqKFLxEaTiyJ/Jwe0R2rAfwDYrT1istHCshKLYfOpbNCFr2', 'sukabumi', 'sukabumi', '1988-08-03', 'wanita', '1', '2024-08-09 11:04:06'),
(6, 'guest', 'Lani', '900150983cd24fb0d6963f7d28e17f72', 'jkt', 'jkt', '1993-01-02', 'wanita', '1', '2024-08-09 11:20:23'),
(7, 'guest', 'Efa', '900150983cd24fb0d6963f7d28e17f72', 'a', 'a', '2000-08-02', 'pria', '1', '2024-08-09 11:41:21'),
(10, 'guest', 'Nita', '900150983cd24fb0d6963f7d28e17f72', 'sukabumi', 'sukabumi', '1988-08-03', 'wanita', '1', '2024-08-09 13:15:18'),
(12, 'admin', 'Admin', '3cf2139939a806213e131a6297c7c4cf', 'sukabumi', 'sukabumi', '1988-08-03', 'pria', '1', '2024-08-09 14:25:58');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
