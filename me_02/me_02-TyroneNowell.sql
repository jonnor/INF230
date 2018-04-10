-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Yeyland_Wutani
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Yeyland_Wutani
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Yeyland_Wutani` DEFAULT CHARACTER SET utf8 ;
USE `Yeyland_Wutani` ;

-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`locations` (
  `locationcode` INT NOT NULL,
  `locationname` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NULL,
  UNIQUE INDEX `locID_UNIQUE` (`locationcode` ASC),
  PRIMARY KEY (`locationcode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`departments` (
  `depnum` INT NOT NULL,
  `depname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`depnum`),
  UNIQUE INDEX `dID_UNIQUE` (`depnum` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`positions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`positions` (
  `positioncode` INT NOT NULL,
  `positionname` VARCHAR(45) NOT NULL,
  `description` VARCHAR(90) NULL,
  `department_depnum` INT NOT NULL,
  PRIMARY KEY (`positioncode`),
  UNIQUE INDEX `pID_UNIQUE` (`positioncode` ASC),
  INDEX `fk_position_department1_idx` (`department_depnum` ASC),
  CONSTRAINT `fk_position_department1`
    FOREIGN KEY (`department_depnum`)
    REFERENCES `Yeyland_Wutani`.`departments` (`depnum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`employees` (
  `eID` INT NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `location_locationcode` INT NOT NULL,
  `positions_positioncode` INT NOT NULL,
  PRIMARY KEY (`eID`),
  UNIQUE INDEX `eID_UNIQUE` (`eID` ASC),
  INDEX `fk_employee_location1_idx` (`location_locationcode` ASC),
  INDEX `fk_employees_positions1_idx` (`positions_positioncode` ASC),
  CONSTRAINT `fk_employee_location1`
    FOREIGN KEY (`location_locationcode`)
    REFERENCES `Yeyland_Wutani`.`locations` (`locationcode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_employees_positions1`
    FOREIGN KEY (`positions_positioncode`)
    REFERENCES `Yeyland_Wutani`.`positions` (`positioncode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`courses` (
  `courseID` INT NOT NULL,
  `coursename` VARCHAR(45) NOT NULL,
  `description` VARCHAR(90) NULL,
  `location_locationcode` INT NOT NULL,
  PRIMARY KEY (`courseID`, `coursename`),
  UNIQUE INDEX `cID_UNIQUE` (`courseID` ASC),
  INDEX `fk_course_location1_idx` (`location_locationcode` ASC),
  CONSTRAINT `fk_course_location1`
    FOREIGN KEY (`location_locationcode`)
    REFERENCES `Yeyland_Wutani`.`locations` (`locationcode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`historic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`historic` (
  `event` INT NOT NULL,
  `date` DATE NOT NULL,
  `lecturer` VARCHAR(45) NULL,
  `employee_eID` INT NOT NULL,
  `courses_courseID` INT NOT NULL,
  `courses_coursename` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`event`),
  INDEX `fk_historic_employee1_idx` (`employee_eID` ASC),
  INDEX `fk_historic_courses1_idx` (`courses_courseID` ASC, `courses_coursename` ASC),
  CONSTRAINT `fk_historic_employee1`
    FOREIGN KEY (`employee_eID`)
    REFERENCES `Yeyland_Wutani`.`employees` (`eID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historic_courses1`
    FOREIGN KEY (`courses_courseID` , `courses_coursename`)
    REFERENCES `Yeyland_Wutani`.`courses` (`courseID` , `coursename`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`phonenums`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`phonenums` (
  `phonenum` VARCHAR(45) NULL,
  `employee_eID` INT NOT NULL,
  PRIMARY KEY (`employee_eID`),
  CONSTRAINT `fk_phone_employee1`
    FOREIGN KEY (`employee_eID`)
    REFERENCES `Yeyland_Wutani`.`employees` (`eID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Yeyland_Wutani`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Yeyland_Wutani`.`addresses` (
  `streetaddress` VARCHAR(45) NULL,
  `postalcode` VARCHAR(45) NULL,
  `employee_eID` INT NOT NULL,
  PRIMARY KEY (`employee_eID`),
  CONSTRAINT `fk_address_employee`
    FOREIGN KEY (`employee_eID`)
    REFERENCES `Yeyland_Wutani`.`employees` (`eID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

