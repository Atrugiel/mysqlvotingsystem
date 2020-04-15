-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 15, 2020 at 10:14 PM
-- Server version: 5.6.47
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kaarenda_voting`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`kaarendalmariktk`@`localhost` PROCEDURE `help` (IN `inHaaletaja_id` INT(4), IN `inHaaletuse_aeg` DATETIME, IN `inOtsus` VARCHAR(5), OUT `okay` INT, OUT `error` VARCHAR(100))  NO SQL
Begin 
	set okay=1;
	Select * from LOGI;
/*
Adds new vote to LOGI
*/
	START TRANSACTION;
    If ( (inHaaletaja_id  is not null) AND (inOtsus is not null)) then
		begin
		INSERT INTO LOGI set 
Haaletaja_id = inHaaletaja_id, 
Otsus = inOtsus, 
Haaletuse_aeg=now();
        /*
        Updates or adds new vote in HAALETUS
        */
            If ((select H_lopu_aeg from TULEMUSED)<now()) then
        begin
                Update HAALETUS set 
        Haaletuse_aeg=inHaaletuse_aeg, 
        Otsused=inOtsus,
        Haaletuse_id=1
        Where Haaletaja_id=inHaaletaja_id;

                End;
            Else
                Begin
                    Set okay=0;
					Set error='midagi on puudu 3';
                End;
            end if;
                End;
	Else
		Begin
			Set okay=0;
			Set error='something is missing to give a vote';
		End;
	End if; 


/*
Updates TULEMUSED based on HAALETUS
*/

	If (1>0) then
    		begin
			Update TULEMUSED set 
            		Haaletanute_arv=(select count(Otsused) from HAALETUS) , 
            		Poolt_haaled=(SELECT count(Otsused) from HAALETUS where Otsused='poolt'), 
            		Vastu_haaled=(SELECT count(Otsused) from HAALETUS where Otsused='vastu');
		End;
	Else
		Begin
			Set okay=0;
			Set error='midagi on puudu 3';
		End;
	End if;



	If okay=1 then
		Begin
 			COMMIT;
			Select 'commit;';
		End;
	Else 
    	begin
			Select 'rollback';
			ROLLBACK;
		End;
	End if;
End$$

CREATE DEFINER=`kaarendalmariktk`@`localhost` PROCEDURE `loo_haaletus` (IN `inAlgus` DATETIME)  NO SQL
UPDATE TULEMUSED SET
Haaletuse_id=1,
Haaletanute_arv='',
H_alguse_aeg=inAlgus,
H_lopu_aeg=DATE_SUB(inAlgus, INTERVAL -5 minute),
Poolt_haaled=0,
Vastu_haaled=0$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `HAALETUS`
--

CREATE TABLE `HAALETUS` (
  `Haaletaja_id` int(4) UNSIGNED NOT NULL,
  `Eesnimi` varchar(10) NOT NULL,
  `Perenimi` varchar(10) NOT NULL,
  `Haaletuse_aeg` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Otsused` varchar(5) NOT NULL,
  `Haaletuse_id` int(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `HAALETUS`
--

INSERT INTO `HAALETUS` (`Haaletaja_id`, `Eesnimi`, `Perenimi`, `Haaletuse_aeg`, `Otsused`, `Haaletuse_id`) VALUES
(1, 'fgjn', 'uki', '2020-01-27 17:44:37', 'poolt', 1),
(2, 'arth', 'arh', '2020-01-27 17:47:04', 'vastu', 1),
(3, 'rsth', 'gchk', '2020-02-06 16:49:39', 'vastu', 1),
(4, 'qqq', 'www', '2020-01-28 22:49:55', 'vastu', 1),
(5, 'steve', 'aasdfg', '2020-01-28 22:57:05', 'poolt', 1),
(6, 'Alex', 'Connor2', '2020-01-31 09:54:27', 'vastu', 1),
(7, 'Peter', 'Johnson', '2020-01-24 11:51:13', 'poolt', 0),
(8, 'ergtjyuh', 'grhj', '2020-01-28 22:46:37', 'vastu', 1),
(9, 'Hyde', 'John', '2020-02-01 05:03:07', 'vastu', 0),
(10, 'Steve', 'Hyde', '2020-02-01 05:04:47', 'vastu', 1),
(11, 'Jogn', 'Smite', '2020-01-26 22:49:55', 'poolt', 0),
(12, 'hhhh', 'qwer', '2020-01-28 22:53:38', 'vastu', 1);

-- --------------------------------------------------------

--
-- Table structure for table `LOGI`
--

CREATE TABLE `LOGI` (
  `Logi_id` int(10) UNSIGNED NOT NULL,
  `Haaletaja_id` int(4) UNSIGNED NOT NULL,
  `Otsus` varchar(5) NOT NULL,
  `Haaletuse_aeg` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `LOGI`
--

INSERT INTO `LOGI` (`Logi_id`, `Haaletaja_id`, `Otsus`, `Haaletuse_aeg`) VALUES
(1, 4, 'poolt', '2020-01-24 12:15:06'),
(2, 5, 'poolt', '2020-01-24 12:11:41'),
(3, 1, 'poolt', '2020-01-24 12:14:37'),
(4, 6, 'vastu', '2020-01-21 17:48:59'),
(5, 2, 'vastu', '2020-01-21 18:10:14'),
(6, 3, 'poolt', '2020-01-21 18:11:40'),
(7, 2, 'poolt', '2020-01-22 16:36:20'),
(8, 4, 'vastu', '2020-01-22 17:05:43'),
(9, 4, 'vastu', '2020-01-22 17:08:05'),
(10, 1, 'poolt', '2020-01-22 17:13:31'),
(11, 2, 'poolt', '2020-01-22 17:22:28'),
(12, 5, 'poolt', '2020-01-24 11:49:53'),
(13, 1, 'vastu', '2020-01-24 12:16:23'),
(14, 1, 'poolt', '2020-01-24 12:21:01'),
(15, 1, 'vastu', '2020-01-24 12:21:30'),
(16, 1, 'vastu', '2020-01-24 12:23:18'),
(17, 1, 'vastu', '2020-01-24 12:26:10'),
(18, 4, 'poolt', '2020-01-26 22:47:47'),
(19, 4, 'poolt', '2020-01-26 22:49:47'),
(20, 0, 'poolt', '2020-01-26 22:49:55'),
(21, 0, 'vastu', '2020-01-26 22:56:43'),
(22, 1, 'vastu', '2020-01-26 23:09:21'),
(23, 3, 'vastu', '2020-01-26 23:31:01'),
(24, 3, 'poolt', '2020-01-26 23:34:36'),
(25, 3, 'vastu', '2020-01-26 23:38:19'),
(26, 4, 'poolt', '2020-01-26 23:55:13'),
(27, 8, 'vastu', '2020-01-27 00:04:50'),
(28, 6, 'poolt', '2020-01-27 16:11:08'),
(29, 9, 'poolt', '2020-01-27 16:18:37'),
(30, 12, 'poolt', '2020-01-27 16:23:09'),
(31, 1, 'poolt', '2020-01-27 16:28:36'),
(32, 5, 'POOLT', '2020-01-27 16:31:24'),
(33, 1, 'vastu', '2020-01-27 16:33:51'),
(34, 10, 'poolt', '2020-01-27 16:35:47'),
(35, 2, 'vastu', '2020-01-27 16:37:16'),
(36, 1, 'poolt', '2020-01-27 16:43:42'),
(37, 2, 'poolt', '2020-01-27 16:47:01'),
(38, 3, 'poolt', '2020-01-27 16:49:39'),
(39, 8, 'vastu', '2020-01-27 17:07:52'),
(40, 1, 'vastu', '2020-01-27 17:08:32'),
(41, 3, 'vastu', '2020-01-27 17:12:35'),
(42, 2, 'vastu', '2020-01-27 17:15:12'),
(43, 5, 'vastu', '2020-01-27 17:17:55'),
(44, 1, 'poolt', '2020-01-27 17:44:37'),
(45, 2, 'vastu', '2020-01-27 17:47:04'),
(46, 4, 'vastu', '2020-01-28 22:49:55'),
(47, 5, 'poolt', '2020-01-28 22:51:22'),
(48, 12, 'vastu', '2020-01-28 22:53:38'),
(49, 5, 'poolt', '2020-01-28 22:57:05'),
(50, 1, 'poolt', '2020-01-31 08:37:51'),
(51, 1, 'vastu', '2020-01-31 09:46:48'),
(52, 6, 'vastu', '2020-01-31 09:49:20'),
(53, 6, 'vastu', '2020-01-31 09:50:05'),
(54, 6, 'vastu', '2020-01-31 09:51:28'),
(55, 6, 'poolt', '2020-01-31 09:52:09'),
(56, 6, 'vastu', '2020-01-31 09:54:27'),
(57, 6, 'poolt', '2020-01-31 09:56:56');

-- --------------------------------------------------------

--
-- Table structure for table `TULEMUSED`
--

CREATE TABLE `TULEMUSED` (
  `Haaletuse_id` int(4) UNSIGNED NOT NULL,
  `Haaletanute_arv` int(4) UNSIGNED NOT NULL,
  `H_alguse_aeg` datetime NOT NULL,
  `H_lopu_aeg` datetime NOT NULL,
  `Poolt_haaled` int(4) UNSIGNED NOT NULL,
  `Vastu_haaled` int(4) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `TULEMUSED`
--

INSERT INTO `TULEMUSED` (`Haaletuse_id`, `Haaletanute_arv`, `H_alguse_aeg`, `H_lopu_aeg`, `Poolt_haaled`, `Vastu_haaled`) VALUES
(1, 12, '2020-02-01 05:00:00', '2020-02-01 05:05:00', 4, 8);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `HAALETUS`
--
ALTER TABLE `HAALETUS`
  ADD PRIMARY KEY (`Haaletaja_id`);

--
-- Indexes for table `LOGI`
--
ALTER TABLE `LOGI`
  ADD PRIMARY KEY (`Logi_id`),
  ADD KEY `Haaletaja_id` (`Haaletaja_id`);

--
-- Indexes for table `TULEMUSED`
--
ALTER TABLE `TULEMUSED`
  ADD PRIMARY KEY (`Haaletuse_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `HAALETUS`
--
ALTER TABLE `HAALETUS`
  MODIFY `Haaletaja_id` int(4) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `LOGI`
--
ALTER TABLE `LOGI`
  MODIFY `Logi_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
