-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 19, 2023 at 03:07 PM
-- Server version: 5.7.31
-- PHP Version: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `ActualizarFechaActualizacionVendedores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarFechaActualizacionVendedores` ()  BEGIN
    UPDATE VENDEDORES
    SET FECHA_DE_ACTUALIZACION = CURDATE(); -- CURDATE() obtiene la fecha actual   
    -- Puedes agregar más lógica aquí si es necesario
END$$

DROP PROCEDURE IF EXISTS `ReporteValorFacturas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ReporteValorFacturas` ()  BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE factura_id INT;
    DECLARE factura_valor DECIMAL(10, 2);
    
    -- Definir un cursor para seleccionar las facturas
    DECLARE cur CURSOR FOR
        SELECT ID
        FROM FACTURAS;
    
    -- Declarar un handler para manejar el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    -- Iniciar el cursor
    OPEN cur;
    
    -- Iniciar un loop para recorrer las facturas
    factura_loop: LOOP
        -- Leer los valores de la factura
        FETCH cur INTO factura_id;
        
        -- Salir del loop cuando no haya más registros
        IF done = 1 THEN
            LEAVE factura_loop;
        END IF;
        
        -- Calcular el valor de la factura a partir de los detalles del pedido
        SELECT SUM(pd.PRECIO * pd.CANTIDAD) INTO factura_valor
        FROM PRODUCTO_ORDEN pd
        WHERE pd.ID_ORDEN = factura_id;
        
        -- Mostrar el resultado
        SELECT CONCAT('Factura ID: ', factura_id, ', Valor: ', factura_valor) AS Reporte;
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE cur;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `IDENTIFICACION` varchar(20) NOT NULL,
  `NOMBRES` varchar(100) NOT NULL,
  `CIUDAD_DE_RESIDENCIA` varchar(50) DEFAULT NULL,
  `DIRECCION` varchar(150) DEFAULT NULL,
  `FECHA_DE_NACIMIENTO` date DEFAULT NULL,
  `TELEFONO` varchar(20) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `FECHA_DE_ACTUALIZACION` date DEFAULT NULL,
  PRIMARY KEY (`IDENTIFICACION`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `clientes`
--

INSERT INTO `clientes` (`IDENTIFICACION`, `NOMBRES`, `CIUDAD_DE_RESIDENCIA`, `DIRECCION`, `FECHA_DE_NACIMIENTO`, `TELEFONO`, `EMAIL`, `FECHA_DE_ACTUALIZACION`) VALUES
('123456789', 'Juan Pérez', 'Bogotá', 'Calle 123', '1990-05-15', '+123456789', 'juan@example.com', '2023-09-16'),
('987654321', 'María López', 'Medellín', 'Av. Principal', '1985-08-22', '+987654321', 'maria@example.com', '2023-09-16'),
('567890123', 'Carlos Sánchez', 'Cali', 'Calle 456', '1995-02-10', '+567890123', 'carlos@example.com', '2023-09-16'),
('345678901', 'Ana Martínez', 'Barranquilla', 'Cra. 789', '1988-11-30', '+345678901', 'ana@example.com', '2023-09-16'),
('789012345', 'Luis Rodríguez', 'Cartagena', 'Av. Costera', '1983-04-05', '+789012345', 'luis@example.com', '2023-09-16');

-- --------------------------------------------------------

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
CREATE TABLE IF NOT EXISTS `facturas` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_VENDEDOR` int(11) NOT NULL,
  `ID_CLIENTE` varchar(20) NOT NULL,
  `ID_ORDEN` int(11) NOT NULL,
  `ESTADO` varchar(50) DEFAULT NULL,
  `FECHA` date DEFAULT NULL,
  `VALOR` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID_VENDEDOR` (`ID_VENDEDOR`),
  KEY `ID_CLIENTE` (`ID_CLIENTE`),
  KEY `ID_ORDEN` (`ID_ORDEN`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `facturas`
--

INSERT INTO `facturas` (`ID`, `ID_VENDEDOR`, `ID_CLIENTE`, `ID_ORDEN`, `ESTADO`, `FECHA`, `VALOR`) VALUES
(1, 1, '123456789', 1, 'Pagada', '2023-09-18', '449.97'),
(2, 2, '987654321', 2, 'Pendiente', '2023-09-18', '750.00'),
(3, 3, '567890123', 3, 'Pagada', '2023-09-17', '1200.00'),
(4, 4, '345678901', 4, 'Pendiente', '2023-09-16', '900.00'),
(5, 5, '789012345', 5, 'Pagada', '2023-09-15', '600.00');

-- --------------------------------------------------------

--
-- Table structure for table `ordenes`
--

DROP TABLE IF EXISTS `ordenes`;
CREATE TABLE IF NOT EXISTS `ordenes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CLIENTE` varchar(20) NOT NULL,
  `VENDEDOR` int(11) NOT NULL,
  `FECHA_PEDIDO` date DEFAULT NULL,
  `ESTADO` varchar(50) DEFAULT NULL,
  `VALOR` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `CLIENTE` (`CLIENTE`),
  KEY `VENDEDOR` (`VENDEDOR`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ordenes`
--

INSERT INTO `ordenes` (`ID`, `CLIENTE`, `VENDEDOR`, `FECHA_PEDIDO`, `ESTADO`, `VALOR`) VALUES
(1, '123456789', 1, '2023-09-18', 'En Proceso', '500.00'),
(2, '987654321', 2, '2023-09-18', 'En Proceso', '750.00'),
(3, '567890123', 3, '2023-09-17', 'Entregada', '1200.00'),
(4, '345678901', 4, '2023-09-16', 'En Proceso', '900.00'),
(5, '789012345', 5, '2023-09-15', 'Entregada', '600.00');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordenesporvendedor`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `ordenesporvendedor`;
CREATE TABLE IF NOT EXISTS `ordenesporvendedor` (
`CodigoVendedor` int(11)
,`NombreVendedor` varchar(100)
,`NumeroOrden` int(11)
,`ValorOrden` decimal(10,2)
,`FechaPedido` date
);

-- --------------------------------------------------------

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
CREATE TABLE IF NOT EXISTS `productos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NOMBRE` varchar(100) NOT NULL,
  `CATEGORIA` varchar(50) DEFAULT NULL,
  `EXISTENCIA` int(11) DEFAULT NULL,
  `PRECIO` decimal(10,2) DEFAULT NULL,
  `FECHA_DE_ACTUALIZACION` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `productos`
--

INSERT INTO `productos` (`ID`, `NOMBRE`, `CATEGORIA`, `EXISTENCIA`, `PRECIO`, `FECHA_DE_ACTUALIZACION`) VALUES
(1, 'Producto 1', 'Electrónica', 50, '199.99', '2023-09-16'),
(2, 'Producto 2', 'Ropa', 30, '49.99', '2023-09-16'),
(3, 'Producto 3', 'Hogar', 100, '29.99', '2023-09-16'),
(4, 'Producto 4', 'Electrónica', 20, '299.99', '2023-09-16'),
(5, 'Producto 5', 'Ropa', 40, '39.99', '2023-09-16');

--
-- Triggers `productos`
--
DROP TRIGGER IF EXISTS `before_insert_producto`;
DELIMITER $$
CREATE TRIGGER `before_insert_producto` BEFORE INSERT ON `productos` FOR EACH ROW BEGIN
    DECLARE descripcion_existente INT;
    
    -- Verificar si la descripción ya existe en la tabla
    SELECT COUNT(*) INTO descripcion_existente
    FROM PRODUCTOS
    WHERE NOMBRE = NEW.NOMBRE;
    
    -- Si existe, emitir un mensaje de error y cancelar la inserción
    IF descripcion_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La descripción ya existe en la tabla PRODUCTOS.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `producto_orden`
--

DROP TABLE IF EXISTS `producto_orden`;
CREATE TABLE IF NOT EXISTS `producto_orden` (
  `ID_ORDEN` int(11) NOT NULL,
  `ID_PRODUCTO` int(11) NOT NULL,
  `CANTIDAD` int(11) DEFAULT NULL,
  `PRECIO` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID_ORDEN`,`ID_PRODUCTO`),
  KEY `ID_PRODUCTO` (`ID_PRODUCTO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `producto_orden`
--

INSERT INTO `producto_orden` (`ID_ORDEN`, `ID_PRODUCTO`, `CANTIDAD`, `PRECIO`) VALUES
(1, 1, 2, '399.98'),
(1, 2, 1, '49.99'),
(2, 3, 3, '899.97'),
(3, 4, 4, '1196.00'),
(4, 5, 2, '11.98');

-- --------------------------------------------------------

--
-- Table structure for table `vendedores`
--

DROP TABLE IF EXISTS `vendedores`;
CREATE TABLE IF NOT EXISTS `vendedores` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NOMBRE` varchar(100) NOT NULL,
  `DIRECCION` varchar(150) DEFAULT NULL,
  `FECHA_DE_NACIMIENTO` date DEFAULT NULL,
  `SUELDO` decimal(10,2) DEFAULT NULL,
  `TELEFONO` varchar(20) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `FECHA_DE_ACTUALIZACION` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vendedores`
--

INSERT INTO `vendedores` (`ID`, `NOMBRE`, `DIRECCION`, `FECHA_DE_NACIMIENTO`, `SUELDO`, `TELEFONO`, `EMAIL`, `FECHA_DE_ACTUALIZACION`) VALUES
(1, 'Vendedor 1', 'Calle de los Vendedores', '1980-01-20', '2500.00', '+111111111', 'vendedor1@example.com', '2023-09-19'),
(2, 'Vendedor 2', 'Avenida de Ventas', '1975-06-12', '2800.00', '+222222222', 'vendedor2@example.com', '2023-09-19'),
(3, 'Vendedora 3', 'Paseo de los Vendedores', '1992-09-08', '2200.00', '+333333333', 'vendedora3@example.com', '2023-09-19'),
(4, 'Vendedor 4', 'Carrera de Ventas', '1988-03-15', '2600.00', '+444444444', 'vendedor4@example.com', '2023-09-19'),
(5, 'Vendedora 5', 'Avenida de las Ventas', '1995-12-10', '2300.00', '+555555555', 'vendedora5@example.com', '2023-09-19');

-- --------------------------------------------------------

--
-- Structure for view `ordenesporvendedor`
--
DROP TABLE IF EXISTS `ordenesporvendedor`;

DROP VIEW IF EXISTS `ordenesporvendedor`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordenesporvendedor`  AS  select `v`.`ID` AS `CodigoVendedor`,`v`.`NOMBRE` AS `NombreVendedor`,`o`.`ID` AS `NumeroOrden`,`o`.`VALOR` AS `ValorOrden`,`o`.`FECHA_PEDIDO` AS `FechaPedido` from (`vendedores` `v` join `ordenes` `o` on((`v`.`ID` = `o`.`VENDEDOR`))) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
