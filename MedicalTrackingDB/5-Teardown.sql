
USE MedicalTrackingDB;
GO

-- Drop views
DROP VIEW IF EXISTS vActivePatientTreatments;
DROP VIEW IF EXISTS vPatientSymptomSummary;
DROP VIEW IF EXISTS vDiseaseSymptomRelationships;
DROP VIEW IF EXISTS vTreatmentEffectiveness;
DROP VIEW IF EXISTS vSymptomPrevalence;
DROP VIEW IF EXISTS vUnconfirmedDiagnoses;
    
-- Drop procedures
DROP PROCEDURE IF EXISTS RegisterPatient;
DROP PROCEDURE IF EXISTS UpdatePatient;
DROP PROCEDURE IF EXISTS AddPatientSymptom;
DROP PROCEDURE IF EXISTS CreateDiagnosis;
DROP PROCEDURE IF EXISTS PrescribeTreatment;
DROP PROCEDURE IF EXISTS UpdateTreatmentPlan;
DROP PROCEDURE IF EXISTS ConfirmDiagnosis;

-- Drop triggers
DROP TRIGGER IF EXISTS TR_Diagnoses_SymptomCheck;
DROP TRIGGER IF EXISTS TR_TreatmentPlans_Concurrency;


-- Drop tables (in reverse order of creation due to FK constraints)
DROP TABLE IF EXISTS TreatmentPlans;
DROP TABLE IF EXISTS PatientSymptoms;
DROP TABLE IF EXISTS DiseaseSymptoms;
DROP TABLE IF EXISTS Diagnoses;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Diseases;
DROP TABLE IF EXISTS Symptoms;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS AuditLog;


GO