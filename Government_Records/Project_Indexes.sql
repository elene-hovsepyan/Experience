CREATE INDEX idx_citizen_nationalid ON Citizen(NationalID);
CREATE INDEX idx_vehicle_owner ON Vehicle(OwnerID);
CREATE INDEX idx_license_type ON License(LicenseTypeID);
CREATE INDEX idx_taxrecord_citizen ON TaxRecord(CitizenID);
CREATE INDEX idx_employee_dept ON Employee(DeptID);
CREATE INDEX idx_permit_citizen ON Permit(CitizenID);