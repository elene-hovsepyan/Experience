-- 1. Log when a new citizen is added
DELIMITER $$
CREATE TRIGGER LogNewCitizen AFTER INSERT ON Citizen
FOR EACH ROW
BEGIN
    INSERT INTO LogTable VALUES (NULL, CONCAT('New citizen added: ', NEW.FirstName), NOW());
END$$
DELIMITER ;

-- 2. Auto-calculate taxPaid in TaxRecord
DELIMITER $$
CREATE TRIGGER AutoTaxPaid BEFORE INSERT ON TaxRecord
FOR EACH ROW
BEGIN
    SET NEW.TaxPaid = NEW.Income * 0.15;
END$$
DELIMITER ;

-- 3. Prevent deletion of a citizen with vehicle
DELIMITER $$
CREATE TRIGGER PreventCitizenDeleteVeh BEFORE DELETE ON Citizen
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Vehicle WHERE OwnerID = OLD.CitizenID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete citizen with vehicles';
    END IF;
END$$
DELIMITER ;

-- 4. Track changes to employee salary
DELIMITER $$
CREATE TRIGGER TrackSalaryChange BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO SalaryChangeLog VALUES (NULL, OLD.EmployeeID, OLD.Salary, NEW.Salary, NOW());
    END IF;
END$$
DELIMITER ;

-- 5. Prevent deletion of a citizen with Property
DELIMITER $$
CREATE TRIGGER PreventCitizenDeleteProp BEFORE DELETE ON Citizen
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Property WHERE OwnerID = OLD.CitizenID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete citizen with property';
    END IF;
END$$
DELIMITER ;

-- 6. Track changes to HeadEmployee
DELIMITER $$
CREATE TRIGGER TrackHeadEmployeeChange BEFORE UPDATE ON Governmentdept
FOR EACH ROW
BEGIN
    IF OLD.HeadEmployeeID <> NEW.HeadEmployeeID THEN
        INSERT INTO HeadEmployeeIDChangeLog VALUES (NULL, OLD.HeadEmployeeID, NEW.HeadEmployeeID, NOW());
    END IF;
END$$
DELIMITER ;