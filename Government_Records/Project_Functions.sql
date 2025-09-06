-- 1. Function to calculate tax based on income
DELIMITER $$
CREATE FUNCTION CalculateTax(income INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN income * 0.15;
END$$
DELIMITER ;

-- 2. Function to return full name of a citizen
DELIMITER $$
CREATE FUNCTION GetFullName(cid INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE fname VARCHAR(50);
    DECLARE lname VARCHAR(50);
    SELECT FirstName, LastName INTO fname, lname FROM Citizen WHERE CitizenID = cid;
    RETURN CONCAT(fname, ' ', lname);
END$$
DELIMITER ;

-- 3. Function to count number of vehicles owned by a citizen
DELIMITER $$
CREATE FUNCTION CountVehicles(cid INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Vehicle WHERE OwnerID = cid;
    RETURN total;
END$$
DELIMITER ;

-- 4. Function to return average property value
DELIMITER $$
CREATE FUNCTION AvgPropertyValue() RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE val INT;
    SELECT AVG(Valuation) INTO val FROM Property;
    RETURN val;
END$$
DELIMITER ;

-- 5. Function to return year difference
DELIMITER $$
CREATE FUNCTION YearsBetween(startDate DATE, endDate DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(endDate) - YEAR(startDate);
END$$
DELIMITER ;

-- 6. Function to check if citizen owns both vehicle and property
DELIMITER $$
CREATE FUNCTION OwnsVehicleAndProperty(cid INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN EXISTS (SELECT 1 FROM Vehicle WHERE OwnerID = cid)
       AND EXISTS (SELECT 1 FROM Property WHERE OwnerID = cid);
END$$
DELIMITER ;