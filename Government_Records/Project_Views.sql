CREATE VIEW ActivePermits AS
SELECT * FROM Permit WHERE Status = 'Active';

CREATE VIEW CitizenVehicles AS
SELECT c.CitizenID, c.FirstName, c.LastName, v.Make, v.Model
FROM Citizen c
JOIN Vehicle v ON c.CitizenID = v.OwnerID;

CREATE VIEW ServiceRequestsSummary AS
SELECT CitizenID, COUNT(*) AS TotalRequests
FROM ServiceRequest
GROUP BY CitizenID;

CREATE VIEW HighEarners AS
SELECT * FROM Employee WHERE Salary > 80000;

CREATE VIEW PropertyOwnership AS
SELECT p.PropertyID, c.FirstName, c.LastName, p.Valuation
FROM Property p
JOIN Citizen c ON p.OwnerID = c.CitizenID;

CREATE VIEW LicenseStatusView AS
SELECT l.LicenseID, l.Status, c.FirstName, c.LastName
FROM License l
JOIN Citizen c ON l.CitizenID = c.CitizenID;