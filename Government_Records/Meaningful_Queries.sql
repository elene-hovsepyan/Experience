-- 1. Find the total number of citizens
SELECT COUNT(*) AS TotalCitizens 
FROM Citizen;

-- 2. List citizens who have more than one vehicle
SELECT OwnerID, COUNT(*) as NumOfVehicles 
FROM Vehicle 
GROUP BY OwnerID 
HAVING COUNT(*) > 1;

-- 3. Average income by year (TaxRecord)
SELECT Year, AVG(Income) AS AvgIncome 
FROM TaxRecord 
GROUP BY Year
ORDER BY YEAR DESC;

-- 4. Services requested per department
SELECT g.DeptID, g.AgencyName, COUNT(*) AS TotalRequests
FROM ServiceRequest sr
JOIN Service s ON sr.ServiceID = s.ServiceID
JOIN GovernmentDept g ON s.DeptID = g.DeptID
GROUP BY g.DeptID;

-- 5. List all active permits and related citizen names
SELECT p.PermitID, c.FirstName, c.LastName, p.Status
FROM Permit p JOIN Citizen c 
ON p.CitizenID = c.CitizenID
WHERE p.Status = 'Active';

-- 6. Citizens who have at least one license
SELECT DISTINCT l.CitizenID, c.FirstName, c.LastName
FROM License l JOIN Citizen c
on l.CitizenID = c.CitizenID;

-- 7. Citizens who do NOT have any vehicles
SELECT CitizenID, FirstName, LastName
FROM Citizen
WHERE CitizenID NOT IN (SELECT OwnerID 
						FROM Vehicle);

-- 8. List facilities by type and count
SELECT Type, COUNT(*) AS Total 
FROM Facility 
GROUP BY Type;

-- 9. Get the top 5 highest paid employees
SELECT * 
FROM Employee 
ORDER BY Salary DESC 
LIMIT 5;

-- 10. Check which citizens have both a vehicle and a license
SELECT c.CitizenID, c.FirstName, c.LastName
FROM Citizen c
WHERE EXISTS (SELECT 1 FROM Vehicle v WHERE v.OwnerID = c.CitizenID)
AND EXISTS (SELECT 1 FROM License l WHERE l.CitizenID = c.CitizenID);

-- 11. List the most recent service request per citizen
SELECT sr.*
FROM ServiceRequest sr
JOIN (
    SELECT CitizenID, MAX(RequestDate) AS LatestRequest
    FROM ServiceRequest
    GROUP BY CitizenID
) latest ON sr.CitizenID = latest.CitizenID AND sr.RequestDate = latest.LatestRequest;

-- 12. Count licenses by license type
SELECT ld.LicenseType, COUNT(*) AS Total
FROM License l
JOIN LicenseDict ld ON l.LicenseTypeID = ld.LicenseTypeID
GROUP BY ld.LicenseType;

-- 13. Most used vehicle
SELECT v.Make, v.Model, m.NumberOf
FROM Vehicle v
JOIN (SELECT Model, COUNT(Model) AS NumberOf
FROM Vehicle
GROUP BY Model) m on v.Model = m.Model
ORDER BY NumberOf DESC
LIMIT 1;

-- 14. Count of crimes per employee (officer)
SELECT OfficerID, COUNT(*) AS TotalCrimesInvestigated
FROM CrimeRecord
GROUP BY OfficerID;

-- 15. Find elections held in a specific region
SELECT * 
FROM Election 
WHERE Region = 'Marktown';

-- 16. List citizens who voted and the elections they participated in
SELECT v.CitizenID, e.Type, e.Year
FROM Vote v
JOIN Election e ON v.ElectionID = e.ElectionID
ORDER BY e.Year,v.CitizenID;

-- 17. List citizens whose income is above the average income
SELECT  c.FirstName, c.LastName, t.CitizenID, t.Income
FROM TaxRecord t JOIN Citizen c
on c.CitizenID = t.CitizenID
WHERE Income > (
    SELECT AVG(Income) FROM TaxRecord
)
ORDER BY t.CitizenID;

-- 18. List departments with more employees than the average per department
SELECT Employee.DeptID, Governmentdept.AgencyName, COUNT(*) AS EmployeeCount
FROM Employee JOIN Governmentdept
on Employee.DeptID = Governmentdept.DeptID
GROUP BY DeptID
HAVING COUNT(*) > (
    SELECT AVG(EmpCount) FROM (
        SELECT COUNT(*) AS EmpCount FROM Employee GROUP BY DeptID
    ) AS DeptCounts
);

-- 19. List all properties above the average valuation
SELECT * 
FROM Property
WHERE Valuation > (
    SELECT AVG(Valuation) 
    FROM Property
);

-- 20. List citizens who have the newest vehicle
SELECT * FROM Citizen
WHERE CitizenID IN (
    SELECT OwnerID FROM Vehicle
    WHERE Year = (SELECT MAX(Year) FROM Vehicle)
);