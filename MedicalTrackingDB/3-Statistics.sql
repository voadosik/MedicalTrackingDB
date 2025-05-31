
USE MedicalTrackingDB;
GO

-- Create statistics for all tables
UPDATE STATISTICS Patients;
UPDATE STATISTICS Symptoms;
UPDATE STATISTICS Diseases;
UPDATE STATISTICS Doctors;
UPDATE STATISTICS Treatments;
UPDATE STATISTICS Diagnoses;
UPDATE STATISTICS PatientSymptoms;
UPDATE STATISTICS TreatmentPlans;
UPDATE STATISTICS DiseaseSymptoms;

-- Create specific column statistics
CREATE STATISTICS STAT_Patients_Name ON Patients(FirstName, LastName) WITH FULLSCAN;
CREATE STATISTICS STAT_Symptoms_Name ON Symptoms(SymptomName) WITH FULLSCAN;
CREATE STATISTICS STAT_Diseases_Name ON Diseases(DiseaseName) WITH FULLSCAN;
GO
