SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BICING_PRAC
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BICING_PRAC
-- -----------------------------------------------------
-- DROP SCHEMA IF EXISTS `Bicing_prac`;
CREATE SCHEMA IF NOT EXISTS `BICING_PRAC` DEFAULT CHARACTER SET utf8 ;
USE `BICING_PRAC` ;

-- -----------------------------------------------------
-- Table `BICING_PRAC`.`tipus_SUBSCRIPCIONS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`tipus_SUBSCRIPCIONS` (
  `idSUBSCRIPCIONS` INT NOT NULL AUTO_INCREMENT,
  `nom_de_plan` VARCHAR(45) NOT NULL,
  `precio_anual` DECIMAL(6,2) DEFAULT NULL,
  `precio_por_MEDIA_hora` DECIMAL(5,2) DEFAULT NULL,
  `precio_hora_extra` DECIMAL(5,2) NULL,
  `TIEMPO_GRATIS` INT DEFAULT NULL,
  PRIMARY KEY (`idSUBSCRIPCIONS`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BICING_PRAC`.`USUARI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`USUARI` (
  `idUSUARI` INT NOT NULL AUTO_INCREMENT,
  `Nom` VARCHAR(25) NULL,
  `Cognoms` VARCHAR(125) NULL,
  `DNI` VARCHAR(9) UNIQUE,
  `tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS` INT NOT NULL,
  PRIMARY KEY (`idUSUARI`),
  INDEX `fk_USUARI_tipus_SUBSCRIPCIONS_idx` (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`), 
  CONSTRAINT `fk_USUARI_tipus_SUBSCRIPCIONS`
    FOREIGN KEY (`tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS`)
    REFERENCES `BICING_PRAC`.`tipus_SUBSCRIPCIONS` (`idSUBSCRIPCIONS`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BICING_PRAC`.`ESTACIO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`ESTACIO` (
  `idESTACIO` INT AUTO_INCREMENT NOT NULL,
  `ubicacio` VARCHAR(45) NOT NULL,
  `num_docksBicing` INT UNSIGNED NOT NULL,
  `docks_lliures` INT UNSIGNED NOT NULL,
  `carregador` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idESTACIO`))
ENGINE = InnoDB;

-- --------------------------------------------------------- 
-- DOCK: taula per saber els docks lliures de les estacions. 
-- --------------------------------------------------------- 
CREATE TABLE IF NOT EXISTS `DOCK` ( 
    `idDock` INT NOT NULL AUTO_INCREMENT, 
    `ESTACIO_idESTACIO` INT NOT NULL, 
    `bicicleta_idBICICLETA` INT NULL, 
    PRIMARY KEY (`idDock`),
    UNIQUE (`bicicleta_idBICICLETA`),
    INDEX `fk_DOCK_ESTACIO_idx` (`ESTACIO_idESTACIO`), 
    INDEX `fk_DOCK_BICICLETA_idx` (`bicicleta_idBICICLETA`),
    
CONSTRAINT `fk_DOCK_ESTACIO` 
    FOREIGN KEY (`ESTACIO_idESTACIO`) 
    REFERENCES `ESTACIO` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      
CONSTRAINT `fk_DOCK_BICICLETA` 
    FOREIGN KEY (`bicicleta_idBICICLETA`) 
    REFERENCES `BICICLETA` (`idBICICLETA`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;


-- -----------------------------------------------------
-- Table `BICING_PRAC`.`BICICLETA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`BICICLETA` (
  `idBICICLETA` INT NOT NULL AUTO_INCREMENT,
  `electrica` TINYINT NOT NULL DEFAULT 0,
  `batt_lvl` DECIMAL(3) UNSIGNED,
  `incident_acumulats` INT NOT NULL DEFAULT 0,
  `data_ultim_manteniment` DATE NOT NULL,
  `ESTACIO_idESTACIO` INT NOT NULL,
  PRIMARY KEY (`idBICICLETA`), 
  KEY `fk_BICICLETA_ESTACIO1_idx` (`ESTACIO_idESTACIO` ASC), 
  CONSTRAINT `fk_BICICLETA_ESTACIO1`
    FOREIGN KEY (`ESTACIO_idESTACIO`)
    REFERENCES `BICING_PRAC`.`ESTACIO` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BICING_PRAC`.`TRAJECTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`TRAJECTE` (
  `idTRAJECTE` INT NOT NULL AUTO_INCREMENT,
  `Hora_inici` DATETIME NOT NULL, 
  `Hora_final` DATETIME NULL,
  `dock_final_lliure` TINYINT DEFAULT 1,
  `id_EST_origen` INT NOT NULL,
  `id_EST_fin` INT DEFAULT NULL ,
  `BICICLETA_idBICICLETA` INT NOT NULL,
  -- `BICICLETA_ESTACIO_idESTACIO` INT NOT NULL,  Comentem aquesta línia per tenir una fk incoherent.
  `USUARI_idUSUARI` INT NOT NULL,
  PRIMARY KEY (`idTRAJECTE`),   -- `id_EST_origen`, `id_EST_fin`, `BICICLETA_idBICICLETA`, `BICICLETA_ESTACIO_idESTACIO`, `USUARI_idUSUARI`), Errors de disseny
  
  INDEX `fk_TRAJECTE_ESTACIO1_idx` (`id_EST_origen`), 
  INDEX `fk_TRAJECTE_ESTACIO2_idx` (`id_EST_fin`), 
  INDEX `fk_TRAJECTE_BICICLETA1_idx` (`BICICLETA_idBICICLETA`),   -- ASC, `BICICLETA_ESTACIO_idESTACIO` ASC), 
  INDEX `fk_TRAJECTE_USUARI1_idx` (`USUARI_idUSUARI` ASC),
  
  CONSTRAINT `fk_TRAJECTE_ESTACIO1`
    FOREIGN KEY (`id_EST_origen`)
    REFERENCES `BICING_PRAC`.`ESTACIO` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_TRAJECTE_ESTACIO2`
    FOREIGN KEY (`id_EST_fin`)
    REFERENCES `BICING_PRAC`.`ESTACIO` (`idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_TRAJECTE_BICICLETA1`
    FOREIGN KEY (`BICICLETA_idBICICLETA`)                     -- , `BICICLETA_ESTACIO_idESTACIO`)
    REFERENCES `BICING_PRAC`.`BICICLETA` (`idBICICLETA`)      -- , `ESTACIO_idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_TRAJECTE_USUARI1`
    FOREIGN KEY (`USUARI_idUSUARI`)
    REFERENCES `BICING_PRAC`.`USUARI` (`idUSUARI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BICING_PRAC`.`INCIDENT_feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BICING_PRAC`.`INCIDENT_feedback` (
  `idINCIDENT` INT NOT NULL AUTO_INCREMENT,
  `roda` TINYINT NOT NULL DEFAULT 0,
  `frens` TINYINT NOT NULL DEFAULT 0,
  `bateria_baixa` TINYINT NOT NULL DEFAULT 0,
  `manillar` TINYINT NOT NULL DEFAULT 0,
  `sillin` TINYINT NOT NULL DEFAULT 0,
  
  `TRAJECTE_idTRAJECTE` INT NOT NULL,
                                                                        -- `TRAJECTE_id_EST_origen` INT NOT NULL,
                                                                        -- `TRAJECTE_id_EST_fin` INT NOT NULL,
                                                                        -- `TRAJECTE_BICICLETA_idBICICLETA` INT NOT NULL,
                                                                        -- `TRAJECTE_BICICLETA_ESTACIO_idESTACIO` INT NOT NULL,
																		-- PRIMARY KEY (`idINCIDENT`, `TRAJECTE_idTRAJECTE`, `TRAJECTE_id_EST_origen`, `TRAJECTE_id_EST_fin`, `TRAJECTE_BICICLETA_idBICICLETA`, `TRAJECTE_BICICLETA_ESTACIO_idESTACIO`),

  PRIMARY KEY (`idINCIDENT`),                                            
    INDEX `fk_INCIDENT_feedback_TRAJECTE1_idx` (`TRAJECTE_idTRAJECTE`),  -- `TRAJECTE_id_EST_origen` ASC, `TRAJECTE_id_EST_fin` ASC, `TRAJECTE_BICICLETA_idBICICLETA` ASC, `TRAJECTE_BICICLETA_ESTACIO_idESTACIO` ASC),
  CONSTRAINT `fk_INCIDENT_feedback_TRAJECTE1`
    FOREIGN KEY (`TRAJECTE_idTRAJECTE`)                                  -- , `TRAJECTE_id_EST_origen` , `TRAJECTE_id_EST_fin` , `TRAJECTE_BICICLETA_idBICICLETA` , `TRAJECTE_BICICLETA_ESTACIO_idESTACIO`)
    REFERENCES `BICING_PRAC`.`TRAJECTE` (`idTRAJECTE`)                   -- , `id_EST_origen` , `id_EST_fin` , `BICICLETA_idBICICLETA` , `BICICLETA_ESTACIO_idESTACIO`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    )
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
