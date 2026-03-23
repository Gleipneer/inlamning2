-- PRESENTATIONSTIPS: Dessa rader är utkommenterade så att du kan återställa databasen var du vill
-- CREATE DATABASE  IF NOT EXISTS `inlamning2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
-- USE `inlamning2`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: inlamning2
-- ------------------------------------------------------
-- Server version	9.5.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

-- SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '44c914fb-bf9c-11f0-94c4-00155d3dafff:1-1066';

--
-- Table structure for table `bestallningar`
--

DROP TABLE IF EXISTS `bestallningar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bestallningar` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `KundID` int NOT NULL,
  `Datum` date NOT NULL,
  `Totalbelopp` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `KundID` (`KundID`),
  CONSTRAINT `bestallningar_ibfk_1` FOREIGN KEY (`KundID`) REFERENCES `kunder` (`KundID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bestallningar`
--

LOCK TABLES `bestallningar` WRITE;
/*!40000 ALTER TABLE `bestallningar` DISABLE KEYS */;
INSERT INTO `bestallningar` VALUES (1,1,'2025-01-02',159.80),(2,2,'2025-02-03',51.60),(3,1,'2025-03-10',89.00),(4,1,'2025-03-15',199.00),(5,3,'2025-03-18',79.90);
/*!40000 ALTER TABLE `bestallningar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bocker`
--

DROP TABLE IF EXISTS `bocker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bocker` (
  `BokID` int NOT NULL AUTO_INCREMENT,
  `Titel` varchar(255) NOT NULL,
  `ISBN` bigint NOT NULL,
  `Forfattare` varchar(255) NOT NULL,
  `Pris` decimal(10,2) NOT NULL,
  `Lagerstatus` int DEFAULT '0',
  PRIMARY KEY (`BokID`),
  UNIQUE KEY `ISBN` (`ISBN`),
  CONSTRAINT `bocker_chk_1` CHECK ((`Pris` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bocker`
--

LOCK TABLES `bocker` WRITE;
/*!40000 ALTER TABLE `bocker` DISABLE KEYS */;
INSERT INTO `bocker` VALUES (1,'Pojken och Äventyret',123124135235132,'Jonsered Backen',79.90,197),(2,'Tiden som Tickade',1231352453214,'Temu Toskinen',12.90,71),(3,'JionDao och Kranen',1343453234,'Irma Svensson',89.00,30),(4,'Databas för Nybörjare',9781234567890,'Fredrik Lorensson',199.00,14);
/*!40000 ALTER TABLE `bocker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kunder`
--

DROP TABLE IF EXISTS `kunder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kunder` (
  `KundID` int NOT NULL AUTO_INCREMENT,
  `Namn` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Telefon` varchar(20) DEFAULT NULL,
  `Adress` varchar(100) NOT NULL,
  `Registreringsdatum` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`KundID`),
  UNIQUE KEY `Telefon` (`Telefon`),
  KEY `idx_kunder_email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kunder`
--

LOCK TABLES `kunder` WRITE;
/*!40000 ALTER TABLE `kunder` DISABLE KEYS */;
INSERT INTO `kunder` VALUES (1,'Joakim Emilsson','emilssonjoakim@gmail.com','0760178885','Alsteråvägen 42','2026-03-15 17:46:27'),(2,'Johan Johansson','johanssonjohan@gmail.com','0702222222','Parkvägen 5','2026-03-15 17:46:27'),(3,'Cecilia Holm','holmcecilia@gmail.com','0703333333','Havsgatan 12','2026-03-15 17:46:27'),(4,'Anna Svensson','anna.svensson@gmail.com','0704444444','Skolgatan 9','2026-03-15 17:46:27');
/*!40000 ALTER TABLE `kunder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kundlogg`
--

DROP TABLE IF EXISTS `kundlogg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kundlogg` (
  `LoggID` int NOT NULL AUTO_INCREMENT,
  `KundID` int NOT NULL,
  `Namn` varchar(100) NOT NULL,
  `Handelse` varchar(100) NOT NULL,
  `Tidpunkt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LoggID`),
  KEY `KundID` (`KundID`),
  CONSTRAINT `kundlogg_ibfk_1` FOREIGN KEY (`KundID`) REFERENCES `kunder` (`KundID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kundlogg`
--

LOCK TABLES `kundlogg` WRITE;
/*!40000 ALTER TABLE `kundlogg` DISABLE KEYS */;
INSERT INTO `kundlogg` VALUES (1,1,'Joakim Emilsson','Ny kund registrerad','2026-03-15 17:46:27'),(2,2,'Johan Johansson','Ny kund registrerad','2026-03-15 17:46:27'),(3,3,'Cecilia Holm','Ny kund registrerad','2026-03-15 17:46:27'),(4,4,'Anna Svensson','Ny kund registrerad','2026-03-15 17:46:27');
/*!40000 ALTER TABLE `kundlogg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderrader`
--

DROP TABLE IF EXISTS `orderrader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderrader` (
  `OrderradID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `BokID` int NOT NULL,
  `Antal` int NOT NULL,
  `Radpris` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderradID`),
  KEY `OrderID` (`OrderID`),
  KEY `BokID` (`BokID`),
  CONSTRAINT `orderrader_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `bestallningar` (`OrderID`),
  CONSTRAINT `orderrader_ibfk_2` FOREIGN KEY (`BokID`) REFERENCES `bocker` (`BokID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderrader`
--

LOCK TABLES `orderrader` WRITE;
/*!40000 ALTER TABLE `orderrader` DISABLE KEYS */;
INSERT INTO `orderrader` VALUES (1,1,1,2,159.80),(2,2,2,4,51.60),(3,3,3,1,89.00),(4,4,4,1,199.00),(5,5,1,1,79.90);
/*!40000 ALTER TABLE `orderrader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'inlamning2'
--

--
-- Dumping routines for database 'inlamning2'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-23 19:34:22
