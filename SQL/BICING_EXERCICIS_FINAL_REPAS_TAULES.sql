-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET GLOBAL event_scheduler=ON ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bicing_prac
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bicing_prac` ;

-- -----------------------------------------------------
-- Schema bicing_prac
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bicing_prac` DEFAULT CHARACTER SET utf8 ;
USE `bicing_prac` ;

-- -----------------------------------------------------
-- Table `bicing_prac`.`estacio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`estacio` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`estacio` (
  `idESTACIO` INT(11) NOT NULL AUTO_INCREMENT,
  `ubicacio` VARCHAR(45) NULL,
  `num_docksBicing` INT(10) UNSIGNED NULL,
  `docks_lliures` INT(10) UNSIGNED NULL,
  `carregador` TINYINT(4) NULL DEFAULT 0,
  PRIMARY KEY (`idESTACIO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`bicicleta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`bicicleta` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`bicicleta` (
  `idBICICLETA` INT(11) NOT NULL AUTO_INCREMENT,
  `electrica` TINYINT(4) NULL DEFAULT 0,
  `batt_lvl` DECIMAL(3,0) UNSIGNED NULL DEFAULT NULL,
  `incident_acumulats` INT(11) NULL DEFAULT 0,
  `data_ultim_manteniment` DATE NULL DEFAULT now(),
  `ESTACIO_idESTACIO` INT(11) NULL,
  PRIMARY KEY (`idBICICLETA`, `ESTACIO_idESTACIO`),
  INDEX `fk_BICICLETA_ESTACIO1_idx` (`ESTACIO_idESTACIO` ASC) ,
  CONSTRAINT `fk_BICICLETA_ESTACIO1`
    FOREIGN KEY (`ESTACIO_idESTACIO`)
    REFERENCES `bicing_prac`.`estacio` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`dock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`dock` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`dock` (
  `idDock` INT(11) NOT NULL AUTO_INCREMENT,
  `ESTACIO_idESTACIO` INT(11) NOT NULL,
  `bicicleta_idBICICLETA` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`idDock`),
  INDEX `fk_DOCK_ESTACIO_idx` (`ESTACIO_idESTACIO` ASC) ,
  INDEX `fk_DOCK_BICICLETA_idx` (`bicicleta_idBICICLETA` ASC) ,
  CONSTRAINT `fk_DOCK_BICICLETA`
    FOREIGN KEY (`bicicleta_idBICICLETA`)
    REFERENCES `bicing_prac`.`bicicleta` (`idBICICLETA`),
  CONSTRAINT `fk_DOCK_ESTACIO`
    FOREIGN KEY (`ESTACIO_idESTACIO`)
    REFERENCES `bicing_prac`.`estacio` (`idESTACIO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`tipus_subscripcions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`tipus_subscripcions` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`tipus_subscripcions` (
  `idSUBSCRIPCIONS` INT(11) NOT NULL AUTO_INCREMENT,
  `nom_de_plan` VARCHAR(45) NOT NULL,
  `precio_anual` DECIMAL(8,3) NOT NULL,
  `precio_por_MEDIA_hora` DECIMAL(8,3) NOT NULL,
  `precio_hora_extra` DECIMAL(8,3) NOT NULL,
  `TIEMPO_GRATIS` INT(11) NOT NULL,
  PRIMARY KEY (`idSUBSCRIPCIONS`),
  UNIQUE INDEX `nom_de_plan` (`nom_de_plan` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`usuari`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`usuari` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`usuari` (
  `idUSUARI` INT(11) NOT NULL AUTO_INCREMENT,
  `Nom` VARCHAR(25) NULL,
  `Cognoms` VARCHAR(125) NULL,
  `DNI` VARCHAR(9) NULL,
  `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` INT(11) NULL,
  PRIMARY KEY (`idUSUARI`),
  INDEX `fk_USUARI_tipus_SUBSCRIPCIONS_idx` (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` ASC) ,
  CONSTRAINT `fk_USUARI_tipus_SUBSCRIPCIONS`
    FOREIGN KEY (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`)
    REFERENCES `bicing_prac`.`tipus_subscripcions` (`idSUBSCRIPCIONS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`facturacio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`facturacio` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`facturacio` (
  `id_factura` INT(11) NOT NULL AUTO_INCREMENT,
  `id_user` INT(11) NULL,
  `temps` TIME NULL,
  `preu` DECIMAL(11,3) NULL DEFAULT NULL,
  `subcripcio` INT(11) NULL DEFAULT NULL,
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


-- -----------------------------------------------------
-- Table `bicing_prac`.`trajecte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`trajecte` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`trajecte` (
  `idTRAJECTE` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Hora_inici` DATETIME NOT NULL,
  `Hora_final` DATETIME NULL DEFAULT NULL,
  `dock_final_lliure` TINYINT(4) NULL DEFAULT 1,
  `id_EST_origen` INT(11) NOT NULL,
  `id_EST_fin` INT(11) NULL,
  `BICICLETA_idBICICLETA` INT(11) NOT NULL,
  `USUARI_idUSUARI` INT(11) NOT NULL,
  PRIMARY KEY (`idTRAJECTE`),
  INDEX `fk_TRAJECTE_ESTACIO1_idx` (`id_EST_origen` ASC) ,
  INDEX `fk_TRAJECTE_ESTACIO2_idx` (`id_EST_fin` ASC) ,
  INDEX `fk_TRAJECTE_USUARI1_idx` (`USUARI_idUSUARI` ASC) ,
  CONSTRAINT `fk_TRAJECTE_ESTACIO1`
    FOREIGN KEY (`id_EST_origen`)
    REFERENCES `bicing_prac`.`estacio` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRAJECTE_ESTACIO2`
    FOREIGN KEY (`id_EST_fin`)
    REFERENCES `bicing_prac`.`estacio` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRAJECTE_USUARI1`
    FOREIGN KEY (`USUARI_idUSUARI`)
    REFERENCES `bicing_prac`.`usuari` (`idUSUARI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bicing_prac`.`incident_feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bicing_prac`.`incident_feedback` ;

CREATE TABLE IF NOT EXISTS `bicing_prac`.`incident_feedback` (
  `idINCIDENT` INT(11) NOT NULL AUTO_INCREMENT,
  `roda` TINYINT(4) NOT NULL DEFAULT 0 COMMENT 'esata',
  `frens` TINYINT(4) NOT NULL DEFAULT 0,
  `bateria_baixa` TINYINT(4) NOT NULL DEFAULT 0,
  `manillar` TINYINT(4) NOT NULL DEFAULT 0,
  `sillin` TINYINT(4) NOT NULL DEFAULT 0,
  `TRAJECTE_BICICLETA_ESTACIO_idESTACIO` INT(11) NOT NULL,
  `trajecte_idTRAJECTE` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`idINCIDENT`, `TRAJECTE_BICICLETA_ESTACIO_idESTACIO`, `trajecte_idTRAJECTE`),
  INDEX `fk_incident_feedback_trajecte1_idx` (`trajecte_idTRAJECTE` ASC) ,
  CONSTRAINT `fk_incident_feedback_trajecte1`
    FOREIGN KEY (`trajecte_idTRAJECTE`)
    REFERENCES `bicing_prac`.`trajecte` (`idTRAJECTE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
