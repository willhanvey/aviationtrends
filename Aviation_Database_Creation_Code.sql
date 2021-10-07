-- Data Imports

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema v2jfueqb2gmi9nxu
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `v2jfueqb2gmi9nxu` ;

-- -----------------------------------------------------
-- Schema v2jfueqb2gmi9nxu
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `v2jfueqb2gmi9nxu` DEFAULT CHARACTER SET utf8 ;
USE `v2jfueqb2gmi9nxu` ;

-- -----------------------------------------------------
-- Table `country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `country` ;

CREATE TABLE IF NOT EXISTS `country` (
  `country_id` VARCHAR(10) NOT NULL,
  `name` VARCHAR(50) NULL,
  `population` INT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_id_UNIQUE` (`country_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `state` ;

CREATE TABLE IF NOT EXISTS `state` (
  `state_id` VARCHAR(10) NOT NULL,
  `population` INT NULL,
  `name` VARCHAR(50) NULL,
  `country_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`state_id`),
  UNIQUE INDEX `state_id_UNIQUE` (`state_id` ASC) VISIBLE,
  INDEX `fk_state_country_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_state_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airport` ;

CREATE TABLE IF NOT EXISTS `airport` (
  `airport_id` CHAR(3) NOT NULL,
  `airport_name` VARCHAR(100) NULL,
  `state_id` VARCHAR(10) NULL,
  `country_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`airport_id`),
  UNIQUE INDEX `airport_id_UNIQUE` (`airport_id` ASC) VISIBLE,
  INDEX `fk_airport_state1_idx` (`state_id` ASC) VISIBLE,
  INDEX `fk_airport_country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_airport_state1`
    FOREIGN KEY (`state_id`)
    REFERENCES `state` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_airport_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `arrivals_by_year`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `arrivals_by_year` ;

CREATE TABLE IF NOT EXISTS `arrivals_by_year` (
  `year` YEAR NOT NULL,
  `total_arrivals` INT NULL,
  `country_id` VARCHAR(10) NOT NULL,
  INDEX `fk_year_country1_idx` (`country_id` ASC) VISIBLE,
  UNIQUE INDEX `UNIQUE` (`year` ASC, `country_id` ASC) VISIBLE,
  CONSTRAINT `fk_year_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline` ;

CREATE TABLE IF NOT EXISTS `airline` (
  `airline_id` INT NOT NULL AUTO_INCREMENT,
  `airline_name` VARCHAR(100) NULL,
  PRIMARY KEY (`airline_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `flight`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flight` ;

CREATE TABLE IF NOT EXISTS `flight` (
  `flight_id` INT NOT NULL AUTO_INCREMENT,
  `passengers` INT NULL,
  `freight` INT NULL,
  `mail` INT NULL,
  `distance` INT NULL,
  `year` YEAR NOT NULL,
  `month` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12') NOT NULL,
  `service_class` ENUM('A', 'C', 'E', 'F', 'G', 'H', 'K', 'L', 'N', 'P', 'Q', 'R', 'V', 'Z') NULL,
  `airline` INT NOT NULL,
  `domestic` TINYINT NOT NULL,
  `departure_airport_id` CHAR(3) NOT NULL,
  `arrival_airport_id` CHAR(3) NOT NULL,
  PRIMARY KEY (`flight_id`),
  UNIQUE INDEX `flight_id_UNIQUE` (`flight_id` ASC) VISIBLE,
  INDEX `fk_flight_airline1_idx` (`airline` ASC) VISIBLE,
  CONSTRAINT `fk_flight_airline1`
    FOREIGN KEY (`airline`)
    REFERENCES `airline` (`airline_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_trip_airport2`
    FOREIGN KEY (`departure_airport_id`)
    REFERENCES `airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_trip_airport3`
    FOREIGN KEY (`arrival_airport_id`)
    REFERENCES `airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `airline_subdivisions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airline_subdivisions` ;

CREATE TABLE IF NOT EXISTS `airline_subdivisions` (
  `carrier_entity` VARCHAR(10) NULL,
  `region` ENUM('A', 'D', 'I', 'L', 'P', 'S') NULL,
  `airline_id` INT NOT NULL,
  INDEX `fk_airline_subdivisions_airline1_idx` (`airline_id` ASC) VISIBLE,
  UNIQUE INDEX `unique` (`carrier_entity` ASC, `region` ASC, `airline_id` ASC) VISIBLE,
  CONSTRAINT `fk_airline_subdivisions_airline1`
    FOREIGN KEY (`airline_id`)
    REFERENCES `airline` (`airline_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_stats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `covid_stats` ;

CREATE TABLE IF NOT EXISTS `covid_stats` (
  `total_cases` INT NULL,
  `total_deaths` INT NULL,
  `monthly_cases` INT NULL,
  `monthly_deaths` INT NULL,
  `month` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12') NULL,
  `year` YEAR NULL,
  `state_id` VARCHAR(10) NULL,
  `country_id` VARCHAR(10) NULL,
  INDEX `fk_covid_stats_state1_idx` (`state_id` ASC) VISIBLE,
  UNIQUE INDEX `unique` (`country_id` ASC, `state_id` ASC, `month` ASC, `year` ASC) VISIBLE,
  CONSTRAINT `fk_covid_stats_state1`
    FOREIGN KEY (`state_id`)
    REFERENCES `state` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_covid_stats_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


drop table if exists flight_staging_table;
create table flight_staging_table (
flight_id int primary key not null auto_increment unique,
PASSENGERS int unsigned,
    FREIGHT varchar(100),
    MAIL int unsigned,
    DISTANCE int unsigned,
    UNIQUE_CARRIER varchar(50),
    AIRLINE_ID int unsigned,
    UNIQUE_CARRIER_NAME varchar(100),
    UNIQUE_CARRIER_ENTITY int unsigned,
    REGION varchar(50),
   
	CARRIER varchar(50),
	CARRIER_NAME varchar(50),
    ORIGIN_AIRPORT_ID int unsigned,
	ORIGIN_AIRPORT_SEQ_ID int unsigned,
    ORIGIN varchar(50),
    ORIGIN_AIRPORT_NAME varchar(250),
    ORIGIN_COUNTRY varchar(50),
    ORIGIN_COUNTRY_NAME varchar(50),
	ORIGIN_STATE_ABR varchar(50),
	ORIGIN_STATE_NM varchar(50),
    ORIGIN_WAC int unsigned,
   
	DEST_AIRPORT_ID varchar(50),
	DEST_AIRPORT_SEQ_ID int unsigned,
    DEST varchar(50),
    DEST_AIRPORT_NAME varchar(250),
    DEST_COUNTRY varchar(50),
    DEST_COUNTRY_NAME varchar(50),
	DEST_STATE_ABR varchar(50),
	DEST_STATE_NM varchar(50),
	DEST_WAC int unsigned,
	YEAR smallint unsigned,
	MONTH tinyint unsigned,
    DOMESTIC tinyint unsigned,
    CLASS varchar(50)
);

set global local_infile = ON;
load data
local infile -- filepath here
    into table flight_staging_table
    fields terminated by ',' enclosed by '"'
    ignore 1 lines
(PASSENGERS,
FREIGHT,
     MAIL,
     DISTANCE,
     UNIQUE_CARRIER,
     AIRLINE_ID,
     UNIQUE_CARRIER_NAME,
     UNIQUE_CARRIER_ENTITY,
     REGION,
     CARRIER,
     CARRIER_NAME,
     ORIGIN_AIRPORT_ID,
     ORIGIN_AIRPORT_SEQ_ID,
     
     ORIGIN,
     ORIGIN_AIRPORT_NAME,
     ORIGIN_COUNTRY,
     ORIGIN_COUNTRY_NAME,
     ORIGIN_STATE_ABR,
     ORIGIN_STATE_NM,
     ORIGIN_WAC,
     
     DEST_AIRPORT_ID,
     DEST_AIRPORT_SEQ_ID,
     DEST,
     DEST_AIRPORT_NAME,
     DEST_COUNTRY,
     DEST_COUNTRY_NAME,
     DEST_STATE_ABR,
     DEST_STATE_NM,
     DEST_WAC,
     YEAR,
     MONTH,
     CLASS,
     DOMESTIC)
     set FLIGHT_ID = NULL;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

UPDATE flight_staging_table
SET ORIGIN_STATE_ABR = Null
WHERE ORIGIN_STATE_ABR = '';

UPDATE flight_staging_table
SET ORIGIN_STATE_NM = Null
WHERE ORIGIN_STATE_NM = '';

UPDATE flight_staging_table
SET DEST_STATE_ABR = Null
WHERE DEST_STATE_ABR = '';

UPDATE flight_staging_table
SET DEST_STATE_NM = Null
WHERE DEST_STATE_NM = '';

INSERT INTO airline
(SELECT DISTINCT airline_id, unique_carrier_name
FROM flight_staging_table);

INSERT INTO airline_subdivisions
(SELECT distinct unique_carrier_entity, region, airline_id
FROM flight_staging_table
WHERE airline_id != 0);

INSERT INTO flight
(SELECT flight_id, passengers, freight, mail, distance, year, month, class, airline_id, domestic, origin, dest
FROM flight_staging_table
WHERE airline_id != 0);

-- Data Fixes

UPDATE flight_staging_table
SET ORIGIN = 'GSZ'
WHERE ORIGIN = 'XWA' and ORIGIN_STATE_ABR = 'AK';

UPDATE flight_staging_table
SET ORIGIN_AIRPORT_NAME = 'Granite Mountain Air Station'
WHERE ORIGIN = 'GSZ' AND ORIGIN_STATE_ABR = 'AK';

UPDATE flight_staging_table
SET DEST = 'GSZ'
WHERE DEST = 'XWA' and DEST_STATE_ABR = 'AK';

UPDATE flight_staging_table
SET DEST_AIRPORT_NAME = 'Granite Mountain Air Station'
WHERE DEST = 'GSZ' AND DEST_STATE_ABR = 'AK';

UPDATE flight_staging_table
SET origin_state_abr = 'AZ'
WHERE origin = 'MSC' and origin_airport_name = 'Falcon Field';
UPDATE flight_staging_table
SET dest_state_abr = 'AZ'
WHERE dest = 'MSC' and dest_airport_name = 'Falcon Field';
UPDATE flight_staging_table
SET origin_state_abr = 'FL'
WHERE origin = 'COF' and origin_airport_name = 'Patrick AFB';
UPDATE flight_staging_table
SET dest_state_abr = 'FL'
WHERE dest = 'COF' and dest_airport_name = 'Patrick AFB';
UPDATE flight_staging_table
SET origin_state_abr = 'NM'
WHERE origin = 'HMN' and origin_airport_name = 'Holloman AFB';
UPDATE flight_staging_table
SET dest_state_abr = 'NM'
WHERE dest = 'HMN' and dest_airport_name = 'Holloman AFB';
UPDATE flight_staging_table
SET origin_state_abr = 'WA'
WHERE origin = 'WA5' and origin_airport_name = 'Methow Valley State';
UPDATE flight_staging_table
SET dest_state_abr = 'WA'
WHERE dest = 'WA5' and dest_airport_name = 'Methow Valley State';
UPDATE flight_staging_table
SET origin_state_abr = 'TX'
WHERE origin = 'CNW' and origin_airport_name = 'TSTC Waco';
UPDATE flight_staging_table
SET dest_state_abr = 'TX'
WHERE dest = 'CNW' and dest_airport_name = 'TSTC Waco';
UPDATE flight_staging_table
SET dest_state_abr = 'TX'
WHERE origin = 'MWL' and origin_airport_name = 'Mineral Wells Regional';
UPDATE flight_staging_table
SET dest_state_abr = 'TX'
WHERE dest = 'MWL' and dest_airport_name = 'Mineral Wells Regional';
UPDATE flight_staging_table
SET dest_state_abr = 'NC'
WHERE origin = 'MXE' and origin_airport_name = 'Laurinburg-Maxton';
UPDATE flight_staging_table
SET dest_state_abr = 'NC'
WHERE dest = 'MXE' and dest_airport_name = 'Laurinburg-Maxton';
UPDATE flight_staging_table
SET origin_state_abr = 'IA'
WHERE origin = 'IA4' and origin_airport_name = 'Pella Municipal';
UPDATE flight_staging_table
SET dest_state_abr = 'IA'
WHERE dest = 'IA4' and dest_airport_name = 'Pella Municipal';
UPDATE flight_staging_table
SET origin_state_abr = 'MS'
WHERE origin = 'STF' and origin_airport_name = 'George M. Bryan';
UPDATE flight_staging_table
SET dest_state_abr = 'MS'
WHERE dest = 'STF' and dest_airport_name = 'George M. Bryan';
UPDATE flight_staging_table
SET origin_state_abr = 'FL'
WHERE origin = '1FL' and origin_airport_name = 'NASA Shuttle Landing Facility';
UPDATE flight_staging_table
SET dest_state_abr = 'FL'
WHERE dest = '1FL' and dest_airport_name = 'NASA Shuttle Landing Facility';
UPDATE flight_staging_table
SET origin_state_abr = 'NV'
WHERE origin = 'TPH' and origin_airport_name = 'Tonopah Airport';
UPDATE flight_staging_table
SET dest_state_abr = 'NV'
WHERE dest = 'TPH' and dest_airport_name = 'Tonopah Airport';
UPDATE flight_staging_table
SET origin_state_abr = 'WI'
WHERE origin = 'UES' and origin_airport_name = 'Waukesha County';
UPDATE flight_staging_table
SET dest_state_abr = 'WI'
WHERE dest = 'UES' and dest_airport_name = 'Waukesha County';
UPDATE flight_staging_table
SET origin_state_abr = 'TX'
WHERE origin = '3TX' and origin_airport_name = 'Lancaster Regional';
UPDATE flight_staging_table
SET dest_state_abr = 'TX'
WHERE dest = '3TX' and dest_airport_name = 'Lancaster Regional';
UPDATE flight_staging_table
SET origin_state_abr = 'FL'
WHERE origin = 'FL7' and origin_airport_name = 'Coral Creek';
UPDATE flight_staging_table
SET dest_state_abr = 'FL'
WHERE dest = 'FL7' and dest_airport_name = 'Coral Creek';
UPDATE flight_staging_table
SET origin_state_abr = 'MS'
WHERE origin = 'UXP' and origin_airport_name = 'Stennis International';
UPDATE flight_staging_table
SET dest_state_abr = 'MS'
WHERE dest = 'UXP' and dest_airport_name = 'Stennis International';
UPDATE flight_staging_table
SET origin_state_abr = 'AL'
WHERE origin = 'AL7' and origin_airport_name = 'Walker County Bevill Field';
UPDATE flight_staging_table
SET dest_state_abr = 'AL'
WHERE dest = 'AL7' and dest_airport_name = 'Walker County Bevill Field';
UPDATE flight_staging_table
SET origin_state_abr = 'FL'
WHERE origin = 'LEE' and origin_airport_name = 'Leesburg International';
UPDATE flight_staging_table
SET dest_state_abr = 'FL'
WHERE dest = 'LEE' and dest_airport_name = 'Leesburg International';
UPDATE flight_staging_table
SET origin_state_abr = 'AL'
WHERE origin = 'HUA' and origin_airport_name = 'Redstone AAF';
UPDATE flight_staging_table
SET dest_state_abr = 'AL'
WHERE dest = 'HUA' and dest_airport_name = 'Redstone AAF';
UPDATE flight_staging_table
SET origin_state_abr = 'TN'
WHERE origin = 'TUH' and origin_airport_name = 'Arnold AFB';
UPDATE flight_staging_table
SET dest_state_abr = 'TN'
WHERE dest = 'TUH' and dest_airport_name = 'Arnold AFB';
UPDATE flight_staging_table
SET origin_state_abr = 'TX'
WHERE origin = 'MWL' and origin_airport_name = 'Mineral Wells Regional';
UPDATE flight_staging_table
SET dest_state_abr = 'TX'
WHERE dest = 'MWL' and dest_airport_name = 'Mineral Wells Regional';
UPDATE flight_staging_table
SET origin_state_abr = 'NC'
WHERE origin = 'MXE' and origin_airport_name = 'Laurinburg-Maxton';
UPDATE flight_staging_table
SET dest_state_abr = 'NC'
WHERE dest = 'MXE' and dest_airport_name = 'Laurinburg-Maxton';
UPDATE flight_staging_table
SET origin_state_abr = null
WHERE origin = 'FAB' and origin_airport_name = 'Farnborough Airport';
UPDATE flight_staging_table
SET dest_state_abr = null
WHERE dest = 'FAB' and dest_airport_name = 'Farnborough Airport';
UPDATE flight_staging_table
SET origin_state_abr = null
WHERE origin_country = 'CA' and origin_airport_name = 'Pierre Elliott Trudeau International';
UPDATE flight_staging_table
SET dest_state_abr = null
WHERE dest_country = 'CA' and dest_airport_name = 'Pierre Elliott Trudeau International';

insert into airport
(select distinct origin as 'airport_id', origin_airport_name as 'airport_name', origin_state_abr as 'state_id', origin_country as 'country_id'
from flight_staging_table
union
select distinct dest as 'airport_id', dest_airport_name as 'airport_name', dest_state_abr as 'state_id', dest_country as 'country_id'
from flight_staging_table);


