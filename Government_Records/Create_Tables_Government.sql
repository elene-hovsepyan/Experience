
-- Fixed and Normalized SQL for Government Records Database

CREATE TABLE AddressDict (
    AddressID INT PRIMARY KEY,
    Street VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode INT
);

CREATE TABLE Citizen (
    CitizenID INT PRIMARY KEY,
    AddressID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    NationalID VARCHAR(20) UNIQUE,
    FOREIGN KEY (AddressID) REFERENCES AddressDict(AddressID)
);

CREATE TABLE GovernmentDept (
    DeptID INT PRIMARY KEY,
    LocationID INT,
    AgencyName VARCHAR(100),
    HeadEmployeeID INT,
    FOREIGN KEY (LocationID) REFERENCES AddressDict(AddressID)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    CitizenID INT,
    DeptID INT,
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    FOREIGN KEY (DeptID) REFERENCES GovernmentDept(DeptID),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID)
);

CREATE TABLE PermitDict (
    PermitTypeID INT PRIMARY KEY,
    PermitType VARCHAR(50),
    Description VARCHAR(100)
);

CREATE TABLE Permit (
    PermitID INT PRIMARY KEY,
    PermitTypeID INT,
    IssueDate DATE,
    ExpiryDate DATE,
    Status VARCHAR(20),
    CitizenID INT,
    FOREIGN KEY (PermitTypeID) REFERENCES PermitDict(PermitTypeID),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID)
);

CREATE TABLE Facility (
    FacilityID INT PRIMARY KEY,
    AddressID INT,
    Name VARCHAR(50),
    Type VARCHAR(50),
    FOREIGN KEY (AddressID) REFERENCES AddressDict(AddressID)
);

CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    DeptID INT,
    Name VARCHAR(50),
    Description VARCHAR(100),
    FOREIGN KEY (DeptID) REFERENCES GovernmentDept(DeptID)
);

CREATE TABLE ServiceRequest (
    RequestID INT PRIMARY KEY,
    CitizenID INT,
    ServiceID INT,
    RequestDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);

CREATE TABLE TaxRecord (
    TaxID INT PRIMARY KEY,
    CitizenID INT,
    Year INT,
    Income INT,
    TaxPaid INT,
    Status VARCHAR(50),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID)
);

CREATE TABLE Property (
    PropertyID INT PRIMARY KEY,
    OwnerID INT,
    AddressID INT,
    Type VARCHAR(50),
    Valuation INT,
    FOREIGN KEY (OwnerID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (AddressID) REFERENCES AddressDict(AddressID)
);

CREATE TABLE Vehicle (
    VehicleID INT PRIMARY KEY,
    OwnerID INT,
    PlateNumber VARCHAR(20),
    Make VARCHAR(50),
    Model VARCHAR(50),
    Year INT,
    FOREIGN KEY (OwnerID) REFERENCES Citizen(CitizenID)
);

CREATE TABLE LicenseDict (
    LicenseTypeID INT PRIMARY KEY,
    LicenseType VARCHAR(50),
    Description VARCHAR(100)
);

CREATE TABLE License (
    LicenseID INT PRIMARY KEY,
    CitizenID INT,
    LicenseTypeID INT,
    IssueDate DATE,
    ExpiryDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (LicenseTypeID) REFERENCES LicenseDict(LicenseTypeID)
);

CREATE TABLE CrimeRecord (
    RecordID INT PRIMARY KEY,
    CitizenID INT,
    OfficerID INT,
    Date DATE,
    Description VARCHAR(100),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (OfficerID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Election (
    ElectionID INT PRIMARY KEY,
    Year INT,
    Type VARCHAR(20),
    Region VARCHAR(50)
);

CREATE TABLE Vote (
    VoteID INT PRIMARY KEY,
    CitizenID INT,
    ElectionID INT,
    VoteTime DATETIME,
    CandidateVoted VARCHAR(50),
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (ElectionID) REFERENCES Election(ElectionID)
);
