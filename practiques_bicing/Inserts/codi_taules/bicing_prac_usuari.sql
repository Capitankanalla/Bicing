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

--
-- Table structure for table `usuari`
--

DROP TABLE IF EXISTS `usuari`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuari` (
  `idUSUARI` int(11) NOT NULL,
  `Nom` varchar(25) DEFAULT NULL,
  `Cognoms` varchar(125) DEFAULT NULL,
  `DNI` varchar(9) DEFAULT NULL,
  `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` int(11) NOT NULL,
  PRIMARY KEY (`idUSUARI`),
  KEY `fk_USUARI_tipus_SUBSCRIPCIONS_idx` (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`),
  CONSTRAINT `fk_USUARI_tipus_SUBSCRIPCIONS` FOREIGN KEY (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`) REFERENCES `tipus_subscripcions` (`idSUBSCRIPCIONS`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuari`
--

LOCK TABLES `usuari` WRITE;
/*!40000 ALTER TABLE `usuari` DISABLE KEYS */;
INSERT INTO `usuari` VALUES (1,'Joan','Garcia Lopez','12345678A',1),(2,'Maria','Martinez Ruiz','87654321B',2),(3,'Pere','Sanchez Vidal','11223344C',3),(4,'Laura','Torres Puig','55667788D',1),(5,'Alex','Ramirez Costa','99887766E',2),(6,'Clara','Vidal Molina','66778899F',1),(7,'Marc','Gonzalez Soler','33445566G',3),(8,'Elena','Marti Pons','99881122H',2),(9,'David','Herrera Font','44556677I',1),(10,'Sara','Lopez Roca','11224455J',3),(11,'Ivan','Ferrer Puig','55664433K',2),(12,'Anna','Cano Vidal','22334455L',1),(13,'Oriol','Prats Costa','66772233M',2),(14,'Marta','Garcia Soler','77889900N',3),(15,'Joana','Soler Pons','88990011O',1);
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

-- Dump completed on 2026-02-03 18:51:59
