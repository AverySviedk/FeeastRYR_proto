CREATE DATABASE  IF NOT EXISTS `feeast` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `feeast`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: feeast
-- ------------------------------------------------------
-- Server version	8.0.35

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
  `username` varchar(50) DEFAULT NULL,
  `nombreCliente` varchar(300) DEFAULT NULL,
  `CURP` char(18) DEFAULT NULL,
  `correo` varchar(300) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `fechaRegistro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `clt_nombre_usuario_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'admin','admincato','','admincato@gmail.com','j','2024-12-06 19:02:09'),(2,'shiro','Shiroi Konig','572847284858285928','shirok@gmail.com','s','2024-12-06 19:04:40'),(3,'raziek','Raziek Djevel','666666661111111111','shirok@gmail.com','s','2024-12-06 19:04:40'),(4,'marietta','Malie Decart','777777777777777777','marietd@gmail.com','m','2024-12-06 19:04:40'),(5,'doby','Dobereiner Stanislav','EEE8472848DDDDD9FF','dobys@gmail.com','d','2024-12-06 19:04:40'),(6,'lawliett','Laurel Taylor','IEJFYRHDJFIXKFHDJQ','lavenderc@gmail.com','l','2024-12-07 02:26:22'),(8,'harleyk','Harley Alvastar','2374JTGYF6EJ47FU83','hvstar@gmail.com','k','2024-12-07 12:55:19'),(15,'near','Nyarlatoteph','AAAAAAAAAAAAAAAAAA','ntht@gmail.com','N','2024-12-07 13:23:57'),(16,'','','','','','2024-12-08 03:28:46');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_cliente`
--

DROP TABLE IF EXISTS `dir_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dir_cliente` (
  `idCliente` int NOT NULL,
  `idDireccion` int NOT NULL,
  PRIMARY KEY (`idCliente`,`idDireccion`),
  KEY `idDireccion` (`idDireccion`),
  CONSTRAINT `dir_cliente_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `dir_cliente_ibfk_2` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_cliente`
--

LOCK TABLES `dir_cliente` WRITE;
/*!40000 ALTER TABLE `dir_cliente` DISABLE KEYS */;
INSERT INTO `dir_cliente` VALUES (1,11),(4,12),(2,13),(2,14),(3,15),(2,17),(2,20),(2,21);
/*!40000 ALTER TABLE `dir_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direccion`
--

DROP TABLE IF EXISTS `direccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direccion` (
  `idDireccion` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(512) DEFAULT NULL,
  `ciudad` varchar(200) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `codigoPostal` char(5) DEFAULT NULL,
  PRIMARY KEY (`idDireccion`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
INSERT INTO `direccion` VALUES (11,'Agrupamiento J # 40','Ciudad de México','CDMX','07980'),(12,'47B','Ciudad de México','CDMX','48592'),(13,'E33','Nezahualcoyotl','EdoMex','48573'),(14,'2','Naucalpan','EdoMex','42473'),(15,'25','Ecatepec','EdoMex','22455'),(17,'lorem','Ipsum','exampli','13232'),(18,'Linares 74. Sta Maria la Rivera','Ciudad de México','CDMX','26374'),(19,'Jacobino 17  Col Narvarte','Ciudad de México','CDMX','28475'),(20,'Hamburgo 117  Col. Juarez','Ciudad de México','CDMX','06600'),(21,'Maria Magdalena 12,, Coyoacan','Ciudad de México','CDMX','23453');
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
  `nombreItem` varchar(80) DEFAULT NULL,
  `ancho` float DEFAULT NULL,
  `alto` float DEFAULT NULL,
  `largo` float DEFAULT NULL,
  `precio` decimal(10,0) DEFAULT NULL,
  `cantidadDisponible` int DEFAULT NULL,
  `cantidadTotal` int DEFAULT NULL,
  `idTipo` int NOT NULL,
  PRIMARY KEY (`idItem`),
  KEY `fk_Item_Tipo_item1_idx` (`idTipo`),
  CONSTRAINT `fk_Item_Tipo_item1` FOREIGN KEY (`idTipo`) REFERENCES `tipoitem` (`idTipoItem`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'silla negra plegable',35,150,35,12,22,30,1),(2,'silla blanca no plegable',35,120,40,10,30,30,1),(5,'Sonidero',NULL,NULL,NULL,7877,7,7,6),(7,'lamina',78,78,7,8,9,8,8),(9,'vaso transparente fluor',NULL,NULL,NULL,3,700,1400,4),(10,'gorrito cono papel',NULL,NULL,NULL,6,70,70,11),(11,'azul mate con rayas blancas',NULL,NULL,NULL,20,15,20,2);
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_renta`
--

DROP TABLE IF EXISTS `item_renta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_renta` (
  `idItemRenta` int NOT NULL AUTO_INCREMENT,
  `idRenta` int NOT NULL,
  `idItem` int NOT NULL,
  `cantItem` int DEFAULT NULL,
  `idTipoItemRenta` int NOT NULL,
  PRIMARY KEY (`idItemRenta`),
  UNIQUE KEY `cItemRenta` (`idRenta`,`idItem`),
  KEY `fk_Item_renta_Renta1_idx` (`idRenta`),
  KEY `fk_Item_renta_Item1_idx` (`idItem`),
  KEY `fk_Item_renta_Tipo_item_renta1_idx` (`idTipoItemRenta`),
  CONSTRAINT `fk_Item_renta_Item1` FOREIGN KEY (`idItem`) REFERENCES `item` (`idItem`),
  CONSTRAINT `fk_Item_renta_Renta1` FOREIGN KEY (`idRenta`) REFERENCES `renta` (`idRenta`),
  CONSTRAINT `fk_Item_renta_Tipo_item_renta1` FOREIGN KEY (`idTipoItemRenta`) REFERENCES `tipo_item_renta` (`idTipoItemRenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_renta`
--

LOCK TABLES `item_renta` WRITE;
/*!40000 ALTER TABLE `item_renta` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_renta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renta`
--

DROP TABLE IF EXISTS `renta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renta` (
  `idRenta` int NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `precio` decimal(10,0) DEFAULT NULL,
  `compensacion` decimal(10,0) DEFAULT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `comentario` varchar(250) DEFAULT NULL,
  `idDireccion` int NOT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`idRenta`),
  UNIQUE KEY `hora` (`hora`,`fecha`),
  KEY `fk_Renta_Direccion1_idx` (`idDireccion`),
  KEY `fk_Renta_Cliente2_idx` (`idCliente`),
  CONSTRAINT `fk_Renta_Cliente2` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `fk_Renta_Direccion1` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renta`
--

LOCK TABLES `renta` WRITE;
/*!40000 ALTER TABLE `renta` DISABLE KEYS */;
INSERT INTO `renta` VALUES (4,'2024-12-06','19:13:42',120,NULL,'Rechazado','veauvoir',12,4),(5,'2024-12-06','19:15:01',231,NULL,'Rechazado','dakaraimasu',14,2),(7,'2024-12-06','22:27:19',421,77,'Aceptado',NULL,13,3),(8,'2024-12-06','22:57:37',421,NULL,'Rechazado','',13,3),(9,'2024-12-07','08:00:00',423,NULL,'Terminado',NULL,13,3),(11,'2024-12-06','08:00:00',222,NULL,'Pendiente',NULL,15,5),(12,'2024-12-06','09:01:00',211,NULL,'Pendiente',NULL,13,5),(14,'2024-12-07','11:00:00',23,234,'Pendiente',NULL,11,5),(15,'2024-12-08','11:00:00',23,234,'Rechazado','Muy Lejano',11,5),(16,'2024-12-08','12:00:00',23,234,'Pendiente',NULL,11,5);
/*!40000 ALTER TABLE `renta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telefono`
--

DROP TABLE IF EXISTS `telefono`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telefono` (
  `idTelefono` int NOT NULL AUTO_INCREMENT,
  `numero` char(10) NOT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`idTelefono`),
  KEY `fk_Telefono_Cliente1_idx` (`idCliente`),
  CONSTRAINT `fk_Telefono_Cliente1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefono`
--

LOCK TABLES `telefono` WRITE;
/*!40000 ALTER TABLE `telefono` DISABLE KEYS */;
/*!40000 ALTER TABLE `telefono` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_item_renta`
--

DROP TABLE IF EXISTS `tipo_item_renta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_item_renta` (
  `idTipoItemRenta` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idTipoItemRenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_item_renta`
--

LOCK TABLES `tipo_item_renta` WRITE;
/*!40000 ALTER TABLE `tipo_item_renta` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipo_item_renta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipoitem`
--

DROP TABLE IF EXISTS `tipoitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoitem` (
  `idTipoItem` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`idTipoItem`),
  UNIQUE KEY `uniqNombreTipo` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipoitem`
--

LOCK TABLES `tipoitem` WRITE;
/*!40000 ALTER TABLE `tipoitem` DISABLE KEYS */;
INSERT INTO `tipoitem` VALUES (11,'accesorios'),(9,'alimento'),(5,'inflable'),(7,'juego'),(8,'lonas'),(15,'luces'),(2,'mantel'),(3,'mesa'),(1,'silla'),(6,'sonido'),(4,'vaso');
/*!40000 ALTER TABLE `tipoitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'feeast'
--

--
-- Dumping routines for database 'feeast'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-08 14:14:53
