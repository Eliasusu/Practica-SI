-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: guarderia_nautica
-- ------------------------------------------------------
-- Server version	8.0.38

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `academia`
--

DROP TABLE IF EXISTS `academia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academia` (
  `codActividad` int NOT NULL,
  `legajo` int NOT NULL,
  PRIMARY KEY (`codActividad`,`legajo`),
  KEY `legajo` (`legajo`),
  CONSTRAINT `academia_ibfk_1` FOREIGN KEY (`codActividad`) REFERENCES `actividades` (`codActividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `academia_ibfk_2` FOREIGN KEY (`legajo`) REFERENCES `instructores` (`legajo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academia`
--

/*!40000 ALTER TABLE `academia` DISABLE KEYS */;
/*!40000 ALTER TABLE `academia` ENABLE KEYS */;

--
-- Table structure for table `actividades`
--

DROP TABLE IF EXISTS `actividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividades` (
  `codActividad` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`codActividad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividades`
--

/*!40000 ALTER TABLE `actividades` DISABLE KEYS */;
/*!40000 ALTER TABLE `actividades` ENABLE KEYS */;

--
-- Table structure for table `actividades_tiposembarcaciones`
--

DROP TABLE IF EXISTS `actividades_tiposembarcaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividades_tiposembarcaciones` (
  `codActividad` int NOT NULL,
  `codEmbarcacion` int NOT NULL,
  PRIMARY KEY (`codActividad`,`codEmbarcacion`),
  KEY `codEmbarcacion` (`codEmbarcacion`),
  CONSTRAINT `actividades_tiposembarcaciones_ibfk_1` FOREIGN KEY (`codActividad`) REFERENCES `actividades` (`codActividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `actividades_tiposembarcaciones_ibfk_2` FOREIGN KEY (`codEmbarcacion`) REFERENCES `tipoembarcaciones` (`codEmbarcacion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividades_tiposembarcaciones`
--

/*!40000 ALTER TABLE `actividades_tiposembarcaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `actividades_tiposembarcaciones` ENABLE KEYS */;

--
-- Table structure for table `camas`
--

DROP TABLE IF EXISTS `camas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `camas` (
  `nroSecuencialCama` int NOT NULL AUTO_INCREMENT,
  `codSector` int NOT NULL,
  `estado` varchar(50) NOT NULL,
  PRIMARY KEY (`nroSecuencialCama`),
  KEY `codSector` (`codSector`),
  CONSTRAINT `camas_ibfk_1` FOREIGN KEY (`codSector`) REFERENCES `sectores` (`codSector`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `camas`
--

/*!40000 ALTER TABLE `camas` DISABLE KEYS */;
/*!40000 ALTER TABLE `camas` ENABLE KEYS */;

--
-- Table structure for table `camas_sectores`
--

DROP TABLE IF EXISTS `camas_sectores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `camas_sectores` (
  `nroSecuencialCama` int NOT NULL,
  `codSector` int NOT NULL,
  PRIMARY KEY (`nroSecuencialCama`,`codSector`),
  KEY `codSector` (`codSector`),
  CONSTRAINT `camas_sectores_ibfk_1` FOREIGN KEY (`nroSecuencialCama`) REFERENCES `camas` (`nroSecuencialCama`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `camas_sectores_ibfk_2` FOREIGN KEY (`codSector`) REFERENCES `sectores` (`codSector`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `camas_sectores`
--

/*!40000 ALTER TABLE `camas_sectores` DISABLE KEYS */;
/*!40000 ALTER TABLE `camas_sectores` ENABLE KEYS */;

--
-- Table structure for table `contratos`
--

DROP TABLE IF EXISTS `contratos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contratos` (
  `HIN` varchar(12) NOT NULL,
  `nroSecuencialCama` int NOT NULL,
  `vigente` tinyint(1) NOT NULL,
  `fechaInicioContrato` date NOT NULL,
  `fechaFinContrato` date DEFAULT NULL,
  PRIMARY KEY (`HIN`,`nroSecuencialCama`),
  KEY `nroSecuencialCama` (`nroSecuencialCama`),
  CONSTRAINT `contratos_ibfk_1` FOREIGN KEY (`HIN`) REFERENCES `embarcaciones` (`HIN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contratos_ibfk_2` FOREIGN KEY (`nroSecuencialCama`) REFERENCES `camas` (`nroSecuencialCama`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratos`
--

/*!40000 ALTER TABLE `contratos` DISABLE KEYS */;
/*!40000 ALTER TABLE `contratos` ENABLE KEYS */;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `codCurso` int NOT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFin` date NOT NULL,
  `cupo` int NOT NULL,
  `legajo` int NOT NULL,
  `codActividad` int NOT NULL,
  PRIMARY KEY (`codCurso`),
  KEY `legajo` (`legajo`),
  KEY `codActividad` (`codActividad`),
  CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`legajo`) REFERENCES `instructores` (`legajo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cursos_ibfk_2` FOREIGN KEY (`codActividad`) REFERENCES `actividades` (`codActividad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;

--
-- Table structure for table `embarcaciones`
--

DROP TABLE IF EXISTS `embarcaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `embarcaciones` (
  `HIN` varchar(12) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `nroDni` int NOT NULL,
  `codEmbarcacion` int NOT NULL,
  PRIMARY KEY (`HIN`),
  KEY `nroDni` (`nroDni`),
  KEY `codEmbarcacion` (`codEmbarcacion`),
  CONSTRAINT `embarcaciones_ibfk_1` FOREIGN KEY (`nroDni`) REFERENCES `personas` (`nroDni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `embarcaciones_ibfk_2` FOREIGN KEY (`nroDni`) REFERENCES `empresas` (`nroDni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `embarcaciones_ibfk_3` FOREIGN KEY (`codEmbarcacion`) REFERENCES `tipoembarcaciones` (`codEmbarcacion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `embarcaciones`
--

/*!40000 ALTER TABLE `embarcaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `embarcaciones` ENABLE KEYS */;

--
-- Table structure for table `embarcaciones_tiposembarcaciones`
--

DROP TABLE IF EXISTS `embarcaciones_tiposembarcaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `embarcaciones_tiposembarcaciones` (
  `HIN` varchar(10) NOT NULL,
  `codEmbarcacion` int NOT NULL,
  PRIMARY KEY (`HIN`,`codEmbarcacion`),
  KEY `codEmbarcacion` (`codEmbarcacion`),
  CONSTRAINT `embarcaciones_tiposembarcaciones_ibfk_1` FOREIGN KEY (`HIN`) REFERENCES `embarcaciones` (`HIN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `embarcaciones_tiposembarcaciones_ibfk_2` FOREIGN KEY (`codEmbarcacion`) REFERENCES `tipoembarcaciones` (`codEmbarcacion`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `embarcaciones_tiposembarcaciones`
--

/*!40000 ALTER TABLE `embarcaciones_tiposembarcaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `embarcaciones_tiposembarcaciones` ENABLE KEYS */;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `nroDni` int NOT NULL,
  `tipoDni` varchar(10) NOT NULL,
  `razonSocial` varchar(50) NOT NULL,
  PRIMARY KEY (`nroDni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios` (
  `diaSemana` varchar(10) NOT NULL,
  `horaInicio` time NOT NULL,
  `horaFin` time NOT NULL,
  `codCurso` int NOT NULL,
  PRIMARY KEY (`diaSemana`),
  KEY `codCurso` (`codCurso`),
  CONSTRAINT `horarios_ibfk_1` FOREIGN KEY (`codCurso`) REFERENCES `cursos` (`codCurso`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;

--
-- Table structure for table `inscripciones`
--

DROP TABLE IF EXISTS `inscripciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones` (
  `fechaHoraInscripcion` datetime NOT NULL,
  `codCurso` int NOT NULL,
  `nroDni` int NOT NULL,
  PRIMARY KEY (`fechaHoraInscripcion`,`codCurso`,`nroDni`),
  KEY `nroDni` (`nroDni`),
  KEY `codCurso` (`codCurso`),
  CONSTRAINT `inscripciones_ibfk_1` FOREIGN KEY (`nroDni`) REFERENCES `personas` (`nroDni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `inscripciones_ibfk_2` FOREIGN KEY (`nroDni`) REFERENCES `empresas` (`nroDni`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `inscripciones_ibfk_3` FOREIGN KEY (`codCurso`) REFERENCES `cursos` (`codCurso`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones`
--

/*!40000 ALTER TABLE `inscripciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripciones` ENABLE KEYS */;

--
-- Table structure for table `instructores`
--

DROP TABLE IF EXISTS `instructores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructores` (
  `legajo` int NOT NULL,
  `cuil` varchar(10) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `telefono` varchar(16) NOT NULL,
  PRIMARY KEY (`legajo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructores`
--

/*!40000 ALTER TABLE `instructores` DISABLE KEYS */;
/*!40000 ALTER TABLE `instructores` ENABLE KEYS */;

--
-- Table structure for table `personas`
--

DROP TABLE IF EXISTS `personas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personas` (
  `nroDni` int NOT NULL,
  `tipoDni` varchar(10) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  PRIMARY KEY (`nroDni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personas`
--

/*!40000 ALTER TABLE `personas` DISABLE KEYS */;
/*!40000 ALTER TABLE `personas` ENABLE KEYS */;

--
-- Table structure for table `sectores`
--

DROP TABLE IF EXISTS `sectores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sectores` (
  `codSector` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `capacidad` int NOT NULL,
  `tipoOperacion` varchar(50) NOT NULL,
  PRIMARY KEY (`codSector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectores`
--

/*!40000 ALTER TABLE `sectores` DISABLE KEYS */;
/*!40000 ALTER TABLE `sectores` ENABLE KEYS */;

--
-- Table structure for table `tipoembarcaciones`
--

DROP TABLE IF EXISTS `tipoembarcaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipoembarcaciones` (
  `codEmbarcacion` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `operacionAutomatica?` tinyint(1) NOT NULL,
  `codActividad` int NOT NULL,
  PRIMARY KEY (`codEmbarcacion`),
  KEY `codActividad` (`codActividad`),
  CONSTRAINT `tipoembarcaciones_ibfk_1` FOREIGN KEY (`codActividad`) REFERENCES `actividades` (`codActividad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipoembarcaciones`
--

/*!40000 ALTER TABLE `tipoembarcaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipoembarcaciones` ENABLE KEYS */;

--
-- Dumping routines for database 'guarderia_nautica'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-23 13:06:24
