-- TRIGGER TESTS

-- Ensure the log tables exist
CREATE TABLE IF NOT EXISTS LogTable (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Description TEXT,
    LogTime DATETIME
);

CREATE TABLE IF NOT EXISTS SalaryChangeLog (
    ChangeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangeTime DATETIME
);

CREATE TABLE IF NOT EXISTS HeadEmployeeIDChangeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OldHeadEmployeeID INT,
    NewHeadEmployeeID INT,
    ChangeTime DATETIME
);

-- Trigger 1: LogNewCitizen
INSERT INTO Citizen (CitizenID, AddressID, FirstName, LastName, DOB, Gender, Phone, Email, NationalID)
VALUES (9991, 1, 'Log', 'Test', '1990-01-01', 'Female', '0123456789', 'log@example.com', 'NAT9991');

SELECT * FROM LogTable;

-- Trigger 2: AutoTaxPaid
INSERT INTO TaxRecord (TaxID, CitizenID, Year, Income, Status)
VALUES (9945, 1, curdate(), 6400, "filed");

SELECT * FROM TaxRecord WHERE TaxID = 9945;

-- Trigger 3: PreventCitizenDeleteVeh
-- Should raise an error if CitizenID 33 has vehicles
DELETE FROM Citizen WHERE CitizenID = 33;

-- Trigger 4: TrackSalaryChange
UPDATE Employee SET Salary = Salary + 500 WHERE EmployeeID = 1;
SELECT * FROM SalaryChangeLog WHERE EmployeeID = 1 ORDER BY ChangeID DESC LIMIT 1;

-- Trigger 5: PreventCitizenDeleteProp
-- Should raise an error if CitizenID 1 owns property
DELETE FROM Citizen WHERE CitizenID = 1;

-- Trigger 6: TrackHeadEmployeeChange
UPDATE Governmentdept SET HeadEmployeeID = 5 WHERE DeptID = 1;
SELECT * FROM HeadEmployeeIDChangeLog;
