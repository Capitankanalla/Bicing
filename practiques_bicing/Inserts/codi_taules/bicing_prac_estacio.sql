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
INSERT INTO `estacio` VALUES (1,'Plaça Catalunya',20,20,1),(2,'Sagrada Família',15,15,0),(3,'Parc de la Ciutadella',12,12,0),(4,'Diagonal',25,25,1),(5,'Gràcia',10,9,0),(6,'Passeig de Sant Joan',12,12,0),(7,'Rambla de Catalunya',18,18,1),(8,'Plaça Espanya',20,20,1),(9,'Port Vell',14,14,0),(10,'Barceloneta',15,15,1),(11,'Vila Olímpica',12,12,0),(12,'Poblenou',10,10,0),(13,'Parc Güell',12,12,0),(14,'Tibidabo',8,8,0),(15,'Sant Andreu',10,10,0),(16,'Sants',18,18,1),(17,'Camp Nou',20,20,1),(18,'Montjuïc',15,15,0),(19,'El Raval',12,12,0),(20,'El Born',14,14,0),(21,'Eixample Dreta',16,16,1),(22,'Eixample Esquerra',16,16,1),(23,'Les Corts',12,12,0),(24,'Sarrià',10,10,0),(25,'Sant Gervasi',10,10,0),(26,'Horta',12,12,0),(27,'Gràcia Alta',12,12,0),(28,'Vila de Gràcia',12,12,1),(29,'Poblesec',10,10,0),(30,'Sagrada Família Nord',10,10,0),(31,'Parc de Joan Miró',14,14,1),(32,'Diagonal Mar',16,16,1),(33,'Nova Icària',12,12,0),(34,'Port Olímpic',14,14,1),(35,'Besòs',12,12,0),(36,'Sant Martí',12,12,0),(37,'La Verneda',10,10,0),(38,'Clot',12,12,0),(39,'Camp de l\'Arpa',10,10,0),(40,'Vila Olímpica Nord',12,12,0),(41,'Parc del Fòrum',14,14,1),(42,'Diagonal Nord',16,16,1),(43,'Ronda Universitat',14,14,0),(44,'Gran Via',16,16,1),(45,'Passeig de Gràcia Sud',18,18,1),(46,'Plaça Universitat',20,20,1),(47,'Rambla del Raval',12,12,0),(48,'Carrer de Balmes',14,14,0),(49,'Carrer d\'Aragó',16,16,1),(50,'Carrer de Valencia',16,16,1);
/*!40000 ALTER TABLE `estacio` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-03 18:51:58
