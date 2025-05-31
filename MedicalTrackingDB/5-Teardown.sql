
USE MedicalTrackingDB;
GO

-- Drop views
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vActivePatientTreatments')
    DROP VIEW vActivePatientTreatments;
    
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vPatientSymptomSummary')
    DROP VIEW vPatientSymptomSummary;
    
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vDiseaseSymptomRelationships')
    DROP VIEW vDiseaseSymptomRelationships;
    
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vTreatmentEffectiveness')
    DROP VIEW vTreatmentEffectiveness;

IF EXISTS (SELECT * FROM sys.views WHERE name = 'vSymptomPrevalence')
    DROP VIEW vSymptomPrevalence;
    
-- Drop procedures
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'RegisterPatient')
    DROP PROCEDURE RegisterPatient;
    
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'AddPatientSymptom')
    DROP PROCEDURE AddPatientSymptom;
    
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'CreateDiagnosis')
    DROP PROCEDURE CreateDiagnosis;
    
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'PrescribeTreatment')
    DROP PROCEDURE PrescribeTreatment;

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'UpdatePatient')
    DROP PROCEDURE UpdatePatient;

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'UpdateTreatmentPlan')
    DROP PROCEDURE UpdateTreatmentPlan;


-- Drop tables (in reverse order of creation due to FK constraints)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'TreatmentPlans')
    DROP TABLE TreatmentPlans;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PatientSymptoms')
    DROP TABLE PatientSymptoms;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'DiseaseSymptoms')
    DROP TABLE DiseaseSymptoms;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Diagnoses')
    DROP TABLE Diagnoses;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Treatments')
    DROP TABLE Treatments;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Doctors')
    DROP TABLE Doctors;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Diseases')
    DROP TABLE Diseases;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Symptoms')
    DROP TABLE Symptoms;
    
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Patients')
    DROP TABLE Patients;

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
    DROP TABLE AuditLog;

GO