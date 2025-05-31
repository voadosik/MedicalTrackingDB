USE MedicalTrackingDB;
GO

BEGIN TRY
	BEGIN TRANSACTION;
	-- Insert sample patients
	INSERT INTO Patients (FirstName, LastName, DOB, Gender, PhoneNumber, Email)
	VALUES 
	('John', 'Smith', '1980-05-15', 'M', '555-123-4567', 'john.smith@example.com'),
	('Sarah', 'Johnson', '1975-11-22', 'F', '555-234-5678', 'sarah.j@example.com'),
	('Michael', 'Williams', '1990-03-10', 'M', '555-345-6789', 'michael.w@example.com');

	-- Insert sample symptoms
	INSERT INTO Symptoms (SymptomName, Description, BodySystem)
	VALUES 
	('Fever', 'Elevated body temperature', 'General'),
	('Headache', 'Pain in head or neck', 'Neurological'),
	('Cough', 'Expulsion of air from lungs', 'Respiratory'),
	('Fatigue', 'Feeling of tiredness', 'General'),
	('Shortness of breath', 'Difficulty breathing', 'Respiratory');

	-- Insert sample diseases
	INSERT INTO Diseases (DiseaseName, ICD11Code, Description)
	VALUES 
	('Influenza', '1E30', 'Viral infection of respiratory tract'),
	('Hypertension', 'BA00', 'High blood pressure'),
	('Diabetes Mellitus Type 2', '5A11', 'Chronic metabolic disorder'),
	('Asthma', 'CA23', 'Chronic inflammatory disease of airways');

	-- Insert sample doctors
	INSERT INTO Doctors (FirstName, LastName, Specialty, LicenseNumber)
	VALUES 
	('Robert', 'Brown', 'General Practitioner', 'GP12345'),
	('Emily', 'Davis', 'Cardiologist', 'CARD67890'),
	('David', 'Wilson', 'Endocrinologist', 'ENDO54321');

	-- Insert sample treatments
	INSERT INTO Treatments (TreatmentName, Description, TreatmentType)
	VALUES 
	('Ibuprofen', 'NSAID for pain and inflammation', 'Medication'),
	('Lisinopril', 'ACE inhibitor for hypertension', 'Medication'),
	('Metformin', 'Oral hypoglycemic agent', 'Medication'),
	('Inhaler', 'Bronchodilator for asthma', 'Medical Device'),
	('Physical Therapy', 'Exercise and movement therapy', 'Therapy');

	-- Link diseases to their common symptoms
	INSERT INTO DiseaseSymptoms (DiseaseID, SymptomID, IsPrimary)
	VALUES 
	(1, 1, 1), -- Influenza -> Fever
	(1, 3, 1), -- Influenza -> Cough
	(1, 4, 0), -- Influenza -> Fatigue (secondary)
	(2, 1, 0), -- Hypertension -> Fever (secondary)
	(4, 3, 1), -- Asthma -> Cough
	(4, 5, 1); -- Asthma -> Shortness of breath

	-- Insert sample patient symptoms
	INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity, CurrentStatus)
	VALUES 
	(1, 1, 7, 'Active'), -- John Smith has fever
	(1, 3, 5, 'Active'), -- John Smith has cough
	(2, 2, 8, 'Active'), -- Sarah Johnson has headache
	(3, 5, 6, 'Active'); -- Michael Williams has shortness of breath

	-- Insert sample diagnoses
	INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity, Notes)
	VALUES 
	(1, 1, 1, 6, 'Patient presents with flu-like symptoms'),
	(2, 2, 2, 5, 'Elevated blood pressure readings'),
	(3, 4, 1, 7, 'Wheezing and difficulty breathing');

	-- Insert sample treatment plans
	INSERT INTO TreatmentPlans (DiagnosisID, TreatmentID, DoctorID, Dosage, Frequency, Status)
	VALUES 
	(1, 1, 1, '400mg', 'Every 6 hours', 'Active'),
	(2, 2, 2, '10mg', 'Once daily', 'Active'),
	(3, 4, 1, '2 puffs', 'As needed', 'Active');

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK;
	THROW 50030, 'Error inserting test data', 1;
END CATCH
GO