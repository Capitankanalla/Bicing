-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Temps de generació: 04-02-2026 a les 15:30:27
-- Versió del servidor: 10.4.32-MariaDB
-- Versió de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de dades: `bicing_prac`
--

DELIMITER $$
--
-- Procediments
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `generar_trajectes` (IN `num` INT)   BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num DO
        INSERT INTO TRAJECTE 
        (Hora_inici, Hora_final, dock_final_lliure, id_EST_origen, id_EST_fin,
         BICICLETA_idBICICLETA, BICICLETA_ESTACIO_idESTACIO, USUARI_idUSUARI)
        SELECT
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
            1,
            FLOOR(1 + (RAND() * 50)),
            FLOOR(1 + (RAND() * 50)),
            b.idBICICLETA,
            b.ESTACIO_idESTACIO,
            FLOOR(1 + (RAND() * 15))
        FROM bicicleta b
        ORDER BY RAND()
        LIMIT 1;

        SET i = i + 1;
    END WHILE;
END$$

--
-- Funcions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `Bici_operativa` (`id_bici` INT) RETURNS VARCHAR(20) CHARSET utf8 COLLATE utf8_general_ci DETERMINISTIC BEGIN
    DECLARE incidents INT;
    DECLARE electrica TINYINT;
    DECLARE bateria DECIMAL(3,0);

    SELECT incident_acumulats, electrica, batt_lvl
    INTO incidents, electrica, bateria
    FROM bicicleta
    WHERE idBICICLETA = id_bici;

    IF incidents >= 3 THEN
        RETURN 'NO OPERATIVA';
    END IF;

    IF electrica = 1 AND bateria < 20 THEN
        RETURN 'NO OPERATIVA';
    END IF;

    RETURN 'OPERATIVA';
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `duracio_trajecte` (`idT` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE minuts INT;

    SELECT TIMESTAMPDIFF(MINUTE, Hora_inici, Hora_final)
    INTO minuts
    FROM TRAJECTE
    WHERE idTRAJECTE = idT;

    RETURN minuts;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `nivell_bateria` (`id_bici` INT) RETURNS INT(11) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE nivell INT;

    SELECT batt_lvl
    INTO nivell
    FROM BICICLETA
    WHERE idBICICLETA = id_bici
      AND electrica = 1;

    RETURN nivell;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de la taula `bicicleta`
--

CREATE TABLE `bicicleta` (
  `idBICICLETA` int(11) NOT NULL,
  `electrica` tinyint(4) NOT NULL DEFAULT 0,
  `batt_lvl` decimal(3,0) UNSIGNED DEFAULT NULL,
  `incident_acumulats` int(11) NOT NULL DEFAULT 0,
  `data_ultim_manteniment` date NOT NULL,
  `ESTACIO_idESTACIO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Bolcament de dades per a la taula `bicicleta`
--

INSERT INTO `bicicleta` (`idBICICLETA`, `electrica`, `batt_lvl`, `incident_acumulats`, `data_ultim_manteniment`, `ESTACIO_idESTACIO`) VALUES
(1, 0, NULL, 0, '2023-12-01', 12),
(2, 1, 19, 0, '2023-11-25', 40),
(3, 0, NULL, 0, '2023-12-01', 13),
(4, 1, 90, 0, '2023-12-01', 43),
(5, 0, NULL, 0, '2023-11-30', 28),
(6, 1, 78, 0, '2023-11-20', 9),
(7, 0, NULL, 0, '2023-12-01', 10),
(8, 1, 95, 0, '2023-12-01', 22),
(9, 0, NULL, 0, '2023-11-25', 30),
(10, 1, 80, 0, '2023-11-10', 35),
(11, 0, NULL, 0, '2023-12-02', 36),
(12, 1, 87, 0, '2023-12-01', 22),
(13, 0, NULL, 0, '2023-11-28', 50),
(14, 1, 92, 0, '2023-11-15', 37),
(15, 0, NULL, 0, '2023-12-01', 32),
(16, 1, 88, 0, '2023-12-02', 50),
(17, 0, NULL, 0, '2023-12-01', 4),
(18, 1, 75, 0, '2023-12-01', 18),
(19, 0, NULL, 0, '2023-11-20', 26),
(20, 1, 90, 0, '2023-11-25', 28),
(21, 0, NULL, 0, '2023-11-30', 10),
(22, 1, 85, 0, '2023-11-18', 15),
(23, 0, NULL, 0, '2023-12-01', 44),
(24, 1, 80, 0, '2023-12-01', 27),
(25, 0, NULL, 0, '2023-11-25', 1),
(26, 1, 78, 0, '2023-12-01', 24),
(27, 0, NULL, 0, '2023-12-02', 15),
(28, 1, 92, 0, '2023-12-03', 3),
(29, 0, NULL, 0, '2023-12-01', 21),
(30, 1, 90, 0, '2023-11-30', 45),
(31, 0, NULL, 0, '2023-11-18', 11),
(32, 1, 95, 0, '2023-12-01', 22),
(33, 0, NULL, 0, '2023-12-02', 24),
(34, 1, 85, 0, '2023-12-01', 3),
(35, 0, NULL, 0, '2023-12-01', 44),
(36, 1, 80, 0, '2023-12-01', 12),
(37, 0, NULL, 0, '2023-11-25', 24),
(38, 1, 88, 0, '2023-11-30', 36),
(39, 0, NULL, 0, '2023-12-02', 9),
(40, 1, 78, 0, '2023-12-03', 34),
(41, 0, NULL, 0, '2023-11-28', 42),
(42, 1, 92, 0, '2023-11-25', 6),
(43, 0, NULL, 0, '2023-12-01', 6),
(44, 1, 80, 0, '2023-12-01', 12),
(45, 0, NULL, 0, '2023-11-22', 39),
(46, 1, 95, 0, '2023-11-20', 12),
(47, 0, NULL, 0, '2023-12-02', 39),
(48, 1, 85, 0, '2023-12-01', 11),
(49, 0, NULL, 0, '2023-12-01', 29),
(50, 1, 85, 0, '2023-11-25', 27),
(51, 0, NULL, 0, '2023-12-01', 48),
(52, 1, 90, 0, '2023-12-01', 7),
(53, 0, NULL, 0, '2023-11-30', 40),
(54, 1, 78, 0, '2023-11-20', 31),
(55, 0, NULL, 0, '2023-12-01', 33),
(56, 1, 95, 0, '2023-12-01', 23),
(57, 0, NULL, 0, '2023-11-25', 13),
(58, 1, 80, 0, '2023-11-10', 46),
(59, 0, NULL, 0, '2023-12-02', 42),
(60, 1, 87, 0, '2023-12-01', 19),
(61, 0, NULL, 0, '2023-11-28', 19),
(62, 1, 92, 0, '2023-11-15', 39),
(63, 0, NULL, 0, '2023-12-01', 37),
(64, 1, 88, 0, '2023-12-02', 18),
(65, 0, NULL, 0, '2023-12-01', 29),
(66, 1, 75, 0, '2023-12-01', 38),
(67, 0, NULL, 0, '2023-11-20', 3),
(68, 1, 90, 0, '2023-11-25', 1),
(69, 0, NULL, 0, '2023-11-30', 48),
(70, 1, 85, 0, '2023-11-18', 33),
(71, 0, NULL, 0, '2023-12-01', 21),
(72, 1, 80, 0, '2023-12-01', 6),
(73, 0, NULL, 0, '2023-11-25', 15),
(74, 1, 78, 0, '2023-12-01', 6),
(75, 0, NULL, 0, '2023-12-02', 36),
(76, 1, 92, 0, '2023-12-03', 11),
(77, 0, NULL, 0, '2023-12-01', 46),
(78, 1, 90, 0, '2023-11-30', 46),
(79, 0, NULL, 0, '2023-11-18', 43),
(80, 1, 95, 0, '2023-12-01', 28),
(81, 0, NULL, 0, '2023-12-02', 9),
(82, 1, 85, 0, '2023-12-01', 10),
(83, 0, NULL, 0, '2023-12-01', 24),
(84, 1, 80, 0, '2023-12-01', 38),
(85, 0, NULL, 0, '2023-11-25', 18),
(86, 1, 88, 0, '2023-11-30', 25),
(87, 0, NULL, 0, '2023-12-02', 20),
(88, 1, 78, 0, '2023-12-03', 27),
(89, 0, NULL, 0, '2023-11-28', 23),
(90, 1, 92, 0, '2023-11-25', 35),
(91, 0, NULL, 0, '2023-12-01', 4),
(92, 1, 80, 0, '2023-12-01', 13),
(93, 0, NULL, 0, '2023-11-22', 4),
(94, 1, 95, 0, '2023-11-20', 30),
(95, 0, NULL, 0, '2023-12-02', 37),
(96, 1, 85, 0, '2023-12-01', 47);

-- --------------------------------------------------------

--
-- Estructura de la taula `dock`
--

CREATE TABLE `dock` (
  `idDock` int(11) NOT NULL,
  `ESTACIO_idESTACIO` int(11) NOT NULL,
  `bicicleta_idBICICLETA` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de la taula `estacio`
--

CREATE TABLE `estacio` (
  `idESTACIO` int(11) NOT NULL,
  `ubicacio` varchar(45) NOT NULL,
  `num_docksBicing` int(10) UNSIGNED NOT NULL,
  `docks_lliures` int(10) UNSIGNED NOT NULL,
  `carregador` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Bolcament de dades per a la taula `estacio`
--

INSERT INTO `estacio` (`idESTACIO`, `ubicacio`, `num_docksBicing`, `docks_lliures`, `carregador`) VALUES
(1, 'Plaça Catalunya', 20, 20, 1),
(2, 'Sagrada Família', 15, 15, 0),
(3, 'Parc de la Ciutadella', 12, 8, 0),
(4, 'Diagonal', 25, 25, 1),
(5, 'Gràcia', 10, 9, 0),
(6, 'Passeig de Sant Joan', 12, 12, 0),
(7, 'Rambla de Catalunya', 18, 18, 1),
(8, 'Plaça Espanya', 20, 20, 1),
(9, 'Port Vell', 14, 14, 0),
(10, 'Barceloneta', 15, 14, 1),
(11, 'Vila Olímpica', 12, 12, 0),
(12, 'Poblenou', 10, 10, 0),
(13, 'Parc Güell', 12, 12, 0),
(14, 'Tibidabo', 8, 8, 0),
(15, 'Sant Andreu', 10, 10, 0),
(16, 'Sants', 18, 18, 1),
(17, 'Camp Nou', 20, 20, 1),
(18, 'Montjuïc', 15, 15, 0),
(19, 'El Raval', 12, 12, 0),
(20, 'El Born', 14, 14, 0),
(21, 'Eixample Dreta', 16, 16, 1),
(22, 'Eixample Esquerra', 16, 16, 1),
(23, 'Les Corts', 12, 12, 0),
(24, 'Sarrià', 10, 10, 0),
(25, 'Sant Gervasi', 10, 10, 0),
(26, 'Horta', 12, 12, 0),
(27, 'Gràcia Alta', 12, 12, 0),
(28, 'Vila de Gràcia', 12, 12, 1),
(29, 'Poblesec', 10, 10, 0),
(30, 'Sagrada Família Nord', 10, 10, 0),
(31, 'Parc de Joan Miró', 14, 14, 1),
(32, 'Diagonal Mar', 16, 16, 1),
(33, 'Nova Icària', 12, 12, 0),
(34, 'Port Olímpic', 14, 14, 1),
(35, 'Besòs', 12, 12, 0),
(36, 'Sant Martí', 12, 12, 0),
(37, 'La Verneda', 10, 10, 0),
(38, 'Clot', 12, 12, 0),
(39, 'Camp de l\'Arpa', 10, 10, 0),
(40, 'Vila Olímpica Nord', 12, 12, 0),
(41, 'Parc del Fòrum', 14, 14, 1),
(42, 'Diagonal Nord', 16, 16, 1),
(43, 'Ronda Universitat', 14, 14, 0),
(44, 'Gran Via', 16, 16, 1),
(45, 'Passeig de Gràcia Sud', 18, 18, 1),
(46, 'Plaça Universitat', 20, 20, 1),
(47, 'Rambla del Raval', 12, 12, 0),
(48, 'Carrer de Balmes', 14, 14, 0),
(49, 'Carrer d\'Aragó', 16, 16, 1),
(50, 'Carrer de Valencia', 16, 16, 1);

-- --------------------------------------------------------

--
-- Estructura de la taula `incident_feedback`
--

CREATE TABLE `incident_feedback` (
  `idINCIDENT` int(11) NOT NULL,
  `roda` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'esata',
  `frens` tinyint(4) NOT NULL DEFAULT 0,
  `bateria_baixa` tinyint(4) NOT NULL DEFAULT 0,
  `manillar` tinyint(4) NOT NULL DEFAULT 0,
  `sillin` tinyint(4) NOT NULL DEFAULT 0,
  `TRAJECTE_idTRAJECTE` int(11) NOT NULL,
  `TRAJECTE_id_EST_origen` int(11) NOT NULL,
  `TRAJECTE_id_EST_fin` int(11) NOT NULL,
  `TRAJECTE_BICICLETA_idBICICLETA` int(11) NOT NULL,
  `TRAJECTE_BICICLETA_ESTACIO_idESTACIO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de la taula `tipus_subscripcions`
--

CREATE TABLE `tipus_subscripcions` (
  `idSUBSCRIPCIONS` int(11) NOT NULL,
  `nom_de_plan` varchar(45) NOT NULL,
  `precio_anual` varchar(45) DEFAULT NULL,
  `precio_por_MEDIA_hora` varchar(45) DEFAULT NULL,
  `precio_hora_extra` varchar(45) DEFAULT NULL,
  `TIEMPO_GRATIS` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Bolcament de dades per a la taula `tipus_subscripcions`
--

INSERT INTO `tipus_subscripcions` (`idSUBSCRIPCIONS`, `nom_de_plan`, `precio_anual`, `precio_por_MEDIA_hora`, `precio_hora_extra`, `TIEMPO_GRATIS`) VALUES
(1, 'Anual', '50', '0', '1', '30'),
(2, 'Trimestral', '20', '0', '2', '30'),
(3, 'Diaria', '5', '0', '3', '30');

-- --------------------------------------------------------

--
-- Estructura de la taula `trajecte`
--

CREATE TABLE `trajecte` (
  `idTRAJECTE` int(11) NOT NULL,
  `Hora_inici` datetime NOT NULL,
  `Hora_final` datetime DEFAULT NULL,
  `dock_final_lliure` tinyint(4) DEFAULT 1,
  `id_EST_origen` int(11) NOT NULL,
  `id_EST_fin` int(11) DEFAULT NULL,
  `BICICLETA_idBICICLETA` int(11) NOT NULL,
  `USUARI_idUSUARI` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Bolcament de dades per a la taula `trajecte`
--

INSERT INTO `trajecte` (`idTRAJECTE`, `Hora_inici`, `Hora_final`, `dock_final_lliure`, `id_EST_origen`, `id_EST_fin`, `BICICLETA_idBICICLETA`, `USUARI_idUSUARI`) VALUES
(1, '2026-02-03 08:09:19', '2026-02-03 15:42:19', 1, 12, 4, 48, 11),
(2, '2026-02-03 11:44:19', '2026-02-03 21:21:19', 1, 24, 46, 3, 2),
(3, '2026-02-03 13:01:19', '2026-02-03 15:57:19', 1, 28, 31, 11, 7),
(4, '2026-02-03 14:12:19', '2026-02-03 22:04:19', 1, 20, 16, 20, 6),
(5, '2026-02-03 05:37:19', '2026-02-03 16:53:19', 1, 5, 5, 16, 4),
(6, '2026-02-03 15:06:19', '2026-02-03 17:07:19', 1, 28, 19, 8, 4),
(7, '2026-02-03 06:14:19', '2026-02-04 01:49:19', 1, 49, 13, 6, 6),
(8, '2026-02-03 05:47:19', '2026-02-03 16:15:19', 1, 44, 8, 9, 3),
(9, '2026-02-03 08:34:19', '2026-02-04 02:18:19', 1, 38, 2, 40, 15),
(10, '2026-02-03 09:45:19', '2026-02-03 19:19:19', 1, 7, 35, 2, 2),
(11, '2026-02-03 11:13:19', '2026-02-03 23:49:19', 1, 19, 40, 33, 12),
(12, '2026-02-03 08:34:19', '2026-02-04 01:54:19', 1, 29, 15, 5, 12),
(13, '2026-02-03 07:57:19', '2026-02-03 15:38:19', 1, 8, 35, 43, 1),
(14, '2026-02-03 08:53:19', '2026-02-03 23:16:19', 1, 29, 45, 4, 12),
(15, '2026-02-03 03:48:19', '2026-02-04 02:07:19', 1, 24, 37, 48, 4),
(16, '2026-02-03 09:22:19', '2026-02-03 22:06:19', 1, 10, 18, 15, 3),
(17, '2026-02-03 09:06:19', '2026-02-03 22:37:19', 1, 18, 48, 13, 11),
(18, '2026-02-03 13:46:19', '2026-02-03 23:35:19', 1, 46, 29, 18, 2),
(19, '2026-02-03 14:08:19', '2026-02-03 21:46:19', 1, 13, 35, 34, 11),
(20, '2026-02-03 15:27:19', '2026-02-04 02:50:19', 1, 35, 32, 18, 1),
(21, '2026-02-03 03:40:19', '2026-02-04 02:05:19', 1, 22, 27, 3, 6),
(22, '2026-02-03 11:16:19', '2026-02-04 00:44:19', 1, 39, 28, 13, 8),
(23, '2026-02-03 13:18:19', '2026-02-04 02:16:19', 1, 46, 45, 47, 12),
(24, '2026-02-03 03:47:19', '2026-02-04 01:03:19', 1, 2, 39, 35, 12),
(25, '2026-02-03 11:09:19', '2026-02-04 00:05:19', 1, 24, 11, 8, 10),
(26, '2026-02-03 05:30:19', '2026-02-03 17:39:19', 1, 19, 17, 8, 9),
(27, '2026-02-03 10:54:19', '2026-02-04 01:52:19', 1, 8, 9, 14, 7),
(28, '2026-02-03 11:12:19', '2026-02-03 21:23:19', 1, 18, 16, 8, 7),
(29, '2026-02-03 10:45:19', '2026-02-04 03:25:19', 1, 38, 40, 5, 11),
(30, '2026-02-03 09:13:19', '2026-02-03 22:30:19', 1, 17, 45, 44, 7),
(31, '2026-02-03 11:40:19', '2026-02-03 22:27:19', 1, 46, 43, 47, 8),
(32, '2026-02-03 03:53:19', '2026-02-04 01:47:19', 1, 19, 12, 43, 2),
(33, '2026-02-03 13:37:19', '2026-02-03 23:43:19', 1, 47, 31, 8, 4),
(34, '2026-02-03 14:34:19', '2026-02-03 20:02:19', 1, 32, 3, 8, 6),
(35, '2026-02-03 14:52:19', '2026-02-03 18:40:19', 1, 8, 47, 10, 3),
(36, '2026-02-03 04:15:19', '2026-02-03 23:22:19', 1, 23, 13, 17, 15),
(37, '2026-02-03 04:20:19', '2026-02-03 23:31:19', 1, 27, 33, 25, 10),
(38, '2026-02-03 14:47:19', '2026-02-03 18:58:19', 1, 13, 19, 23, 2),
(39, '2026-02-03 07:24:19', '2026-02-03 20:11:19', 1, 46, 19, 38, 2),
(40, '2026-02-03 09:08:19', '2026-02-03 22:21:19', 1, 13, 26, 10, 13),
(41, '2026-02-03 06:39:19', '2026-02-03 23:50:19', 1, 12, 6, 25, 14),
(42, '2026-02-03 07:46:19', '2026-02-03 16:45:19', 1, 29, 27, 46, 15),
(43, '2026-02-03 05:28:19', '2026-02-03 17:47:19', 1, 21, 27, 44, 6),
(44, '2026-02-03 14:05:19', '2026-02-03 22:16:19', 1, 23, 28, 6, 7),
(45, '2026-02-03 10:55:19', '2026-02-04 02:01:19', 1, 11, 24, 45, 11),
(46, '2026-02-03 10:28:19', '2026-02-03 16:35:19', 1, 9, 31, 7, 8),
(47, '2026-02-03 11:08:19', '2026-02-04 00:13:19', 1, 27, 22, 36, 9),
(48, '2026-02-03 12:41:19', '2026-02-03 17:31:19', 1, 6, 4, 47, 1),
(49, '2026-02-03 14:21:19', '2026-02-03 21:22:19', 1, 7, 11, 9, 10),
(50, '2026-02-03 04:28:19', '2026-02-03 22:28:19', 1, 7, 45, 12, 1),
(51, '2026-02-03 07:30:19', '2026-02-03 19:01:19', 1, 23, 19, 7, 8),
(52, '2026-02-03 09:31:19', '2026-02-03 21:18:19', 1, 46, 4, 22, 10),
(53, '2026-02-03 11:24:19', '2026-02-03 23:36:19', 1, 17, 31, 44, 1),
(54, '2026-02-03 11:33:19', '2026-02-03 21:51:19', 1, 32, 30, 21, 2),
(55, '2026-02-03 09:59:19', '2026-02-03 19:11:19', 1, 7, 39, 40, 7),
(56, '2026-02-03 14:45:19', '2026-02-03 19:21:19', 1, 20, 2, 23, 15),
(57, '2026-02-03 06:33:19', '2026-02-04 00:03:19', 1, 16, 20, 42, 2),
(58, '2026-02-03 04:40:19', '2026-02-03 21:52:19', 1, 47, 2, 33, 6),
(59, '2026-02-03 13:04:19', '2026-02-04 02:25:19', 1, 47, 44, 12, 10),
(60, '2026-02-03 14:39:19', '2026-02-03 19:50:19', 1, 29, 40, 43, 4),
(61, '2026-02-03 12:56:19', '2026-02-03 15:38:19', 1, 20, 47, 37, 8),
(62, '2026-02-03 12:53:19', '2026-02-03 16:24:19', 1, 35, 14, 11, 4),
(63, '2026-02-03 06:04:19', '2026-02-04 02:33:19', 1, 12, 19, 37, 3),
(64, '2026-02-03 05:19:19', '2026-02-03 17:52:19', 1, 22, 27, 21, 6),
(65, '2026-02-03 05:45:19', '2026-02-04 02:50:19', 1, 14, 25, 3, 10),
(66, '2026-02-03 07:40:19', '2026-02-03 17:52:19', 1, 1, 23, 9, 4),
(67, '2026-02-03 10:48:19', '2026-02-04 03:01:19', 1, 31, 9, 33, 15),
(68, '2026-02-03 13:09:19', '2026-02-04 02:53:19', 1, 7, 42, 45, 12),
(69, '2026-02-03 07:06:19', '2026-02-03 21:31:19', 1, 20, 22, 16, 15),
(70, '2026-02-03 07:26:19', '2026-02-03 19:15:19', 1, 27, 35, 4, 14),
(71, '2026-02-03 04:17:19', '2026-02-03 23:19:19', 1, 22, 11, 8, 11),
(72, '2026-02-03 11:50:19', '2026-02-03 22:01:19', 1, 39, 14, 47, 1),
(73, '2026-02-03 10:57:19', '2026-02-04 01:46:19', 1, 6, 2, 32, 13),
(74, '2026-02-03 15:01:19', '2026-02-03 17:56:19', 1, 44, 39, 18, 4),
(75, '2026-02-03 12:51:19', '2026-02-03 16:58:19', 1, 47, 14, 18, 9),
(76, '2026-02-03 11:52:19', '2026-02-03 21:24:19', 1, 27, 9, 9, 5),
(77, '2026-02-03 15:06:19', '2026-02-03 17:31:19', 1, 36, 5, 37, 5),
(78, '2026-02-03 13:42:19', '2026-02-03 23:38:19', 1, 47, 29, 42, 2),
(79, '2026-02-03 05:25:19', '2026-02-03 18:04:19', 1, 27, 1, 38, 7),
(80, '2026-02-03 07:20:19', '2026-02-03 20:29:19', 1, 1, 42, 30, 2),
(81, '2026-02-03 09:22:19', '2026-02-03 21:52:19', 1, 5, 46, 34, 4),
(82, '2026-02-03 05:15:19', '2026-02-03 18:57:19', 1, 43, 21, 48, 8),
(83, '2026-02-03 13:39:19', '2026-02-04 00:56:19', 1, 23, 45, 35, 2),
(84, '2026-02-03 09:09:19', '2026-02-03 23:16:19', 1, 32, 10, 32, 2),
(85, '2026-02-03 06:12:19', '2026-02-04 02:03:19', 1, 3, 32, 10, 1),
(86, '2026-02-03 11:19:19', '2026-02-04 00:31:19', 1, 35, 11, 24, 15),
(87, '2026-02-03 05:23:19', '2026-02-03 17:11:19', 1, 8, 18, 47, 5),
(88, '2026-02-03 06:13:19', '2026-02-04 02:00:19', 1, 2, 27, 41, 9),
(89, '2026-02-03 14:34:19', '2026-02-03 18:00:19', 1, 40, 16, 22, 4),
(90, '2026-02-03 11:05:19', '2026-02-04 01:45:19', 1, 8, 9, 32, 7),
(91, '2026-02-03 04:19:19', '2026-02-03 23:17:19', 1, 22, 11, 12, 11),
(92, '2026-02-03 11:40:19', '2026-02-03 22:39:19', 1, 1, 11, 46, 2),
(93, '2026-02-03 05:59:19', '2026-02-04 02:51:19', 1, 17, 41, 45, 2),
(94, '2026-02-03 07:17:19', '2026-02-03 19:32:19', 1, 31, 2, 18, 6),
(95, '2026-02-03 06:56:19', '2026-02-03 21:32:19', 1, 18, 13, 22, 3),
(96, '2026-02-03 14:28:19', '2026-02-03 19:57:19', 1, 29, 39, 9, 2),
(97, '2026-02-03 13:42:19', '2026-02-03 22:14:19', 1, 17, 50, 10, 15),
(98, '2026-02-03 12:04:19', '2026-02-03 19:59:19', 1, 50, 42, 45, 4),
(99, '2026-02-03 04:54:19', '2026-02-03 20:33:19', 1, 22, 46, 48, 5),
(100, '2026-02-03 04:30:19', '2026-02-03 22:27:19', 1, 7, 45, 27, 2),
(101, '2026-02-03 14:13:19', '2026-02-03 22:05:19', 1, 20, 18, 6, 9),
(103, '2026-02-03 17:28:23', NULL, 1, 5, 10, 3, 2),
(104, '2026-02-03 19:02:09', NULL, 1, 10, 20, 5, 3),
(109, '2026-02-03 19:46:50', NULL, 1, 3, NULL, 7, 1),
(110, '2026-02-03 19:47:05', NULL, 1, 3, NULL, 7, 1),
(111, '2026-02-03 19:47:21', NULL, 1, 3, NULL, 7, 1),
(112, '2026-02-03 19:47:35', NULL, 1, 3, NULL, 7, 1);

--
-- Disparadors `trajecte`
--
DELIMITER $$
CREATE TRIGGER `finalitzar_trajecte` AFTER UPDATE ON `trajecte` FOR EACH ROW BEGIN
    DECLARE docks INT;

    -- activa quan el trajecte es tanca no abans
    IF OLD.Hora_final IS NULL AND NEW.Hora_final IS NOT NULL THEN
        
        -- Comprovar docks lliures a l'estació final
        SELECT docks_lliures INTO docks
        FROM ESTACIO
        WHERE idESTACIO = NEW.id_EST_fin;

        IF docks <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No hi ha docks lliures a l''estació final';
        END IF;

        -- Sumar 1 dock lliure
        UPDATE ESTACIO
        SET docks_lliures = docks_lliures + 1
        WHERE idESTACIO = NEW.id_EST_fin;

        -- Moure la bici a l'estació final
        UPDATE BICICLETA
        SET ESTACIO_idESTACIO = NEW.id_EST_fin
        WHERE idBICICLETA = NEW.BICICLETA_idBICICLETA;

    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `iniciar_trajecte` BEFORE INSERT ON `trajecte` FOR EACH ROW BEGIN
    -- Restar 1 dock lliure a l'estació origen
    UPDATE ESTACIO
    SET docks_lliures = docks_lliures - 1
    WHERE idESTACIO = NEW.id_EST_origen;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_bateria_abans_sortir` BEFORE INSERT ON `trajecte` FOR EACH ROW BEGIN
    DECLARE nivell INT;
    DECLARE es_electrica INT;

    SELECT electrica, batt_lvl
    INTO es_electrica, nivell
    FROM BICICLETA
    WHERE idBICICLETA = NEW.BICICLETA_idBICICLETA;

    -- Si és elèctrica i té menys del 20%, NO pot iniciar trajecte
    IF es_electrica = 1 AND nivell < 20 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bateria insuficient: aquesta bici no pot iniciar trajecte';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_subscripcio_abans_sortir` BEFORE INSERT ON `trajecte` FOR EACH ROW BEGIN
    DECLARE data_fi DATE;
    DECLARE dies_restants INT;

    -- Obtenir la data de fi de la subscripció de l’usuari
    SELECT data_fi
    INTO data_fi
    FROM SUBSCRIPCIO
    WHERE USUARI_idUSUARI = NEW.USUARI_idUSUARI;

    -- Si no té subscripció → bloquejar
    IF data_fi IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No tens subscripció activa';
    END IF;

    SET dies_restants = DATEDIFF(data_fi, CURDATE());

    -- Subscripció caducada → bloquejar
    IF dies_restants < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subscripció caducada: no pots iniciar trajecte';
    END IF;

    -- Subscripció a punt de caducar → avisar
    IF dies_restants BETWEEN 0 AND 5 THEN
        INSERT INTO AVIS_SUBSCRIPCIO (idUsuari, data_avis, dies_restants, missatge)
        VALUES (NEW.USUARI_idUSUARI, NOW(), dies_restants, 'La teva subscripció caducarà aviat');
    END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de la taula `usuari`
--

CREATE TABLE `usuari` (
  `idUSUARI` int(11) NOT NULL,
  `Nom` varchar(25) DEFAULT NULL,
  `Cognoms` varchar(125) DEFAULT NULL,
  `DNI` varchar(9) DEFAULT NULL,
  `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Bolcament de dades per a la taula `usuari`
--

INSERT INTO `usuari` (`idUSUARI`, `Nom`, `Cognoms`, `DNI`, `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`) VALUES
(1, 'Joan', 'Garcia Lopez', '12345678A', 1),
(2, 'Maria', 'Martinez Ruiz', '87654321B', 2),
(3, 'Pere', 'Sanchez Vidal', '11223344C', 3),
(4, 'Laura', 'Torres Puig', '55667788D', 1),
(5, 'Alex', 'Ramirez Costa', '99887766E', 2),
(6, 'Clara', 'Vidal Molina', '66778899F', 1),
(7, 'Marc', 'Gonzalez Soler', '33445566G', 3),
(8, 'Elena', 'Marti Pons', '99881122H', 2),
(9, 'David', 'Herrera Font', '44556677I', 1),
(10, 'Sara', 'Lopez Roca', '11224455J', 3),
(11, 'Ivan', 'Ferrer Puig', '55664433K', 2),
(12, 'Anna', 'Cano Vidal', '22334455L', 1),
(13, 'Oriol', 'Prats Costa', '66772233M', 2),
(14, 'Marta', 'Garcia Soler', '77889900N', 3),
(15, 'Joana', 'Soler Pons', '88990011O', 1);

--
-- Índexs per a les taules bolcades
--

--
-- Índexs per a la taula `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD PRIMARY KEY (`idBICICLETA`,`ESTACIO_idESTACIO`),
  ADD KEY `fk_BICICLETA_ESTACIO1_idx` (`ESTACIO_idESTACIO`);

--
-- Índexs per a la taula `dock`
--
ALTER TABLE `dock`
  ADD PRIMARY KEY (`idDock`),
  ADD KEY `fk_DOCK_ESTACIO_idx` (`ESTACIO_idESTACIO`),
  ADD KEY `fk_DOCK_BICICLETA_idx` (`bicicleta_idBICICLETA`);

--
-- Índexs per a la taula `estacio`
--
ALTER TABLE `estacio`
  ADD PRIMARY KEY (`idESTACIO`);

--
-- Índexs per a la taula `incident_feedback`
--
ALTER TABLE `incident_feedback`
  ADD PRIMARY KEY (`idINCIDENT`,`TRAJECTE_idTRAJECTE`,`TRAJECTE_id_EST_origen`,`TRAJECTE_id_EST_fin`,`TRAJECTE_BICICLETA_idBICICLETA`,`TRAJECTE_BICICLETA_ESTACIO_idESTACIO`),
  ADD KEY `fk_INCIDENT_feedback_TRAJECTE1_idx` (`TRAJECTE_idTRAJECTE`,`TRAJECTE_id_EST_origen`,`TRAJECTE_id_EST_fin`,`TRAJECTE_BICICLETA_idBICICLETA`,`TRAJECTE_BICICLETA_ESTACIO_idESTACIO`);

--
-- Índexs per a la taula `tipus_subscripcions`
--
ALTER TABLE `tipus_subscripcions`
  ADD PRIMARY KEY (`idSUBSCRIPCIONS`);

--
-- Índexs per a la taula `trajecte`
--
ALTER TABLE `trajecte`
  ADD PRIMARY KEY (`idTRAJECTE`),
  ADD KEY `fk_TRAJECTE_ESTACIO1_idx` (`id_EST_origen`),
  ADD KEY `fk_TRAJECTE_ESTACIO2_idx` (`id_EST_fin`),
  ADD KEY `fk_TRAJECTE_BICICLETA1_idx` (`BICICLETA_idBICICLETA`),
  ADD KEY `fk_TRAJECTE_USUARI1_idx` (`USUARI_idUSUARI`);

--
-- Índexs per a la taula `usuari`
--
ALTER TABLE `usuari`
  ADD PRIMARY KEY (`idUSUARI`),
  ADD KEY `fk_USUARI_tipus_SUBSCRIPCIONS_idx` (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`);

--
-- AUTO_INCREMENT per les taules bolcades
--

--
-- AUTO_INCREMENT per la taula `bicicleta`
--
ALTER TABLE `bicicleta`
  MODIFY `idBICICLETA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT per la taula `dock`
--
ALTER TABLE `dock`
  MODIFY `idDock` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la taula `incident_feedback`
--
ALTER TABLE `incident_feedback`
  MODIFY `idINCIDENT` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la taula `trajecte`
--
ALTER TABLE `trajecte`
  MODIFY `idTRAJECTE` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- Restriccions per a les taules bolcades
--

--
-- Restriccions per a la taula `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD CONSTRAINT `fk_BICICLETA_ESTACIO1` FOREIGN KEY (`ESTACIO_idESTACIO`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restriccions per a la taula `dock`
--
ALTER TABLE `dock`
  ADD CONSTRAINT `fk_DOCK_BICICLETA` FOREIGN KEY (`bicicleta_idBICICLETA`) REFERENCES `bicicleta` (`idBICICLETA`),
  ADD CONSTRAINT `fk_DOCK_ESTACIO` FOREIGN KEY (`ESTACIO_idESTACIO`) REFERENCES `estacio` (`idESTACIO`);

--
-- Restriccions per a la taula `trajecte`
--
ALTER TABLE `trajecte`
  ADD CONSTRAINT `fk_TRAJECTE_ESTACIO1` FOREIGN KEY (`id_EST_origen`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_TRAJECTE_ESTACIO2` FOREIGN KEY (`id_EST_fin`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_TRAJECTE_USUARI1` FOREIGN KEY (`USUARI_idUSUARI`) REFERENCES `usuari` (`idUSUARI`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restriccions per a la taula `usuari`
--
ALTER TABLE `usuari`
  ADD CONSTRAINT `fk_USUARI_tipus_SUBSCRIPCIONS` FOREIGN KEY (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`) REFERENCES `tipus_subscripcions` (`idSUBSCRIPCIONS`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
