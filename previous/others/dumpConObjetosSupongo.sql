-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: feeast
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `idDireccion` int DEFAULT NULL,
  `nombreCliente` varchar(75) DEFAULT NULL,
  `correo` varchar(254) NOT NULL,
  `username` varchar(32) NOT NULL,
  `CURP` varchar(18) DEFAULT NULL,
  `fechaRegistro` timestamp NULL DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `correoSec` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `idDireccion_UNIQUE` (`idDireccion`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,NULL,NULL,'danycr2007@gmail.com','Castillo',NULL,NULL,'d_e_i_2007',NULL);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compensacionitem`
--

DROP TABLE IF EXISTS `compensacionitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compensacionitem` (
  `idCompensacionItem` int NOT NULL AUTO_INCREMENT,
  `idItem` int NOT NULL,
  `idRenta` int NOT NULL,
  `cantItemCompensacion` int DEFAULT NULL,
  PRIMARY KEY (`idCompensacionItem`,`idRenta`,`idItem`),
  KEY `idItem_idx` (`idItem`),
  KEY `idRenta_idx` (`idRenta`),
  CONSTRAINT `fk_idItem_CompensacionItem` FOREIGN KEY (`idItem`) REFERENCES `item` (`idItem`),
  CONSTRAINT `fk_idRenta_CompensacionItem` FOREIGN KEY (`idRenta`) REFERENCES `renta` (`idRenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compensacionitem`
--

LOCK TABLES `compensacionitem` WRITE;
/*!40000 ALTER TABLE `compensacionitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `compensacionitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direccion`
--

DROP TABLE IF EXISTS `direccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direccion` (
  `idDireccion` int NOT NULL AUTO_INCREMENT,
  `numeroVivienda` varchar(20) DEFAULT NULL,
  `calle` varchar(100) DEFAULT NULL,
  `codigoPostal` varchar(10) DEFAULT NULL,
  `numeroInterior` int DEFAULT NULL,
  PRIMARY KEY (`idDireccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `direccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `idItem` int NOT NULL AUTO_INCREMENT,
  `idTipo` int NOT NULL,
  `nombreItem` varchar(45) DEFAULT NULL,
  `ancho` float DEFAULT NULL,
  `alto` float DEFAULT NULL,
  `largo` float DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `cantidadDisponible` int DEFAULT NULL,
  `cantidadTotal` int DEFAULT NULL,
  PRIMARY KEY (`idItem`),
  KEY `idTipo_idx` (`idTipo`),
  CONSTRAINT `fk_idTipo` FOREIGN KEY (`idTipo`) REFERENCES `tipoitem` (`idTipoItem`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (3,2,'Brincolín pequeño',10,10,10,500.00,1,1),(4,3,'Tablón Marrón',5,2,0.5,80.00,5,5),(6,1,'Inflable Rosa',8,4,5,500.00,1,1);
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numero`
--

DROP TABLE IF EXISTS `numero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `numero` (
  `idNumero` int NOT NULL AUTO_INCREMENT,
  `idCliente` int DEFAULT NULL,
  `numeroTelefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`idNumero`),
  KEY `idCliente_idx` (`idCliente`),
  CONSTRAINT `fk_idCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numero`
--

LOCK TABLES `numero` WRITE;
/*!40000 ALTER TABLE `numero` DISABLE KEYS */;
/*!40000 ALTER TABLE `numero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona`
--

DROP TABLE IF EXISTS `persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persona` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `paterno` varchar(30) DEFAULT NULL,
  `materno` varchar(30) DEFAULT NULL,
  `edad` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona`
--

LOCK TABLES `persona` WRITE;
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` VALUES (2,'Hola','Hola','Hola',25);
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reldireccioncliente`
--

DROP TABLE IF EXISTS `reldireccioncliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reldireccioncliente` (
  `idrelDireccionCliente` int NOT NULL AUTO_INCREMENT,
  `idDireccion` int DEFAULT NULL,
  `idCliente` int DEFAULT NULL,
  PRIMARY KEY (`idrelDireccionCliente`),
  KEY `idDireccion_idx` (`idDireccion`),
  KEY `idCliente_idx` (`idCliente`),
  CONSTRAINT `fk_relDireccionCliente_idCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `fk_relDireccionCliente_idDireccion` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reldireccioncliente`
--

LOCK TABLES `reldireccioncliente` WRITE;
/*!40000 ALTER TABLE `reldireccioncliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `reldireccioncliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relrentaitem`
--

DROP TABLE IF EXISTS `relrentaitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relrentaitem` (
  `idRelRentaItem` int NOT NULL AUTO_INCREMENT,
  `idRenta` int NOT NULL,
  `idItem` int NOT NULL,
  `cantItem` int DEFAULT NULL,
  PRIMARY KEY (`idRelRentaItem`,`idRenta`,`idItem`),
  KEY `idRenta_idx` (`idRenta`),
  KEY `idItem_idx` (`idItem`),
  CONSTRAINT `fk_idItem_relRentaItem` FOREIGN KEY (`idItem`) REFERENCES `item` (`idItem`),
  CONSTRAINT `fk_idRenta` FOREIGN KEY (`idRenta`) REFERENCES `renta` (`idRenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relrentaitem`
--

LOCK TABLES `relrentaitem` WRITE;
/*!40000 ALTER TABLE `relrentaitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `relrentaitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renta`
--

DROP TABLE IF EXISTS `renta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renta` (
  `idRenta` int NOT NULL AUTO_INCREMENT,
  `Cliente_idCliente` int NOT NULL,
  `idDireccion` int NOT NULL,
  `fechaHoraRenta` timestamp NULL DEFAULT NULL,
  `ubicRenta` varchar(45) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `compensacion` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idRenta`),
  KEY `fk_Renta_Cliente1_idx` (`Cliente_idCliente`),
  KEY `idDireccion_idx` (`idDireccion`),
  CONSTRAINT `fk_idDireccion` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`),
  CONSTRAINT `fk_Renta_Cliente1` FOREIGN KEY (`Cliente_idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renta`
--

LOCK TABLES `renta` WRITE;
/*!40000 ALTER TABLE `renta` DISABLE KEYS */;
/*!40000 ALTER TABLE `renta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipoitem`
--

DROP TABLE IF EXISTS `tipoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoitem` (
  `idTipoItem` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idTipoItem`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipoitem`
--

LOCK TABLES `tipoitem` WRITE;
/*!40000 ALTER TABLE `tipoitem` DISABLE KEYS */;
INSERT INTO `tipoitem` VALUES (1,'Inflable'),(2,'Trampolín'),(3,'Tablón');
/*!40000 ALTER TABLE `tipoitem` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-05 12:52:24
