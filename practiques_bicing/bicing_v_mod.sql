-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bicing_prac
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- -----------------------------------------------------
-- Schema BICING_PRAC
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BICING_PRAC
-- -----------------------------------------------------
-- DROP SCHEMA IF EXISTS `Bicing_prac`;
CREATE SCHEMA IF NOT EXISTS `BICING_PRAC` DEFAULT CHARACTER SET utf8 ;
USE `BICING_PRAC` ;
--
-- Table structure for table `bicicleta`
--

DROP TABLE IF EXISTS `bicicleta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bicicleta` (
  `idBICICLETA` int(11) NOT NULL AUTO_INCREMENT,
  `electrica` tinyint(4) NOT NULL DEFAULT 0,
  `batt_lvl` decimal(3,0) unsigned DEFAULT NULL,
  `incident_acumulats` int(11) NOT NULL DEFAULT 0,
  `data_ultim_manteniment` date NOT NULL,
  `ESTACIO_idESTACIO` int(11) NOT NULL,
  PRIMARY KEY (`idBICICLETA`),
  KEY `fk_BICICLETA_ESTACIO1_idx` (`ESTACIO_idESTACIO`),
  CONSTRAINT `fk_BICICLETA_ESTACIO1` FOREIGN KEY (`ESTACIO_idESTACIO`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bicicleta`
--

LOCK TABLES `bicicleta` WRITE;
/*!40000 ALTER TABLE `bicicleta` DISABLE KEYS */;
INSERT INTO `bicicleta` VALUES (1,0,NULL,0,'2023-12-01',37),(2,1,85,1,'2023-11-25',3),(3,0,NULL,0,'2023-12-01',7),(4,1,18,2,'2023-12-01',22),(5,0,NULL,0,'2023-11-30',42),(6,1,78,1,'2023-11-20',40),(7,0,NULL,0,'2023-12-01',25),(8,1,95,1,'2023-12-01',4),(9,0,NULL,0,'2023-11-25',44),(10,1,80,1,'2023-11-10',7),(11,0,NULL,0,'2023-12-02',4),(12,1,87,1,'2023-12-01',47),(13,0,NULL,0,'2023-11-28',23),(14,1,92,1,'2023-11-15',25),(15,0,NULL,0,'2023-12-01',6),(16,1,88,1,'2023-12-02',2),(17,0,NULL,0,'2023-12-01',41),(18,1,75,1,'2023-12-01',48),(19,0,NULL,0,'2023-11-20',19),(20,1,90,1,'2023-11-25',1),(21,0,NULL,0,'2023-11-30',47),(22,1,85,1,'2023-11-18',29),(23,0,NULL,0,'2023-12-01',7),(24,1,80,1,'2023-12-01',46),(25,0,NULL,0,'2023-11-25',11),(26,1,78,1,'2023-12-01',13),(27,0,NULL,0,'2023-12-02',32),(28,1,92,1,'2023-12-03',22),(29,0,NULL,0,'2023-12-01',14),(30,1,90,1,'2023-11-30',4),(31,0,NULL,0,'2023-11-18',25),(32,1,95,1,'2023-12-01',14),(33,0,NULL,0,'2023-12-02',45),(34,1,85,1,'2023-12-01',31),(35,0,NULL,0,'2023-12-01',21),(36,1,80,1,'2023-12-01',9),(37,0,NULL,0,'2023-11-25',32),(38,1,88,1,'2023-11-30',34),(39,0,NULL,0,'2023-12-02',24),(40,1,78,1,'2023-12-03',16),(41,0,NULL,0,'2023-11-28',7),(42,1,92,1,'2023-11-25',37),(43,0,NULL,0,'2023-12-01',15),(44,1,80,1,'2023-12-01',14),(45,0,NULL,0,'2023-11-22',23),(46,1,95,1,'2023-11-20',22),(47,0,NULL,0,'2023-12-02',40),(48,1,85,1,'2023-12-01',32);
/*!40000 ALTER TABLE `bicicleta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dock`
--

DROP TABLE IF EXISTS `dock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dock` (
  `idDock` int(11) NOT NULL AUTO_INCREMENT,
  `ESTACIO_idESTACIO` int(11) NOT NULL,
  `bicicleta_idBICICLETA` int(11) DEFAULT NULL,
  PRIMARY KEY (`idDock`),
  UNIQUE KEY `bicicleta_idBICICLETA` (`bicicleta_idBICICLETA`),
  KEY `fk_DOCK_ESTACIO_idx` (`ESTACIO_idESTACIO`),
  KEY `fk_DOCK_BICICLETA_idx` (`bicicleta_idBICICLETA`),
  CONSTRAINT `fk_DOCK_BICICLETA` FOREIGN KEY (`bicicleta_idBICICLETA`) REFERENCES `bicicleta` (`idBICICLETA`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_DOCK_ESTACIO` FOREIGN KEY (`ESTACIO_idESTACIO`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dock`
--

LOCK TABLES `dock` WRITE;
/*!40000 ALTER TABLE `dock` DISABLE KEYS */;
/*!40000 ALTER TABLE `dock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estacio`
--

DROP TABLE IF EXISTS `estacio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estacio` (
  `idESTACIO` int(11) NOT NULL,
  `ubicacio` varchar(45) NOT NULL,
  `num_docksBicing` int(10) unsigned NOT NULL,
  `docks_lliures` int(10) unsigned NOT NULL,
  `carregador` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idESTACIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estacio`
--

LOCK TABLES `estacio` WRITE;
/*!40000 ALTER TABLE `estacio` DISABLE KEYS */;
INSERT INTO `estacio` VALUES (1,'Plaça Catalunya',20,20,1),(2,'Sagrada Família',15,15,0),(3,'Parc de la Ciutadella',12,12,0),(4,'Diagonal',25,25,1),(5,'Gràcia',10,10,0),(6,'Passeig de Sant Joan',12,12,0),(7,'Rambla de Catalunya',18,18,1),(8,'Plaça Espanya',20,20,1),(9,'Port Vell',14,14,0),(10,'Barceloneta',15,15,1),(11,'Vila Olímpica',12,12,0),(12,'Poblenou',10,10,0),(13,'Parc Güell',12,12,0),(14,'Tibidabo',8,8,0),(15,'Sant Andreu',10,10,0),(16,'Sants',18,18,1),(17,'Camp Nou',20,20,1),(18,'Montjuïc',15,15,0),(19,'El Raval',12,12,0),(20,'El Born',14,14,0),(21,'Eixample Dreta',16,16,1),(22,'Eixample Esquerra',16,16,1),(23,'Les Corts',12,12,0),(24,'Sarrià',10,10,0),(25,'Sant Gervasi',10,10,0),(26,'Horta',12,12,0),(27,'Gràcia Alta',12,12,0),(28,'Vila de Gràcia',12,12,1),(29,'Poblesec',10,10,0),(30,'Sagrada Família Nord',10,10,0),(31,'Parc de Joan Miró',14,14,1),(32,'Diagonal Mar',16,16,1),(33,'Nova Icària',12,12,0),(34,'Port Olímpic',14,14,1),(35,'Besòs',12,12,0),(36,'Sant Martí',12,12,0),(37,'La Verneda',10,10,0),(38,'Clot',12,12,0),(39,'Camp de l\'Arpa',10,10,0),(40,'Vila Olímpica Nord',12,12,0),(41,'Parc del Fòrum',14,14,1),(42,'Diagonal Nord',16,16,1),(43,'Ronda Universitat',14,14,0),(44,'Gran Via',16,16,1),(45,'Passeig de Gràcia Sud',18,18,1),(46,'Plaça Universitat',20,20,1),(47,'Rambla del Raval',12,12,0),(48,'Carrer de Balmes',14,14,0),(49,'Carrer d\'Aragó',16,16,1),(50,'Carrer de Valencia',16,16,1);
/*!40000 ALTER TABLE `estacio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_feedback`
--

DROP TABLE IF EXISTS `incident_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_feedback` (
  `idINCIDENT` int(11) NOT NULL AUTO_INCREMENT,
  `roda` tinyint(4) NOT NULL DEFAULT 0,
  `frens` tinyint(4) NOT NULL DEFAULT 0,
  `bateria_baixa` tinyint(4) NOT NULL DEFAULT 0,
  `manillar` tinyint(4) NOT NULL DEFAULT 0,
  `sillin` tinyint(4) NOT NULL DEFAULT 0,
  `TRAJECTE_idTRAJECTE` int(11) NOT NULL,
  PRIMARY KEY (`idINCIDENT`),
  KEY `fk_INCIDENT_feedback_TRAJECTE1_idx` (`TRAJECTE_idTRAJECTE`),
  CONSTRAINT `fk_INCIDENT_feedback_TRAJECTE1` FOREIGN KEY (`TRAJECTE_idTRAJECTE`) REFERENCES `trajecte` (`idTRAJECTE`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_feedback`
--

LOCK TABLES `incident_feedback` WRITE;
/*!40000 ALTER TABLE `incident_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipus_subscripcions`
--

DROP TABLE IF EXISTS `tipus_subscripcions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipus_subscripcions` (
  `idSUBSCRIPCIONS` int(11) NOT NULL AUTO_INCREMENT,
  `nom_de_plan` varchar(45) NOT NULL,
  `precio_anual` decimal(6,2) DEFAULT NULL,
  `precio_por_MEDIA_hora` decimal(5,2) DEFAULT NULL,
  `precio_hora_extra` decimal(5,2) DEFAULT NULL,
  `TIEMPO_GRATIS` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSUBSCRIPCIONS`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipus_subscripcions`
--

LOCK TABLES `tipus_subscripcions` WRITE;
/*!40000 ALTER TABLE `tipus_subscripcions` DISABLE KEYS */;
INSERT INTO `tipus_subscripcions` VALUES (1,'Anual',50.00,0.00,1.00,30),(2,'Trimestral',20.00,0.00,2.00,30),(3,'Diaria',5.00,0.00,3.00,30);
/*!40000 ALTER TABLE `tipus_subscripcions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trajecte`
--

DROP TABLE IF EXISTS `trajecte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trajecte` (
  `idTRAJECTE` int(11) NOT NULL AUTO_INCREMENT,
  `Hora_inici` datetime NOT NULL,
  `Hora_final` datetime DEFAULT NULL,
  `dock_final_lliure` tinyint(4) DEFAULT 1,
  `id_EST_origen` int(11) NOT NULL,
  `id_EST_fin` int(11) DEFAULT NULL,
  `BICICLETA_idBICICLETA` int(11) NOT NULL,
  `USUARI_idUSUARI` int(11) NOT NULL,
  PRIMARY KEY (`idTRAJECTE`),
  KEY `fk_TRAJECTE_ESTACIO1_idx` (`id_EST_origen`),
  KEY `fk_TRAJECTE_ESTACIO2_idx` (`id_EST_fin`),
  KEY `fk_TRAJECTE_BICICLETA1_idx` (`BICICLETA_idBICICLETA`),
  KEY `fk_TRAJECTE_USUARI1_idx` (`USUARI_idUSUARI`),
  CONSTRAINT `fk_TRAJECTE_BICICLETA1` FOREIGN KEY (`BICICLETA_idBICICLETA`) REFERENCES `bicicleta` (`idBICICLETA`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRAJECTE_ESTACIO1` FOREIGN KEY (`id_EST_origen`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRAJECTE_ESTACIO2` FOREIGN KEY (`id_EST_fin`) REFERENCES `estacio` (`idESTACIO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRAJECTE_USUARI1` FOREIGN KEY (`USUARI_idUSUARI`) REFERENCES `usuari` (`idUSUARI`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trajecte`
--

LOCK TABLES `trajecte` WRITE;
/*!40000 ALTER TABLE `trajecte` DISABLE KEYS */;
INSERT INTO `trajecte` VALUES (1,'2026-02-04 12:52:21',NULL,1,4,NULL,16,1),(2,'2026-02-04 16:57:21',NULL,1,24,NULL,16,15),(3,'2026-02-04 08:34:21',NULL,1,50,NULL,2,8),(4,'2026-02-04 06:41:21',NULL,1,41,NULL,37,2),(5,'2026-02-04 18:07:21',NULL,1,2,NULL,30,2),(6,'2026-02-04 09:34:21',NULL,1,28,NULL,6,9),(7,'2026-02-04 08:23:21',NULL,1,5,NULL,37,1),(8,'2026-02-04 11:27:21',NULL,1,34,NULL,15,10),(9,'2026-02-04 16:16:21',NULL,1,35,NULL,3,14),(10,'2026-02-04 13:02:21',NULL,1,8,NULL,18,8);
/*!40000 ALTER TABLE `trajecte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuari`
--

DROP TABLE IF EXISTS `usuari`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuari` (
  `idUSUARI` int(11) NOT NULL AUTO_INCREMENT,
  `Nom` varchar(25) DEFAULT NULL,
  `Cognoms` varchar(125) DEFAULT NULL,
  `DNI` varchar(9) DEFAULT NULL,
  `data_subscripcio` date DEFAULT NULL,
  `renovacio` date DEFAULT NULL,
  `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` int(11) NOT NULL,
  PRIMARY KEY (`idUSUARI`),
  UNIQUE KEY `DNI` (`DNI`),
  KEY `fk_USUARI_tipus_SUBSCRIPCIONS_idx` (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`),
  CONSTRAINT `fk_USUARI_tipus_SUBSCRIPCIONS` FOREIGN KEY (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`) REFERENCES `tipus_subscripcions` (`idSUBSCRIPCIONS`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




DROP TABLE IF EXISTS `bicing_prac`.`facturacio` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`facturacio` (
  `id_factura` INT(11) NOT NULL AUTO_INCREMENT,
  hora datetime default now(),
  id_trajecte int not null ,
  
  `id_user` INT(11) NULL,/* si posem id de trajecte , ja tindriem relacionat aquest valor....*/
  `temps` TIME NULL, /* si posem id de trajecte , ja tindriem relacionat aquest valor....*/
  -- AMB LA ID de trajecte associat, podríem trobar aquests dos valors... però s'hauria de calcular cada cop
  
  `preu` DECIMAL(11,3) NULL DEFAULT NULL,
  `subcripcio` INT(11) NULL DEFAULT NULL, /* no faria falta xk ja tenim usuari, però podria canviar de subscrupcio entre viatges, mantenim el valor. */
    PRIMARY KEY (`id_factura`),
  INDEX `usuari_a_facturar` (`id_user` ASC) ,
  INDEX `subcripcio` (`subcripcio` ASC) ,
  CONSTRAINT `facturacio_ibfk_1`
    FOREIGN KEY (`subcripcio`)
    REFERENCES `bicing_prac`.`tipus_subscripcions` (`idSUBSCRIPCIONS`),
  CONSTRAINT `usuari_a_facturar`
    FOREIGN KEY (`id_user`)
    REFERENCES `bicing_prac`.`usuari` (`idUSUARI`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;



--
-- Dumping data for table `usuari`
--

LOCK TABLES `usuari` WRITE;
/*!40000 ALTER TABLE `usuari` DISABLE KEYS */;
INSERT INTO `usuari` VALUES (1,'Joan','Garcia Lopez','12345678A','2024-03-16','2025-03-16',1),(2,'Maria','Martinez Ruiz','87654321B','2025-04-12','2026-04-12',2),(3,'Pere','Sanchez Vidal','11223344C','2025-09-08','2026-09-08',3),(4,'Laura','Torres Puig','55667788D','2024-07-01','2025-07-01',1),(5,'Alex','Ramirez Costa','99887766E','2025-04-29','2026-04-29',2),(6,'Clara','Vidal Molina','66778899F','2025-01-13','2026-01-13',1),(7,'Marc','Gonzalez Soler','33445566G','2025-02-04','2026-02-04',3),(8,'Elena','Marti Pons','99881122H','2024-04-10','2025-04-10',2),(9,'David','Herrera Font','44556677I','2025-12-25','2026-12-25',1),(10,'Sara','Lopez Roca','11224455J','2024-12-30','2025-12-30',3),(11,'Ivan','Ferrer Puig','55664433K','2024-12-07','2025-12-07',2),(12,'Anna','Cano Vidal','22334455L','2025-07-31','2026-07-31',1),(13,'Oriol','Prats Costa','66772233M','2024-12-29','2025-12-29',2),(14,'Marta','Garcia Soler','77889900N','2024-02-20','2025-02-20',3),(15,'Joana','Soler Pons','88990011O','2025-08-07','2026-08-07',1);
/*!40000 ALTER TABLE `usuari` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-05 18:31:43


