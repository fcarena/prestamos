CREATE SCHEMA IF NOT EXISTS `bdprestamos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `bdprestamos` ;

-- -----------------------------------------------------
-- Table `bdprestamos`.`CLIENTE`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`CLIENTE` (
  `idCliente` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NOT NULL ,
  `apellidoPaterno` VARCHAR(45) NOT NULL ,
  `apellidoMaterno` VARCHAR(45) NOT NULL ,
  `dni` VARCHAR(45) NOT NULL ,
  `telefono` VARCHAR(10) NOT NULL ,
  `telefono2` VARCHAR(10) NULL ,
  `direccion` VARCHAR(45) NOT NULL ,
  `sexo` VARCHAR(10) NOT NULL ,
  `fechaNacimiento` DATE NOT NULL ,
  PRIMARY KEY (`idCliente`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bdprestamos`.`USUARIO`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`USUARIO` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(45) NOT NULL ,
  `apellido` VARCHAR(45) NOT NULL ,
  `alias` VARCHAR(45) NOT NULL ,
  `contraseña` VARCHAR(45) NOT NULL ,
  `perfil` VARCHAR(45) NOT NULL ,
  `descripcion` VARCHAR(45) NULL ,
  PRIMARY KEY (`idUsuario`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bdprestamos`.`EMPRESA`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`EMPRESA` (
  `idEmpresa` INT NOT NULL AUTO_INCREMENT ,
  `ruc` VARCHAR(45) NULL ,
  `nombreEmpresa` VARCHAR(45) NOT NULL ,
  `propietario` VARCHAR(45) NOT NULL ,
  `direccion` VARCHAR(45) NULL ,
  `rutaLogo` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NOT NULL ,
  `telefono` VARCHAR(10) NULL ,
  PRIMARY KEY (`idEmpresa`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bdprestamos`.`PRESTAMO`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`PRESTAMO` (
  `idprestamo` INT NOT NULL AUTO_INCREMENT ,
  `montoAcordado` DECIMAL(18,2) NOT NULL ,
  `fechaInicial` DATE NOT NULL ,
  `frecuenciaPago` VARCHAR(10) NOT NULL ,
  `numeroCuotas` TINYINT NOT NULL ,
  `fechaFinal` DATE NOT NULL ,
  `interes` DECIMAL(4,2) NOT NULL ,
  `estado` TINYINT(1) NULL DEFAULT false ,
  `CLIENTE_idCliente` INT NOT NULL ,
  PRIMARY KEY (`idprestamo`, `CLIENTE_idCliente`) ,
  INDEX `fk_PRESTAMO_CLIENTE1_idx` (`CLIENTE_idCliente` ASC) ,
  CONSTRAINT `fk_prestamo_cliente`
    FOREIGN KEY (`CLIENTE_idCliente` )
    REFERENCES `bdprestamos`.`CLIENTE` (`idCliente` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bdprestamos`.`CUOTAS`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`CUOTAS` (
  `idCuotas` INT  NOT NULL AUTO_INCREMENT ,
  `fechaPago` DATE NOT NULL ,
  `montoPagar` DECIMAL(18,2) NOT NULL ,
  `estado` VARCHAR(45) NOT NULL ,
  `mora` DECIMAL(3,2) NULL ,
  `PRESTAMO_idprestamo` INT NOT NULL ,
  PRIMARY KEY (`idCuotas`, `PRESTAMO_idprestamo`) ,
  INDEX `fk_CUOTAS_PRESTAMO1_idx` (`PRESTAMO_idprestamo` ASC) ,
  CONSTRAINT `fk_CUOTAS_PRESTAMO1`
    FOREIGN KEY (`PRESTAMO_idprestamo` )
    REFERENCES `bdprestamos`.`PRESTAMO` (`idprestamo` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bdprestamos`.`PAGO_CUOTA`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bdprestamos`.`PAGO_CUOTA` (
  `idPagoCuota` INT NOT NULL AUTO_INCREMENT ,
  `fecha` DATE NOT NULL ,
  `montoPagado` DECIMAL(18,2) NOT NULL ,
  `descripcion` VARCHAR(100) NULL ,
  `CUOTAS_idCuotas` INT NOT NULL ,
  `CUOTAS_PRESTAMO_idprestamo` INT NOT NULL ,
  `CLIENTE_idCliente` INT NOT NULL ,

  PRIMARY KEY (`idPagoCuota`, `CUOTAS_idCuotas`, `CUOTAS_PRESTAMO_idprestamo`, `CLIENTE_idCliente`) ,

  INDEX `fk_PAGO_CUOTA_CUOTAS1_idx` (`CUOTAS_idCuotas` ASC, `CUOTAS_PRESTAMO_idprestamo` ASC) ,

  INDEX `fk_PAGO_CUOTA_CLIENTE1_idx` (`CLIENTE_idCliente` ASC) ,

  CONSTRAINT `fk_PAGO_CUOTA_CUOTAS1`
    FOREIGN KEY (`CUOTAS_idCuotas` , `CUOTAS_PRESTAMO_idprestamo` )
    REFERENCES `bdprestamos`.`CUOTAS` (`idCuotas` , `PRESTAMO_idprestamo` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,

  CONSTRAINT `fk_PAGO_CUOTA_CLIENTE1`
    FOREIGN KEY (`CLIENTE_idCliente` )
    REFERENCES `bdprestamos`.`CLIENTE` (`idCliente` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

USE `bdprestamos` ;



---- VER TODOS LOS CONSTRAINT ----
select *
from information_schema.table_constraints
where constraint_schema = 'BDPRESTAMOS'
----------------------
ALTER TABLE `CUOTAS`
DROP FOREIGN KEY `fk_PAGO_CUOTA_CUOTAS1`;
ALTER TABLE `prestamo`
ADD CONSTRAINT `fk_prestamo_cliente`
    FOREIGN KEY (`CLIENTE_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE CASCADE;
-------ALTERAR CONSTRAINTS--------
--CONSTRAINT CUOTAS CON PRESTAMO
ALTER TABLE `CUOTAS`
ADD CONSTRAINT `fk_cuotas_prestamo`
    FOREIGN KEY (`PRESTAMO_idprestamo`) REFERENCES `prestamo` (`idprestamo`) ON DELETE RESTRICT ON UPDATE RESTRICT;
-------------------
