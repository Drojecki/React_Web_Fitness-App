-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2025 at 05:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inzynierka`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `permissions` int(11) NOT NULL,
  `last_login` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `permissions`, `last_login`) VALUES
(1, 'julek', 1, '2024-08-11 18:32:27'),
(2, 'julka', 1, '2024-08-11 18:32:27'),
(3, 'henschel', 1, '2024-08-11 18:32:27'),
(4, 'filip', 1, '2024-08-11 18:32:27'),
(5, 'kuba', 1, '2024-08-11 18:32:27');

-- --------------------------------------------------------

--
-- Table structure for table `age_groups`
--

CREATE TABLE `age_groups` (
  `id` int(11) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  `min_age` int(11) NOT NULL,
  `max_age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `age_groups`
--

INSERT INTO `age_groups` (`id`, `group_name`, `min_age`, `max_age`) VALUES
(1, '18-24', 18, 24),
(2, '25-34', 25, 34),
(3, '35-44', 35, 44),
(4, '45-54', 45, 54),
(5, '55-64', 55, 64),
(6, '65+', 65, 100);

-- --------------------------------------------------------

--
-- Stand-in structure for view `banned_users_with_admins`
-- (See below for the actual view)
--
CREATE TABLE `banned_users_with_admins` (
`id` int(11)
,`user_id` int(11)
,`banned_date` timestamp
,`reason` varchar(50)
,`banned_by_username` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `banned_date` timestamp NULL DEFAULT current_timestamp(),
  `reason` varchar(50) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bans`
--

INSERT INTO `bans` (`id`, `user_id`, `banned_date`, `reason`, `banned_by`) VALUES
(1, 5, '2024-08-11 18:43:10', 'Spamming', 1),
(2, 3, '2024-08-11 18:43:10', 'Multiple accounts', 1),
(3, 13, '2024-08-11 18:43:10', 'Spamming', 2),
(4, 5, '2024-08-11 18:57:55', 'Spamming', 1),
(5, 3, '2024-08-11 18:57:55', 'Multiple accounts', 1),
(6, 13, '2024-08-11 18:57:55', 'Spamming', 2),
(7, 1, '2024-08-11 18:57:55', 'Chuj', 1);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment_date` timestamp NULL DEFAULT current_timestamp(),
  `comment_text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `distance` decimal(10,2) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `status` varchar(10) DEFAULT 'inactive',
  `user_ids` text DEFAULT NULL,
  `TrophyImage` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `title`, `description`, `type`, `distance`, `image`, `created_at`, `startDate`, `endDate`, `status`, `user_ids`, `TrophyImage`) VALUES
(104, 'Winter Holidays with EcoSphere', 'Join our initiative to help reduce CO2 emissions!', 'run', 100.00, 'uploads/AdobeStock_318577956.jpeg', '2025-01-10 14:55:59', '2025-01-01', '2025-03-31', 'active', '106', 'uploads/WinterEventCard.png'),
(105, 'Max out running - Winter 2025', 'Challenge yourself in a winter running event promo...', 'run', 75.00, 'uploads/AdobeStock_145471371.jpeg', '2025-01-10 14:57:27', '2025-01-01', '2025-03-31', 'active', '106', 'uploads/HolidayEventCard.png');

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `status` enum('pending','accepted','blocked') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friends`
--

INSERT INTO `friends` (`user_id`, `friend_id`, `status`, `created_at`, `id`) VALUES
(1, 2, 'accepted', '2024-08-12 17:11:44', 1),
(1, 3, 'accepted', '2024-08-12 17:11:44', 2),
(1, 4, 'pending', '2024-08-12 17:11:44', 3),
(2, 1, 'accepted', '2024-08-12 17:11:44', 6),
(2, 3, 'accepted', '2024-08-12 17:11:44', 7),
(3, 2, 'accepted', '2024-08-12 17:11:44', 10),
(4, 48, 'accepted', '2024-08-12 17:11:44', 13),
(48, 2, 'accepted', '2024-08-12 17:11:44', 17),
(48, 44, 'pending', '2024-10-30 14:38:21', 48),
(48, 52, 'accepted', '2024-11-05 18:15:29', 54),
(48, 73, 'accepted', '2024-10-30 14:38:22', 49),
(52, 44, 'pending', '2024-10-30 14:17:53', 44),
(52, 54, 'pending', '2024-10-30 14:40:13', 51),
(52, 73, 'accepted', '2024-10-30 14:11:10', 43),
(52, 88, 'pending', '2024-10-30 14:40:13', 52),
(52, 92, 'pending', '2024-10-30 14:40:13', 53),
(54, 67, 'pending', '2024-10-01 20:25:36', 24);

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `like_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications_popup`
--

CREATE TABLE `notifications_popup` (
  `id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `header` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications_popup`
--

INSERT INTO `notifications_popup` (`id`, `content`, `created_at`, `header`) VALUES
(33, 'Try eco-friendly travel today!', '2024-12-13 16:00:38', 'Take care of yourself and the planet'),
(34, 'The start of the St. Nicholas Day event!', '2024-12-13 16:00:48', 'This Friday'),
(35, 'Join those who work for change!', '2024-12-13 16:01:29', 'Sustainable transport is the future');

-- --------------------------------------------------------

--
-- Table structure for table `notifictions`
--

CREATE TABLE `notifictions` (
  `id` int(11) NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifictions`
--

INSERT INTO `notifictions` (`id`, `notification_type`, `description`) VALUES
(1, 'E-mail', 'Notification by e-mail'),
(2, 'Push', 'Push notification');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `route_id` bigint(20) UNSIGNED NOT NULL,
  `post_date` timestamp NULL DEFAULT current_timestamp(),
  `content` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `route_id`, `post_date`, `content`) VALUES
(4, 12, 4, '2024-08-11 19:27:12', 'lorempisum'),
(5, 54, 1, '2024-09-11 18:05:45', 'Treść postu 1'),
(6, 54, 2, '2024-09-11 18:05:45', 'Treść postu 2'),
(7, 54, 3, '2024-09-11 18:05:45', 'Treść postu 3'),
(8, 54, 4, '2024-09-11 18:05:45', 'Treść postu 4'),
(9, 54, 5, '2024-09-11 18:05:45', 'Treść postu 5'),
(10, 54, 6, '2024-09-11 18:05:45', 'Treść postu 6'),
(11, 54, 7, '2024-09-11 18:05:45', 'Treść postu 7'),
(12, 54, 8, '2024-09-11 18:05:45', 'Treść postu 8'),
(13, 54, 9, '2024-09-11 18:05:45', 'Treść postu 9'),
(14, 54, 10, '2024-09-11 18:05:45', 'Treść postu 10'),
(16, 73, 1, '2024-10-31 11:00:00', 'Treść postu 1'),
(17, 73, 2, '2024-10-31 11:05:00', 'Treść postu 2'),
(18, 73, 3, '2024-10-31 11:10:00', 'Treść postu 3'),
(19, 73, 4, '2024-10-31 11:15:00', 'Treść postu 4'),
(20, 73, 5, '2024-10-31 11:20:00', 'Treść postu 5'),
(21, 73, 6, '2024-10-31 11:25:00', 'Treść postu 6'),
(22, 73, 7, '2024-10-31 11:30:00', 'Treść postu 7'),
(23, 73, 8, '2024-10-31 11:35:00', 'Treść postu 8'),
(24, 73, 9, '2024-10-31 11:40:00', 'Treść postu 9'),
(25, 73, 10, '2024-10-31 11:45:00', 'Treść postu 10');

-- --------------------------------------------------------

--
-- Stand-in structure for view `post_view`
-- (See below for the actual view)
--
CREATE TABLE `post_view` (
`id` int(11)
,`user_id` int(11)
,`route_id` bigint(20) unsigned
,`post_date` timestamp
,`content` text
,`distance_km` float
,`CO2` float
,`kcal` int(11)
,`duration` time
,`username` varchar(50)
,`comment_count` bigint(21)
,`like_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `handled_by` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `finished_date` datetime DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `user_id`, `handled_by`, `status`, `created_date`, `finished_date`, `description`) VALUES
(1, 1, NULL, 'open', '2024-08-12 16:31:01', NULL, NULL),
(2, 1, 3, 'open', '2024-08-12 16:33:52', NULL, NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `tickets_with_admins`
-- (See below for the actual view)
--
CREATE TABLE `tickets_with_admins` (
`id` int(11)
,`user_id` int(11)
,`status` varchar(255)
,`created_date` datetime
,`finished_date` datetime
,`description` varchar(50)
,`handled_by` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `transport_modes`
--

CREATE TABLE `transport_modes` (
  `id` int(11) NOT NULL,
  `mode_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transport_modes`
--

INSERT INTO `transport_modes` (`id`, `mode_name`, `description`) VALUES
(1, 'Bicycle', 'Traveling by bicycle'),
(2, 'Walking', 'Traveling by walking'),
(3, 'Running', 'Traveling by Running');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` char(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT current_timestamp(),
  `is_banned` tinyint(1) DEFAULT 0,
  `profilePicture` varchar(255) DEFAULT NULL,
  `email_notifications` tinyint(1) DEFAULT 1,
  `push_notifications` tinyint(1) DEFAULT 1,
  `session_key` varchar(255) DEFAULT NULL,
  `is_Admin` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `email`, `age`, `gender`, `created_at`, `last_login`, `is_banned`, `profilePicture`, `email_notifications`, `push_notifications`, `session_key`, `is_Admin`) VALUES
(1, 'mbarajaz0', '$2a$04$GZi2PWV0TmztyJO0oLT9FO4pQdBZCBUPuLhX6m5FkcNB43ZmhiSti', 'krobilart0@intel.com', 63, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 1, NULL, 1, 1, NULL, 0),
(2, 'rshimon1', '$2a$04$B8SUJxSJHsX4HakGaF07RuKar8fxE1Vs.BspwpM4AuCwg80k9m3wS', 'dkissack1@last.fm', 1, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(3, 'flushey2', '$2a$04$Q/IA8lgW4hvtc30mKS1.7.28BfviUwSitqjMlOWypm09bAjArdHRS', 'lcabble2@house.gov', 91, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 1, NULL, 1, 1, NULL, 0),
(4, 'lpauwel3', '$2a$04$rZcVEiwh3gLJb5xwdLb6XuW2r8EQ1qeys4jyX61FsB7Nn2AXTBppy', 'lpudding3@newyorker.com', 33, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 1, NULL, 1, 1, NULL, 0),
(5, 'phuddles4', '$2a$04$BnR7vxRgx/VEcHljr2L.5OJKLLvzN8kJ8fpxpSUriLwCYqvuJTgP6', 'pscuse4@ovh.net', 66, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 1, NULL, 1, 1, NULL, 0),
(6, 'egerish5', '$2a$04$S6bAzBG7orteRELkia7avOA2H.rZmO.pe26ZOSRkLdbyi0hLAEZvK', 'lfriar5@g.co', 11, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(7, 'lkirtley6', '$2a$04$DNAK4kBrCQSH6Z247/1KHetlmAoZ0JVTE/FcSbZCCVZ0lGpBD0IZm', 'rstorey6@cbsnews.com', 65, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(8, 'bcullip7', '$2a$04$IT4mtNdFWM.pydirafmXD.jpLADnuK9fuwerJ3NpOFnnMePVpsXHu', 'pskally7@jugem.jp', 42, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(9, 'kdoylend8', '$2a$04$DxFDsI8EALxUi//EcC5RNOfPNbBd14fHaWYw92upoSemypZRAfL.K', 'tmaskall8@java.com', 15, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(10, 'darington9', '$2a$04$gCzS9T0X.sGTHV700fHAbuMqcAbSys1N6H5WFRbreiQ4nDx10UY6W', 'wshelp9@icq.com', 2, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(11, 'jsavagea', '$2a$04$b2U07mXLWBAdjHLxgYFMUOSEE//jhHbaFjwe698IWSBVtevdr4wo.', 'sgringleya@cafepress.com', 51, 'M', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(12, 'bbortheb', '$2a$04$.bQGZXCDzRaQgncnah.gXOTAYSXtA6RAY4V16nITf2yY.ScPmXZ.K', 'ssalmonib@wordpress.com', 24, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(13, 'bbartramc', '$2a$04$0Fp6qHF8UwTgaiK0q6jmleR/MNjXzECQLrg8k3h86u4S6SIIp9RZq', 'cmarkovac@hibu.com', 98, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 1, NULL, 1, 1, NULL, 0),
(14, 'gmacadied', '$2a$04$yZoaSl4zNuITk4VEWNJu3e1qz5QTp/ul8fN2/U4YEGwOnBpPao38q', 'mtremonted@dyndns.org', 39, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(15, 'csharplinge', '$2a$04$y7YTszhVg8Ci9kdKA/rxW.dTzWMj.DAHuxPkuLv6TVd7AMwOihie2', 'jheadye@pagesperso-orange.fr', 39, 'F', '2024-08-08 20:02:33', '2024-08-08 20:02:33', 0, NULL, 1, 1, NULL, 0),
(16, 'asdas', '$2b$10$h0UtVDwz/WjVgvlB9Tr4Vu7lUGbDDBo1iW56DBiPvb92RiB.ZW3h2', 'asds@sdas.pl', 15, 'M', '2024-08-12 19:36:36', '2024-08-12 17:36:36', 0, NULL, 1, 1, NULL, 0),
(19, 'asdass', '$2b$10$98enCdPkqsSZPUbCoA3fjudl0GzBN0SMQnu4AGzBR05GU6C1hD8Rm', 'asds@sda1s.pl', 15, 'M', '2024-08-12 19:37:48', '2024-08-12 17:37:48', 0, NULL, 1, 1, NULL, 0),
(20, 'Julek', '$2b$10$qNZORElRkYCbQXDEZkw5FuCS.y6yQacpgwHAWKVVjGm5onIUs8ghS', 'julek@julek.pl', 99, 'M', '2024-08-12 19:38:40', '2024-08-12 17:38:40', 0, NULL, 1, 1, NULL, 0),
(22, 'ziomuś', '$2b$10$MzspALF4W.UCyvuSHHdqJeZrRD7ETU9RP3sXvbFP1sJxKeYzulhsq', 'kjfahsdfjh@mmdk.com', 20, 'M', '2024-08-12 19:52:53', '2024-08-12 17:52:51', 0, NULL, 1, 1, NULL, 0),
(23, 'Juras', '$2b$10$irmjn2pXbNBvIUDttyTYLeBpHySd5pzJciFqj9cjTpYsUMY0xp3lu', 'nnsakdj@piafd.pl', 43, 'M', '2024-08-12 20:27:29', '2024-08-12 18:27:28', 0, NULL, 1, 1, NULL, 0),
(24, 'Jureczek', '$2b$10$bX8Ksj2TTRzDV1GjITKdpOoxJutOHAiOyK7mudxzPpyQcMZw6u0Da', 'mni@zfdasd.com', 19, 'M', '2024-08-12 20:40:48', '2024-08-12 18:40:46', 0, NULL, 1, 1, NULL, 0),
(29, 'Jureczeuash', '$2b$10$sn7dSE7gbyMWgwUp6wQXXuMU7845Y2BcvXY/oQXoaNa0ZuoZwAQNK', 'mdsfgdani@zfdasd.com', 19, 'M', '2024-08-12 20:42:50', '2024-08-12 18:42:48', 0, NULL, 1, 1, NULL, 0),
(31, 'Jurnsfadkljn', '$2b$10$O8eJeSoT4HYIbv774vQEG.Bcw/ekWgPEEgmdgsHf.XFWIRkd6DaC2', 'mdfjahgvkjdashsfgdani@zfdasd.com', 20, 'M', '2024-08-12 20:45:11', '2024-08-12 18:45:09', 0, NULL, 1, 1, NULL, 0),
(35, 'mikolaj', '$2b$10$pR/dE6Z6xvI9jLcKpFHWJu6AG2Yiw49Nw2VeM1ix.nObHDODEpc/u', 'asjhf@gbbajs.pl', 43, 'M', '2024-08-12 20:46:13', '2024-08-12 18:46:11', 0, NULL, 1, 1, NULL, 0),
(36, 'mikolaje', '$2b$10$07O6HKVKLI3OPIL/feTJDe3RSDy0eM46tFs3vlpvIlJY3GUSDnp4y', '1234@s,eiur.pl', 34, 'M', '2024-08-12 20:52:48', '2024-08-12 18:52:46', 0, NULL, 1, 1, NULL, 0),
(38, 'mikolajeqw', '$2b$10$9ZgMaIT.iKlhroA4kedJ3OxHbK9GqpQq06YIoqTxwQo7mScD9PF/6', '12,34@srtyiueiur.pl', 34, 'M', '2024-08-12 20:53:34', '2024-08-12 18:53:32', 0, NULL, 1, 1, NULL, 0),
(40, 'mikolajeqwrewqr', '$2b$10$TMwyx3PPIAJrYynprN9SVOoOZ.R4IrQzj0xnovSBzeJj8AbODI0SO', '1234@srtyiueiur.pletw', 34, 'M', '2024-08-12 20:54:32', '2024-08-12 18:54:30', 0, NULL, 1, 1, NULL, 0),
(41, 'msikodlajeqwrewqr', '$2b$10$ym4s7q6RWF17Mmq9Qpzzeu53WJGSBtztZIbf8ijVPAYsNheXum8QK', '12d34@srtyisdfaueiur.pletw', 34, 'M', '2024-08-12 20:55:02', '2024-08-12 18:55:00', 0, NULL, 1, 1, NULL, 0),
(42, 'dfhasiudf', '$2b$10$vS/MqA4bBgD5FSX8xC37pOMwZw4jklah.fOC8ZHsEuuOUoQnKVNJ.', 'asdfjo@ewq.vp', 21, 'M', '2024-08-12 21:27:26', '2024-08-12 19:27:24', 0, NULL, 1, 1, NULL, 0),
(44, 'marek', '$2b$10$SNQIwyR7QYRxHhyU5954Au9otzo8ufoNBc2J26SxUvcWy0THY9nK6', 'marek@marek.pl', 18, 'M', '2024-08-13 10:48:38', '2024-08-13 08:48:38', 0, NULL, 1, 1, NULL, 0),
(45, '123', '123', '123@123', 20, 'M', '2024-08-13 10:38:16', '2024-08-13 10:38:16', 0, NULL, 1, 1, NULL, 0),
(47, 'sdsadas', '$2b$10$oGijqPa1jXToobCQ7cwd8Ocw/7omuH/o5R6uWhKEEibvuHkS0xIaS', '123@123.pl', 66, 'M', '2024-08-13 12:40:26', '2024-08-13 10:40:26', 0, NULL, 1, 1, NULL, 0),
(48, '321', '$2b$10$j50LlsAFXDqRapodAcN1A.44N3/q6vPWzwDWR.OjDinni3cYOJPym', '321@123', 20, 'M', '2024-08-13 10:56:54', '2024-08-13 10:56:54', 0, '/uploads/1736522125384-AdobeStock_597868879.jpeg', 1, 1, '3bf464161048840596c7cc400d460edfa9ed6f31c27255d4832e90c6d132b4094a412852b52fd66dd143d29683eeeda85f4574eae5000f2be188bb2122f4bead', 1),
(49, 'amrekawe', '$2b$10$0gCOTofH27vV8NsGKZQpOOozzSA7Sq.bpwczQnRd1954iWzI44Wu.', 'qwer@wer.pl', 32, 'M', '2024-08-13 13:12:36', '2024-08-13 11:12:36', 0, NULL, 1, 1, NULL, 0),
(52, 'MarekMarek', '$2b$10$CrFg7KDZeJwrHOd2Br.43upURlQ2yi2xu8/4CsNXdd0wizwHCLIVO', 'jule111k@julek.pl', 19, 'M', '2024-08-13 23:10:18', '2024-08-13 21:10:19', 0, '/uploads/1736522145349-AdobeStock_35612378.jpeg', 0, 0, '7fc2d6c0c972fa95c1a2c9a65974f5b5ed39d49a88006ad04ff485d46c9e1e40027cb1eb3b79143a961a6f165c9a38fce7df0d282ea4e24f8ea6649ab8310cb0', 1),
(53, 'qwwerty', '$2b$10$pM4v0e6a1fYICUiEitQIAen6Y6ApZnDI1QMN3AacTcKtrXPz/mMEC', 'hfvjhaskj@msdaf.ps', 45, 'F', '2024-08-13 23:48:22', '2024-08-13 21:48:22', 0, NULL, 1, 1, NULL, 0),
(54, 'Fifi', '$2b$10$221LtnADl5RTKGdYMhKCK.8u14dC8vTsIZfRADgQMDN.vjgG8UInm', 'niktCieNieKocha@Dzięki.pl', 30, 'M', '2024-08-24 17:13:26', '2024-08-24 15:13:30', 0, '/uploads/1736522218972-AdobeStock_752852021.jpeg', 1, 1, '571dee77ae4b2a4b84583cb3da2764cb6c5f6b9825b5e1119971287f6e117d37ea9d5c86fc5b4e9a441e07ed7dbc2b9963921d517f86988354c68c6a8330850a', 0),
(67, 'qweqweqwe', '$2b$10$IathYXWJFkSKbJn0k0j0punyd84dKsg2aJpMobqLkv0kFoxi4UpfG', 'qweqwe@qwe.qwe', 67, 'M', '2024-09-11 19:36:38', '2024-09-11 17:36:37', 0, NULL, 1, 1, NULL, 0),
(71, 'hbydsfvijh', '$2b$10$qWdWCECvCImV/1oSQI7Wm.gvJRxjv/JE5Egappo.JRTG4pwVw/MhS', 'fajsuhgfihsdi123@aidug.12', 44, 'M', '2024-09-11 19:50:34', '2024-09-11 17:50:33', 0, NULL, 1, 1, NULL, 0),
(73, 'MarekMarekMarek', '$2b$10$MpxeeEc8YdXRWexwdwmFGOCDLuLTAD4nMMtasDS/NStnJmage3ZZG', '123@12223.pl', 20, 'M', '2024-09-11 23:30:14', '2024-09-11 21:30:15', 0, '', 1, 1, '50b196b5600b97760794b35ce148b7d3ae3694c9137192424dd746fbf1b51c9ce13bfe5307369f6bf6efe8915e077a0914454dc11ff8b0ec3d5dca61da833945', 1),
(74, 'AniaAnia', '$2b$10$DAkQU5WuqLGlbH1IbaDa2uWZwCjJjkZP5sUoWNN7xNR/5VY25.X0O', 'Ania@Ania.Ania', 60, 'F', '2024-09-16 13:25:27', '2024-09-16 11:25:26', 1, NULL, 1, 1, '9befe289ce4c089bc5f77e093f82cc2b8472924e719cf4d32997ed83c38254211fa5cc07b7cb051b8aa689fac246323d3e539b059d23706b1524572f2049b436', 0),
(75, 'skdamflask', '$2b$10$kteMj/Ldf3R4mT6zul4NK.D.gRNfj/A6VXr3BwWf3N7cQrECw6X36', 'ajfdoisajdf@ea.r', 44, 'M', '2024-09-16 21:48:42', '2024-09-16 19:48:42', 0, NULL, 1, 1, NULL, 0),
(77, 'pidsahjfojashfo', '$2b$10$s8.tSu7AqZ57LeqP7yijUusbcz4u2McyO43BM5VYmdTJK.3i1PaHW', 'apfijhaso1@sa.a', 33, 'M', '2024-09-16 21:59:53', '2024-09-16 19:59:52', 0, NULL, 1, 1, NULL, 0),
(78, 'gsiurfghwi', '$2b$10$eF7UHg3gXnP6rApS/yKjCO.PVjnPx8MvKf7tigRMOQdHvTd8JMmBu', 'qiwej@e.ada', 22, 'M', '2024-09-16 22:01:27', '2024-09-16 20:01:26', 0, NULL, 1, 1, NULL, 0),
(79, 'iwuyegriwqug', '$2b$10$uxumFOjeagr0eYC1ckKGu.Iq0YDiFVnKov9uIqhJViBilWNR3wUf2', 'wqe@wea.q', 33, 'M', '2024-09-16 22:04:55', '2024-09-16 20:04:54', 0, NULL, 1, 1, NULL, 0),
(80, 'wewyqgeryg', '$2b$10$CQzMAnJORbQspEK0ao88lO00DNwcsZR1YNT/IGg03703dctm30EpW', 'nfdj@das.a', 33, 'M', '2024-09-16 22:22:35', '2024-09-16 20:22:34', 0, NULL, 1, 1, NULL, 0),
(82, 'Debil', '$2b$10$was9g4M4HsGYqeDKSz69g.TafMJN/Co33Dru0vXJquPFT1VgDY6Ti', 'debil@toja.pl', 69, 'F', '2024-09-18 18:23:18', '2024-09-18 18:23:18', 0, NULL, 1, 1, NULL, 0),
(83, 'TomaszFornal', '$2b$10$k1VpaQtPLAoRpBBTUV09meWsaNLBho4K2Dh.6xhUXtbTaUtwrbQEi', 'To@ja.pl', 69, 'M', '2024-09-18 18:27:55', '2024-09-18 18:27:55', 1, NULL, 1, 1, NULL, 0),
(84, 'qwerty', '$2b$10$4qNpeVYjj0M4nU7P8HOXuOlrotb9LFVA9aY45WeLMsKTi0I3qRyGa', 'q@qe.pl', 69, 'M', '2024-09-19 19:41:26', '2024-09-19 19:41:26', 0, NULL, 1, 1, NULL, 0),
(88, 'Fifii', '$2b$10$pPnR14L0r7LewigpM4mNGeXxkufdMO8kGGkemFA3nOVeEPDehNGbG', 'Fifi@Fifi.pl', 25, 'M', '2024-10-16 18:53:06', '2024-10-16 16:53:12', 0, NULL, 1, 1, NULL, 0),
(92, 'Fifiii', '$2b$10$YOF0OCHJhQqUclu1p0LGUu/43DGzh6VvaYMJFIzEq7qqznMuoGJ1S', 'Fifi@Fiifi.pl', 25, 'M', '2024-10-16 18:54:32', '2024-10-16 16:54:38', 0, NULL, 1, 1, '0f638543888f8114c433afb8186a102ecca9be00889a602a18f7162feee616895bf42f5fb38af373be4dd041ad9491502922c1e28a6f4bbc74a44ec70bc905bc', 0),
(93, 'DEBTAk', '$2b$10$eW5X.Ze1CYXYpXHDHVkjd.88qiFGgDtGfELc.cfeWBJDL9iILSKJy', 'asd@awqe.tv', 32, 'F', '2024-10-16 19:08:39', '2024-10-16 17:08:45', 0, NULL, 1, 1, '27b72046e3d00446c8f38b483c655920e6a753c73b2bd92d6e20fce9934d6b8de34344da647c5cf5e3b45bc40c8b177d226f5aef08fb04580035f10ff86fbc9b', 0),
(94, '1234567890', '$2b$10$0GzziFGqwz6MlhDd62zW/eHUKUd/hPdZwJgxy20q0rHkgCwOvyciC', '321@431.pl', 23, 'M', '2024-10-24 16:57:34', '2024-10-24 16:57:34', 0, NULL, 1, 1, NULL, 0),
(95, 'ytrewq', '$2b$10$OH4obHCTZzCMvEOUTsbKDODTL.KyD6lqQVjI6q5GyUxLUnhOHZ/YW', 'qwerty@qwertty.pl', 54, 'F', '2024-10-24 17:22:22', '2024-10-24 17:22:22', 0, NULL, 1, 1, NULL, 0),
(96, 'Qwerty1 ', '$2b$10$AdySgkHom6LAqwINoh/iWemjd0zLLt1jxMqgupoLHi5nTEjB5zyoC', '431`@qer.pl', 12, 'F', '2024-10-24 17:30:41', '2024-10-24 17:30:41', 0, NULL, 1, 1, NULL, 0),
(97, 'erdfbgfhn', '$2b$10$BTu9gEhs30aafGfbz863CutZhAmPu8d1nffyErnLvhXjbhSSTLq.q', 'Filip@typ.pl', 56, 'F', '2024-10-24 17:33:03', '2024-10-24 17:33:03', 0, NULL, 1, 1, NULL, 0),
(98, '134567543', '$2b$10$JXgCyWU3omon6bAIIQGObeia06VKUTQHTSxfjXKA2FU7CGu9zSD5W', 'Filip@gmail.pl', 19, 'M', '2024-10-24 17:35:15', '2024-10-24 17:35:15', 0, NULL, 1, 1, NULL, 0),
(99, 'qwertyuiop', '$2b$10$RaMDQ/lkX9C6U74NXY6MmecEdhojyM9FKz.V4VKa.Wia4.Y50jvCi', 'qwerty@com.tv', 25, 'M', '2024-10-28 17:53:59', '2024-10-28 17:53:59', 0, NULL, 1, 1, NULL, 0),
(100, 'asdfghjkl', '$2b$10$Zfk645Lsnw/48izI5qCNZu7UfYZqxjLpmpi42a1PjJAa8lOBH1Nju', 'Filip@onet.pl', 30, 'M', '2024-10-28 18:03:56', '2024-10-28 18:03:56', 0, NULL, 1, 1, NULL, 0),
(101, 'test', '$2b$10$WC70D04ppHG6yrXo3fBeDez2tjVnoTkGn6QHSolT3OIQl5onorWDu', '123@sad.pl', 32, 'M', '2024-11-02 18:48:06', '2024-11-02 18:48:06', 0, NULL, 1, 1, NULL, 0),
(103, 'testxd', '$2b$10$M0PWAozO34AYs1fuHBsxyeH9jItCfoDrNf0DRIeUkAbHgVsufcqr2', 'test@test.pl', 23, 'M', '2024-11-02 21:01:13', '2024-11-02 21:01:13', 0, NULL, 1, 1, 'f4124e00aff55165c271afee3f08feb527f89ff9ec198c674689f54636080f1959e865b7303836f7d296778dfd3f7c8d5dae1113127f317f9223212ad8346fb3', 0),
(104, 'testxdxd', '$2b$10$vIbFI7bDOwfehdCYpu2qzOOpXivRpPdtIcJkFR3W928emtxpcQaB2', 'test@test.ig', 32, 'F', '2024-11-02 21:08:25', '2024-11-02 21:08:25', 1, NULL, 1, 1, '99ca1c8c6f60b1ee5d12b6e3af06f0a70bd889951691184d492129b09d97d4ad794868b8a37ddbe9be03b24899d20a88cd54c86cc240cfdc5ad4a2c4bd783dc0', 0),
(105, 'testczxcxz', '$2b$10$4N2W4hobwtPRN0PhHPODTOiLtQkC0GvvnVQzVjxEBYGDDKXiQk5DS', '123@123.pll', 32, 'F', '2024-11-03 17:08:29', '2024-11-03 17:08:29', 0, NULL, 1, 1, NULL, 0),
(106, 'JohnWick', '$2b$10$GdbYmeEcA836r11ns/Z7q.gnKVoVvudblZ3wQ6i0Lh2yo/JtS9hdK', 'John@Wick.pl', 25, 'M', '2024-12-13 15:23:29', '2024-12-13 15:23:29', 0, NULL, 0, 0, '889a93870a655096ca62f6e7b74e0e427e974d1e30b9fb7eba5594e16bdced7ee346295f532839f23b9fd7f2d587c31bc2ef84152f8a1044c71ba3671cd587e9', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_routes`
--

CREATE TABLE `user_routes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `transport_mode_id` int(11) NOT NULL,
  `distance_km` float NOT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `CO2` float NOT NULL,
  `kcal` int(11) NOT NULL,
  `duration` time NOT NULL,
  `money` float NOT NULL,
  `is_private` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_routes`
--

INSERT INTO `user_routes` (`id`, `user_id`, `transport_mode_id`, `distance_km`, `date`, `CO2`, `kcal`, `duration`, `money`, `is_private`) VALUES
(1, 48, 1, 7.75, '2024-08-11 18:18:35', 5.44, 85, '00:12:54', 11.35, 1),
(2, 3, 2, 2.59, '2024-08-11 18:18:35', 5.75, 326, '00:55:11', 2.31, 1),
(3, 48, 1, 11.76, '2024-08-11 18:18:35', 13.66, 473, '00:12:35', 17.11, 1),
(4, 12, 1, 10.95, '2024-08-11 18:18:35', 1.64, 77, '00:18:53', 1.06, 0),
(5, 6, 2, 2.83, '2024-08-11 18:18:35', 3.13, 55, '00:44:51', 0.8, 1),
(6, 3, 2, 9.73, '2024-08-11 18:18:35', 3.29, 305, '00:03:58', 14.69, 1),
(7, 3, 1, 5.58, '2024-08-11 18:18:35', 0.4, 72, '00:00:23', 3.71, 1),
(8, 8, 2, 4.19, '2024-08-11 18:18:35', 4.6, 100, '00:44:17', 1.55, 1),
(9, 48, 1, 10.9, '2024-08-12 16:40:32', 4.85, 123, '00:46:21', 2.52, 1),
(10, 5, 2, 1.87, '2024-08-12 16:40:32', 7.95, 164, '00:03:47', 1.34, 1),
(11, 4, 2, 0.31, '2024-08-12 16:40:32', 4.61, 294, '00:31:38', 4.2, 1),
(12, 4, 1, 9.36, '2024-08-12 16:40:32', 1.18, 142, '00:11:15', 17.79, 1),
(13, 6, 2, 4.66, '2024-08-12 16:40:32', 2.09, 204, '00:30:22', 0.88, 1),
(14, 14, 1, 6.07, '2024-08-12 16:40:32', 12.97, 342, '00:19:37', 16.97, 1),
(15, 14, 1, 0.48, '2024-08-12 16:40:32', 4.04, 56, '00:55:16', 0.49, 1),
(16, 7, 2, 0.53, '2024-08-12 16:40:32', 0.56, 59, '00:08:27', 6.55, 1),
(17, 11, 2, 4.54, '2024-08-12 16:40:32', 2.09, 222, '00:51:56', 6.69, 1),
(18, 12, 1, 13.24, '2024-08-12 16:40:32', 6.03, 521, '00:26:53', 8.74, 1),
(19, 10, 1, 0.09, '2024-08-12 16:40:32', 0.82, 195, '00:50:10', 2.8, 1),
(20, 10, 2, 3.54, '2024-08-12 16:40:32', 4.89, 23, '00:39:13', 7.33, 1),
(21, 10, 2, 1.82, '2024-08-12 16:40:32', 3.8, 165, '00:26:49', 2.57, 1),
(22, 15, 1, 17.15, '2024-08-12 16:40:32', 13.01, 434, '00:09:30', 9.32, 1),
(23, 10, 1, 7.57, '2024-08-12 16:40:32', 4.79, 47, '00:23:10', 5.54, 1),
(24, 3, 2, 2.16, '2024-08-12 16:40:32', 1.76, 136, '00:20:09', 5.16, 1),
(25, 48, 1, 12.5, '2024-08-15 12:15:18', 8.3, 500, '00:30:00', 15, 1),
(26, 48, 2, 20, '2024-08-15 12:15:18', 15, 800, '01:00:00', 25, 1),
(27, 48, 1, 5, '2024-08-15 12:15:18', 3, 200, '00:10:00', 5, 1),
(28, 48, 2, 15, '2024-08-15 12:15:18', 10, 600, '00:45:00', 20, 1),
(29, 48, 1, 22.5, '2024-08-15 12:16:46', 8.3, 500, '01:30:00', 15, 1),
(30, 48, 1, 20, '2024-08-15 12:16:46', 15, 800, '05:00:00', 25, 1),
(31, 48, 1, 10.5, '2024-08-16 09:43:02', 2.3, 150, '00:30:00', 5, 1),
(32, 48, 2, 5.2, '2024-08-16 09:43:02', 1.1, 100, '00:15:00', 2.5, 1),
(33, 1, 2, 10.5, '2024-08-17 00:00:00', 0.5, 250, '00:30:00', 15, 1),
(34, 48, 2, 10.5, '2024-08-17 00:00:00', 0.5, 250, '00:30:00', 15, 1),
(35, 48, 2, 10.5, '2024-08-17 18:49:23', 0.5, 250, '00:30:00', 15, 1),
(36, 48, 1, 10.5, '2024-08-17 18:51:26', 0.5, 250, '00:30:00', 15, 1),
(37, 48, 1, 10.5, '2024-08-17 19:40:15', 2.5, 50, '00:30:00', 15, 1),
(38, 52, 1, 10.5, '2024-08-17 19:43:58', 2.5, 50, '00:30:00', 15, 1),
(39, 48, 2, 38, '2024-08-17 20:46:39', 2.5, 50, '00:30:00', 15, 1),
(40, 48, 2, 1, '2024-08-17 20:46:55', 2.5, 50, '00:30:00', 15, 1),
(41, 48, 1, 42.5, '2024-08-18 20:15:51', 12, 450, '03:30:00', 45, 1),
(42, 48, 1, 3, '2024-08-19 09:02:00', 1, 50, '00:22:00', 1, 1),
(43, 48, 1, 3, '2024-08-19 09:02:20', 1, 50, '00:22:00', 1, 1),
(44, 52, 1, 3, '2024-08-19 09:02:39', 1, 50, '00:22:00', 1, 1),
(45, 48, 1, 10.5, '2024-08-22 21:27:51', 2.5, 50, '00:30:00', 15, 1),
(46, 54, 1, 999, '2024-08-24 15:22:46', 2.5, 50, '00:30:00', 15, 1),
(47, 52, 1, 6, '2024-09-05 10:18:35', 2.5, 50, '00:30:00', 15, 1),
(48, 52, 1, 6, '2024-09-05 10:18:41', 2.5, 50, '00:30:00', 15, 1),
(49, 52, 2, 40, '2024-09-05 10:18:52', 2.5, 50, '00:30:00', 15, 1),
(50, 52, 2, 11, '2024-09-05 10:19:15', 2.5, 50, '00:30:00', 15, 1),
(51, 48, 1, 10.5, '2024-09-06 15:51:56', 2.5, 50, '00:30:00', 15, 1),
(52, 48, 1, 10.5, '2023-08-11 16:18:35', 2.5, 50, '00:30:00', 15, 1),
(53, 48, 1, 10.5, '2024-08-11 16:18:35', 2.5, 50, '00:30:00', 15, 1),
(54, 48, 1, 10.5, '2024-09-11 16:18:35', 2.5, 50, '00:30:00', 15, 1),
(55, 48, 1, 10.5, '2024-09-08 16:18:35', 2.5, 50, '00:45:00', 15, 1),
(56, 52, 1, 50, '2024-09-09 19:15:26', 150, 50, '00:00:50', 50, 1),
(57, 48, 2, 12.5, '2024-09-10 14:38:58', 2.5, 50, '00:30:00', 15, 1),
(58, 48, 2, 10, '2024-09-09 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(59, 48, 2, 10, '2024-09-10 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(60, 48, 2, 5, '2024-09-15 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(61, 48, 2, 5, '2024-09-16 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(62, 48, 2, 5, '2024-09-16 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(63, 48, 2, 5, '2024-09-09 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(64, 48, 2, 5, '2024-09-15 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(65, 48, 2, 5, '2024-09-16 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(66, 48, 2, 5, '2024-09-08 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(67, 48, 2, 20, '2024-09-10 17:32:52', 2.5, 50, '00:30:00', 15, 1),
(68, 52, 2, 50, '2024-09-10 17:34:38', 2.5, 50, '00:30:00', 15, 1),
(70, 48, 1, 100, '2024-09-10 19:03:11', 2.5, 50, '00:30:00', 15, 1),
(71, 52, 1, 100, '2024-09-10 20:36:19', 2.5, 50, '00:30:00', 15, 1),
(72, 48, 1, 50, '2024-09-10 20:53:58', 2.5, 50, '00:30:00', 15, 1),
(73, 52, 1, 5, '2024-09-11 10:05:00', 2.5, 50, '00:30:00', 15, 1),
(74, 48, 1, 10.5, '2024-09-11 17:09:54', 2.5, 50, '00:30:00', 15, 1),
(75, 48, 1, 120, '2024-09-11 17:10:49', 2.5, 50, '00:30:00', 15, 1),
(76, 48, 1, 130, '2024-09-11 17:11:03', 2.5, 50, '00:30:00', 15, 1),
(77, 48, 2, 1000, '2024-09-11 21:01:49', 2.5, 50, '00:30:00', 15, 1),
(78, 52, 2, 1000, '2024-09-11 21:27:09', 2.5, 50, '00:30:00', 15, 1),
(79, 73, 2, 1000, '2024-09-11 21:34:21', 2.5, 50, '00:30:00', 15, 1),
(80, 48, 1, 10.5, '2024-09-11 22:23:59', 2.5, 50, '00:30:00', 15, 1),
(81, 48, 1, 10.5, '2024-09-11 22:25:51', 2.5, 50, '00:30:00', 15, 1),
(82, 48, 1, 10.5, '2024-09-12 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(83, 48, 1, 10.5, '2024-09-14 18:55:44', 2.5, 50, '00:30:00', 15, 1),
(84, 52, 1, 5, '2024-09-14 20:42:34', 2.5, 50, '00:30:00', 15, 1),
(85, 52, 1, 5, '2024-09-12 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(86, 52, 1, 2, '2024-09-13 00:00:00', 2.5, 50, '00:30:00', 15, 1),
(87, 52, 1, 5, '2024-09-15 16:26:12', 2.5, 50, '00:30:00', 15, 1),
(88, 48, 1, 100, '2024-09-16 19:23:47', 2.5, 50, '00:30:00', 15, 1),
(89, 54, 1, 5.6, '2024-09-18 19:48:11', 100, 200, '00:36:00', 10.5, 0),
(90, 54, 1, 5.6, '2024-09-18 19:49:17', 100, 200, '00:36:00', 10.5, 0),
(91, 48, 1, 5.6, '2024-09-18 19:50:07', 100, 200, '00:36:00', 10.5, 0),
(92, 48, 1, 100, '2024-09-19 17:36:50', 2.5, 50, '00:30:00', 15, 1),
(93, 48, 2, 100, '2024-09-19 17:36:54', 2.5, 50, '00:30:00', 15, 1),
(94, 48, 1, 5.6, '2024-10-08 18:36:37', 100, 200, '00:36:00', 10.5, 0),
(95, 48, 1, 0, '2024-10-13 16:32:37', 0, 0, '00:00:08', 0, 0),
(96, 48, 1, 0, '2024-10-13 18:57:31', 0, 0, '00:00:03', 0, 0),
(97, 54, 1, 0.07, '2024-10-13 19:00:09', 8.53, 4, '00:00:18', 0.04, 0),
(98, 54, 1, 1.56, '2024-10-13 19:01:46', 186.97, 78, '00:01:12', 0.78, 0),
(99, 48, 1, 0.14, '2024-10-14 17:27:05', 17.32, 7, '00:00:18', 0.07, 0),
(100, 48, 1, 0.34, '2024-10-14 17:28:50', 41.16, 17, '00:00:32', 0.17, 0),
(101, 48, 1, 2.64, '2024-10-14 17:36:22', 317.28, 132, '00:00:28', 1.32, 0),
(102, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(103, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(104, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(105, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(106, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(107, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(108, 54, 1, 0.14, '2024-10-15 17:07:00', 17.37, 7, '00:00:29', 0.07, 0),
(109, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(110, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(111, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(112, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(113, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(114, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(115, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(116, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(117, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(118, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(119, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(120, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(121, 54, 1, 0.14, '2024-10-15 17:07:01', 17.37, 7, '00:00:29', 0.07, 0),
(122, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(123, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(124, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(125, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(126, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(127, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(128, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(129, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(130, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(131, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(132, 54, 1, 0.14, '2024-10-15 17:07:02', 17.37, 7, '00:00:29', 0.07, 0),
(133, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(134, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(135, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(136, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(137, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(138, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(139, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(140, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(141, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(142, 54, 1, 0.14, '2024-10-15 17:07:03', 17.37, 7, '00:00:29', 0.07, 0),
(143, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(144, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(145, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(146, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(147, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(148, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(149, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(150, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(151, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(152, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(153, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(154, 54, 1, 0.14, '2024-10-15 17:07:04', 17.37, 7, '00:00:29', 0.07, 0),
(155, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(156, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(157, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(158, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(159, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(160, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(161, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(162, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(163, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(164, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(165, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(166, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(167, 54, 1, 0.14, '2024-10-15 17:07:05', 17.37, 7, '00:00:29', 0.07, 0),
(168, 48, 1, 10.5, '2024-10-16 17:35:11', 2.5, 50, '00:30:00', 15, 1),
(169, 48, 2, 100, '2024-10-16 17:36:24', 2.5, 50, '00:30:00', 15, 1),
(170, 48, 2, 100, '2024-10-16 17:37:14', 2.5, 50, '00:30:00', 15, 1),
(171, 48, 2, 100, '2024-10-16 17:37:54', 2.5, 50, '00:30:00', 15, 1),
(172, 48, 1, 0.2, '2024-10-21 19:40:12', 24.36, 10, '00:00:41', 0.1, 0),
(173, 48, 1, 0, '2024-10-27 19:06:49', 0, 0, '00:00:04', 0, 0),
(174, 48, 1, 0, '2024-10-27 19:30:46', 0, 0, '00:01:31', 0, 0),
(175, 100, 1, 0.35, '2024-10-28 18:08:02', 42.19, 18, '00:01:03', 0.18, 0),
(176, 48, 1, 10.72, '2024-10-28 18:18:53', 1286.05, 536, '00:02:11', 5.36, 0),
(177, 48, 2, 99, '2024-10-29 10:00:51', 2.5, 50, '00:30:00', 15, 1),
(178, 48, 2, 2, '2024-10-29 10:01:06', 2.5, 50, '00:30:00', 15, 1),
(179, 48, 1, 40, '2024-11-04 15:32:19', 2.5, 50, '00:30:00', 15, 1),
(180, 48, 2, 40, '2024-11-04 15:32:33', 2.5, 50, '00:30:00', 15, 1),
(181, 48, 1, 100, '2024-11-07 16:40:31', 2.5, 50, '00:30:00', 15, 1),
(182, 52, 1, 100, '2024-11-07 16:43:04', 2.5, 50, '00:30:00', 15, 1),
(183, 48, 1, 10.5, '2024-11-12 21:43:08', 2.5, 50, '00:30:00', 15, 1),
(184, 48, 2, 50, '2024-11-12 21:49:56', 2.5, 50, '00:30:00', 15, 1),
(185, 48, 2, 50, '2024-11-26 19:45:12', 2.5, 50, '00:30:00', 15, 1),
(186, 48, 1, 50, '2024-11-26 19:45:43', 2.5, 50, '00:30:00', 15, 1),
(187, 48, 1, 50, '2024-11-26 19:46:05', 2.5, 50, '00:30:00', 15, 1),
(189, 48, 3, 125, '2024-12-10 16:32:25', 2.5, 50, '00:30:00', 15, 1),
(190, 48, 1, 40, '2024-12-12 13:36:26', 2.5, 50, '00:30:00', 15, 1),
(191, 48, 1, 10, '2024-12-12 13:36:38', 2.5, 50, '00:30:00', 15, 1),
(192, 106, 1, 15, '2024-12-04 23:00:00', 2.5, 50, '00:30:00', 15, 1),
(193, 106, 1, 20.3, '2024-11-14 23:00:00', 2.5, 50, '00:30:00', 15, 1),
(194, 106, 2, 25.35, '2024-12-08 23:00:00', 2.5, 50, '00:30:00', 15, 1),
(195, 106, 3, 15, '2024-12-09 23:00:00', 5, 140, '00:20:00', 15, 1),
(196, 106, 1, 7.5, '2024-12-10 23:00:00', 5, 242, '00:20:00', 2.2, 1),
(197, 106, 1, 10.8, '2024-12-11 23:00:00', 5, 242, '00:20:00', 2.2, 1),
(198, 106, 1, 17.5, '2024-12-12 23:00:00', 5, 242, '00:40:00', 11.2, 1),
(199, 106, 2, 17.5, '2024-12-09 00:00:00', 5, 242, '00:40:00', 11.2, 1),
(200, 106, 3, 17.5, '2024-12-08 23:00:00', 5, 242, '00:40:00', 11.2, 1),
(201, 106, 1, 42.2, '2024-12-07 23:00:00', 5.5, 2000, '00:30:00', 150, 1),
(202, 106, 1, 10, '2024-12-06 23:00:00', 5.5, 230, '00:30:00', 32, 1),
(203, 106, 2, 75, '2024-12-14 19:40:18', 2.5, 50, '00:30:00', 15, 1),
(204, 106, 1, 20, '2025-01-10 14:59:21', 2.5, 50, '00:30:00', 15, 1),
(205, 106, 1, 100, '2025-01-10 14:59:42', 2.5, 50, '07:30:00', 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_streaks`
--

CREATE TABLE `user_streaks` (
  `user_id` int(11) NOT NULL,
  `current_streak` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_streaks`
--

INSERT INTO `user_streaks` (`user_id`, `current_streak`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_streaks_view`
-- (See below for the actual view)
--
CREATE TABLE `user_streaks_view` (
`user_id` int(11)
,`username` varchar(50)
,`current_streak` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `banned_users_with_admins`
--
DROP TABLE IF EXISTS `banned_users_with_admins`;

CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `banned_users_with_admins`  AS SELECT `bans`.`id` AS `id`, `bans`.`user_id` AS `user_id`, `bans`.`banned_date` AS `banned_date`, `bans`.`reason` AS `reason`, `admins`.`username` AS `banned_by_username` FROM (`bans` join `admins` on(`bans`.`banned_by` = `admins`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `post_view`
--
DROP TABLE IF EXISTS `post_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `post_view`  AS SELECT `posts`.`id` AS `id`, `posts`.`user_id` AS `user_id`, `posts`.`route_id` AS `route_id`, `posts`.`post_date` AS `post_date`, `posts`.`content` AS `content`, `user_routes`.`distance_km` AS `distance_km`, `user_routes`.`CO2` AS `CO2`, `user_routes`.`kcal` AS `kcal`, `user_routes`.`duration` AS `duration`, `users`.`username` AS `username`, count(distinct `comments`.`id`) AS `comment_count`, count(distinct `likes`.`id`) AS `like_count` FROM ((((`posts` join `user_routes` on(`posts`.`route_id` = `user_routes`.`id`)) join `users` on(`posts`.`user_id` = `users`.`id`)) left join `comments` on(`posts`.`id` = `comments`.`post_id`)) left join `likes` on(`posts`.`id` = `likes`.`post_id`)) WHERE `user_routes`.`is_private` = 0 GROUP BY `posts`.`id`, `user_routes`.`id`, `users`.`id` ;

-- --------------------------------------------------------

--
-- Structure for view `tickets_with_admins`
--
DROP TABLE IF EXISTS `tickets_with_admins`;

CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `tickets_with_admins`  AS SELECT `tickets`.`id` AS `id`, `tickets`.`user_id` AS `user_id`, `tickets`.`status` AS `status`, `tickets`.`created_date` AS `created_date`, `tickets`.`finished_date` AS `finished_date`, `tickets`.`description` AS `description`, `admins`.`username` AS `handled_by` FROM (`tickets` left join `admins` on(`tickets`.`handled_by` = `admins`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `user_streaks_view`
--
DROP TABLE IF EXISTS `user_streaks_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `user_streaks_view`  AS SELECT `users`.`id` AS `user_id`, `users`.`username` AS `username`, ifnull(`user_streaks`.`current_streak`,0) AS `current_streak` FROM (`users` left join `user_streaks` on(`users`.`id` = `user_streaks`.`user_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `age_groups`
--
ALTER TABLE `age_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`user_id`,`friend_id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `friend_id` (`friend_id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications_popup`
--
ALTER TABLE `notifications_popup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifictions`
--
ALTER TABLE `notifictions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `notification_type` (`notification_type`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `route_id` (`route_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `handled_by` (`handled_by`);

--
-- Indexes for table `transport_modes`
--
ALTER TABLE `transport_modes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mode_name` (`mode_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_routes`
--
ALTER TABLE `user_routes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `transport_mode_id` (`transport_mode_id`);

--
-- Indexes for table `user_streaks`
--
ALTER TABLE `user_streaks`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `age_groups`
--
ALTER TABLE `age_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications_popup`
--
ALTER TABLE `notifications_popup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `notifictions`
--
ALTER TABLE `notifictions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transport_modes`
--
ALTER TABLE `transport_modes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `user_routes`
--
ALTER TABLE `user_routes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bans`
--
ALTER TABLE `bans`
  ADD CONSTRAINT `bans_ibfk_1` FOREIGN KEY (`banned_by`) REFERENCES `admins` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `user_routes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`handled_by`) REFERENCES `admins` (`id`);

--
-- Constraints for table `user_routes`
--
ALTER TABLE `user_routes`
  ADD CONSTRAINT `user_routes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_routes_ibfk_2` FOREIGN KEY (`transport_mode_id`) REFERENCES `transport_modes` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
