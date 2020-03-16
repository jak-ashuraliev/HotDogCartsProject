-- MySQL Script generated by MySQL Workbench
-- Sun Feb 23 15:04:28 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

#Create Schema
DROP SCHEMA IF EXISTS `HotDogDatabase`;
CREATE SCHEMA `HotDogDatabase` DEFAULT CHARACTER SET utf8 ;
USE `HotDogDatabase` ;

#Item
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`ITEM` (
  `ItemID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ItemID`))
ENGINE = InnoDB;


#User
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`USER` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `usertype` ENUM('admin', 'vendor', 'customer') NOT NULL,
  PRIMARY KEY (`UserID`))
ENGINE = InnoDB;


#Location
#I implement a cascading update because want to update the fkID if we change the user PK.
#Restrict delete because location must have a user.
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`LOCATION` (
  `LocationID` INT NOT NULL AUTO_INCREMENT,
  `VendorName` VARCHAR(45) NULL,
  `Availability` ENUM('Y', 'N') NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `UserID` INT NOT NULL,
  PRIMARY KEY (`LocationID`),
  CONSTRAINT `fk_Location_User`
    FOREIGN KEY (`UserID`)
    REFERENCES `HotDogDatabase`.`USER` (`UserID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


#Order
# I implement a cascading update because want to update the fkID if we change the location PK
# I want to restrict deleting locations that have orders associated with them. 
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`ORDER` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `LocationID` INT NOT NULL,
  `Status` ENUM('Received', 'Fulfilled') NOT NULL,
  `Time` DATETIME NOT NULL,
  PRIMARY KEY (`OrderID`, `LocationID`),
  CONSTRAINT `fk_Order_Location`
    FOREIGN KEY (`LocationID`)
    REFERENCES `HotDogDatabase`.`LOCATION` (`LocationID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

#Log
# I implement a cascading update because want to update the fkID if we change the user PK
# Restrict delete if we have a log of item or location.
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`LOG` (
  `ChangeID` INT NOT NULL AUTO_INCREMENT,
  `Type` ENUM('LOCATION_ADD', 'LOCATION_AVAILABILITY', 'LOCATION_ADDRESS', 'MENU_AVAILABILITY') NOT NULL,
  `Original_Availability` ENUM('Y', 'N') NULL,
  `New_Availability` ENUM('Y', 'N') NULL,
  `Time` DATETIME NOT NULL,
  `Original_Address` VARCHAR(45) NULL,
  `New_Address` VARCHAR(45) NULL,
  `LocationID` INT NOT NULL,
  `ItemID` INT NULL,
  PRIMARY KEY (`ChangeID`),
  CONSTRAINT `fk_Log_Location`
  FOREIGN KEY (`LocationID`)
    REFERENCES `HotDogDatabase`.`LOCATION` (`LocationID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Log_Item`
  FOREIGN KEY (`ItemID`)
    REFERENCES `HotDogDatabase`.`Item` (`ItemID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


#Order_Item 
#We shouldn't be able to delete an item if its associated with any orders. ON DELETE RESTRICT is thus logical
#However if we want to delete the an order then that should cascade delete the order items. 
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`Order_Item` (
  `ItemID` INT NOT NULL,
  `OrderID` INT NOT NULL,
  `LocationID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  PRIMARY KEY (`ItemID`, `OrderID`, `LocationID`),
  CONSTRAINT `fk_ORDER_ITEM`
    FOREIGN KEY (`ItemID`)
    REFERENCES `HotDogDatabase`.`ITEM` (`ItemID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ITEM_has_ORDER_ORDER1`
    FOREIGN KEY (`OrderID` , `LocationID`)
    REFERENCES `HotDogDatabase`.`ORDER` (`OrderID` , `LocationID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


#Location_Item
#We shouldn't be able to delete an item if its associated with any locations. ON DELETE RESTRICT is thus logical
#However if we want to delete the a location then that should cascade delete the corresponding location items. 
CREATE TABLE IF NOT EXISTS `HotDogDatabase`.`LOCATION_ITEM` (
  `LocationID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Availability` ENUM('Y', 'N') NOT NULL,
  `Quantity` INT NOT NULL,
  PRIMARY KEY (`LocationID`, `ItemID`),
  CONSTRAINT `fk_ITEM_LOCATION`
    FOREIGN KEY (`LocationID`)
    REFERENCES `HotDogDatabase`.`LOCATION` (`LocationID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_LOCATION_has_ITEM_ITEM1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `HotDogDatabase`.`ITEM` (`ItemID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

DELIMITER //
CREATE PROCEDURE ShowLog()
	BEGIN
    SELECT `Type` AS 'Change Type',
			`Time` AS 'Time', 
			Original_Availability AS 'Original_Availability',
            New_Availability AS 'New_Availability',
            Original_Address AS 'Original_Address',
            New_Address AS 'New_Address',
			Location.VendorName AS 'Location',
            Item.`Name` AS 'Item'
	 FROM LOG JOIN LOCATION USING(LocationID) JOIN ITEM USING(ItemID)
     ORDER BY `Time` DESC;
END //

DELIMITER //
CREATE PROCEDURE ShowLocation()
BEGIN
	SELECT LOCATION.VendorName AS 'VendorName',
    LOCATION.Address AS 'Address', 
    LOCATION.Availability AS 'Available'
FROM LOCATION
ORDER BY Location.VendorName DESC;
END //

DELIMITER //
CREATE PROCEDURE ShowOrder()
BEGIN
	SELECT `ORDER`.`Status` AS 'Order Status',
    `ORDER`.`TIME` AS 'Time Received',
    `Location`.VendorName'Location Name',
    `Item`.`Name` AS 'Item',
    ORDER_Item.Quantity AS 'Quantity'
    FROM `ORDER` 
		JOIN LOCATION USING(LocationID) 
        JOIN Order_Item USING(OrderID) 
        JOIN ITEM USING(ItemID) 
	ORDER BY OrderID;
END //

DELIMITER //
CREATE PROCEDURE ShowMenu(IN inLocationID INT)
BEGIN
	SELECT ITEM.`Name` AS 'Item', 
    LOCATION_ITEM.Quantity AS 'Quantity',
    LOCATION_ITEM.Availability AS 'Availability'
    FROM LOCATION
		JOIN LOCATION_ITEM USING(LocationID)
        JOIN ITEM USING(ItemID)
	WHERE LocationID = inLocationID;
END //
#----------------------TRIGGERS-----------------------

DELIMITER //
CREATE TRIGGER LOCATION_ADD AFTER INSERT ON LOCATION
	FOR EACH ROW
	BEGIN
	  INSERT INTO LOG (ChangeID, `Type`, Original_Availability, New_Availability, `Time`, Original_Address, New_Address, LocationID, ItemID)
	  VALUES
      (NULL, 'LOCATION_ADD',NULL, NEW.Availability, NOW(), NULL, NEW.Address, NEW.LocationID, NULL);
	END//

DELIMITER //
CREATE TRIGGER LOCATION_AVAILABILITY AFTER UPDATE ON LOCATION
	FOR EACH ROW
	BEGIN
	  INSERT INTO LOG
	  VALUES
      (
      NULL,
      'LOCATION_AVAILABILITY',
      OLD.Availability,
      NEW.Availability,
      NOW(),
      NULL,
      NULL,
      NEW.LocationID,
      NULL
      );
	END//

DELIMITER //
CREATE TRIGGER LOCATION_ADDRESS AFTER UPDATE ON LOCATION
	FOR EACH ROW
	BEGIN
	  INSERT INTO LOG
	  VALUES
      (
      NULL,
      'LOCATION_ADDRESS',
      NULL,
      NULL,
      NOW(),
      OLD.Address,
      NEW.Address,
      NEW.LocationID,
      NULL
      );
	END//

DELIMITER //
CREATE TRIGGER MENU_AVAILABILITY AFTER UPDATE ON LOCATION_ITEM
	FOR EACH ROW
	BEGIN
	  INSERT INTO LOG
	  VALUES
      (
      NULL,
      'MENU_AVAILABILITY',
      OLD.Availability,
      NEW.Availability,
      NOW(),
      NULL,
      NULL,
      NEW.LocationID,
      NEW.ItemID
      );
	END//


INSERT INTO `USER`
	VALUES	(NULL, 'cooldude@gmail.com', '1234', 'Ben', 'Douginson', 'vendor'),
			(NULL, 'skatedad@gmail.com', '2222', 'Chad', 'Dugelsen', 'vendor'),
            (NULL, 'sailboater@gmail.com', '9992', 'Vlad', 'Dugelsen', 'vendor'),
            (NULL, 'snowboarder@gmail.com', '5352', 'Germanicus', 'Clay', 'vendor');

INSERT INTO `LOCATION`
			(LocationID, VendorName, Availability, Address, UserID)
	VALUES	(NULL, 'Queene Anne Dogs', 'Y', '95 Aurora Ave N, Seattle WA', 1),
			(NULL, 'VeganGood Dogs', 'Y', '105 Greenwood Ave N, Seattle WA', 2),
            (NULL, 'VeganCool Dogs', 'Y', '120 Greenwood Ave N, Seattle WA', 3),
            (NULL, 'Seattle Dogs', 'Y', '132 Greenwood Ave N, Seattle WA', 4);
            
INSERT INTO ITEM
	VALUES (NULL, 'Vegan Dog');
            
INSERT INTO LOG (ChangeID, `Type`, Original_Availability, New_Availability, `Time`, Original_Address, New_Address, LocationID, ItemID)
		VALUES	(NULL, 'LOCATION_ADD',NULL, 'Y', '2011-01-01', NULL, '12 Syracuse Ave', 1, 1),
        	(NULL, 'LOCATION_ADD',NULL, 'Y', '2012-03-01', NULL, '14 Greenwood Ave', 1, 1),
        	(NULL, 'LOCATION_ADD',NULL, 'Y', '2013-02-01', NULL, '19 Aurora Ave', 1, 1);



