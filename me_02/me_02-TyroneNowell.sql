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

USE yeyland_wutani;

INSERT INTO departments (depnum, depname) 
VALUES (1, 'Accounting');
INSERT INTO departments (depnum, depname) 
VALUES (2, 'Production');
INSERT INTO departments (depnum, depname) 
VALUES (3, 'Development');
INSERT INTO departments (depnum, depname) 
VALUES (4, 'Research');
INSERT INTO departments (depnum, depname) 
VALUES (5, 'Education');
INSERT INTO departments (depnum, depname) 
VALUES (6, 'Management');
INSERT INTO departments (depnum, depname) 
VALUES (7, 'IT');

INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES (1, 'President', 'Presides over minions', 6);
INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES (2, 'Manager', 'Managers minions', 6);
INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES (3, 'Professional', 'Nobody knows what they do', 3);
INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES (4, 'Accountant', 'Counts minions', 1);
INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES (5, 'Data Entry Specialist', 'The person doing all the work', 7);

INSERT INTO locations (locationcode, locationname, address) 
VALUES (1, 'Headquaters', '1000 Short Street');
INSERT INTO locations (locationcode, locationname) 
VALUES (2, 'Par-tea Shop');
INSERT INTO locations (locationcode, locationname) 
VALUES (3, 'Petting zoo');
INSERT INTO locations (locationcode, locationname) 
VALUES (4, 'IKEA');

INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (1, 'Hendriksen', 'Ola', 2, 1);
INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (2, 'Beeblebrox', 'Zaphod', 1, 1);
INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (3, 'Anderson', 'Thomas', 5, 1);
INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (4, 'Reno', 'Leon', 3, 4);
INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (5, 'Durden', 'Tyler', 2, 1);
INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (6, 'Larsen', 'Hanne', 4, 1);

INSERT INTO courses (courseID, coursename, description, location_locationcode) 
VALUES (1, 'Artisan soap making 101', 'Making 101 artisan soaps', 2);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (2, 'Advanced anger management', 3);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (3, 'Artisan tea making', 2);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (4, 'Spoon bending for beginners', 4);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (5, 'Artisan soup making', 3);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (6, 'Building better worlds', 3);
INSERT INTO courses (courseID, coursename, location_locationcode) 
VALUES (7, 'Alien ecology', 4);

SELECT * FROM employees;

INSERT INTO historic (event, date, lecturer, employee_eID, courses_courseID, courses_coursename) 
VALUES (1, 2017-06-03, 'Jon Nordby', 5, 1, 'Artisan soap making 101');
INSERT INTO historic (event, date, lecturer, employee_eID, courses_courseID, courses_coursename) 
VALUES (2, 2017-06-03, 'Jon Nordby', 1, 1, 'Artisan soap making 101');
INSERT INTO historic (event, date, lecturer, employee_eID, courses_courseID, courses_coursename) 
VALUES (3, 2017-06-03, 'Jon Nordby', 6, 1, 'Artisan soap making 101');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (4, 2017-10-14, 5, 2, 'Advanced anger management');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (5, 2017-10-14, 1, 2, 'Advanced anger management');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (6, 2017-10-14, 6, 2, 'Advanced anger management');
INSERT INTO historic (event, date, lecturer, employee_eID, courses_courseID, courses_coursename) 
VALUES (7, 2017-07-18, 'Jon Nordby', 5, 1, 'Artisan soap making 101');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (8, 2017-06-03, 2, 3, 'Artisan tea making 101');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (9, 2017-06-03, 3, 3, 'Artisan tea making 101');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (10, 2017-03-22, 2, 4, 'Spoon bending for beginners');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (11, 2017-03-22, 3, 4, 'Spoon bending for beginners');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (12, 2017-04-01, 3, 4, 'Spoon bending for beginners');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (13, 2017-04-08, 3, 4, 'Spoon bending for beginners');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (14, 2017-04-22, 3, 4, 'Spoon bending for beginners');
INSERT INTO historic (event, date, employee_eID, courses_courseID, courses_coursename) 
VALUES (15, 2017-01-02, 1, 5, 'Artisan soup making 101');
