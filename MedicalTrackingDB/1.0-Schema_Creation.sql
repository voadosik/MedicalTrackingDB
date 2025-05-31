/*
Medical Symptom & Treatment Tracking System
==========================================

Author: Vladyslav Stashevskyi
Description: Creates core database structure for medical symptom and treatment tracking

Overiview:
---------
Database supports a medical practice in tracking patient symptoms, diagnosing diseases, prescribing treatments, 
and monitoring treatment effectiveness. 

Entities:

Patients
- Demographics: Name, DOB(Date of birth), gender, contact info
- Age validation (0-117 years)

Symptoms
- Name, description, body system
- Severity scale (1-10) for symptom tracking

Diseases
- Name, ICD-11 code, description
- Unique ICD-11 codes for billing/reporting

Doctors
- Name, specialty, license number
- License verification for treatment authority

Treatments
- Name, type (medication/therapy/surgery), instructions
- Dosage and frequency specifications

Key features:
- Patient registration
- Medical history of a patient
- Symptom cayalog with severity track
- Diseases catalog with ICD-11 codes
- Management of doctors
- Treatment plans
- Validation of symptom-disease relationship
- Audit logging for critical operations on the database(triggers)

System contains 9 core tables maintaining relationships between:
- Patients and Symptoms (PatientSymptoms table)
- Patients and Diseases (Diagnoses table)
- Diseases and Symptoms (DiseaseSymptoms table)
- Diagnoses and Treatments (TreatmentPlans table)

Workflow management:
Diagnosis:
- Symptom recording: Patient reports symptoms (onset, severity, status)
- Creation: Doctor assesses symptoms, disease diagnosis
- Validation: disease-symptom consistency
- Confirmation: Doctor verifies diagnosis after review

Treatment lifecycle:
- Prescription: Doctor creates treatment plan for some diagnosis
- Status: Pending, Active, Completed/Cancelled
- Effectiveness: symptom cure tracking

Views:

Patients:
- Active treatments View: Current plans with doctor/disease info
- Symptom summary: All symptoms with severity/status

Clinical reports:
- Treatment effectiveness: Outcomes by disease/treatment
- Symptom prevalence: severity across population
- Unconfirmed diagnoses: requiring verification

Administration:
- Patient Registration
- Medical Catalogs: symptoms/diseases/treatments CRUD

*/

USE MedicalTrackingDB;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- Patients table
    CREATE TABLE Patients (
	    PatientID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        DOB DATE NOT NULL,
        Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F', 'O')),
        PhoneNumber VARCHAR(20),
        Email NVARCHAR(100),
        CONSTRAINT CHK_Patient_Age CHECK (DATEDIFF(YEAR,DOB, GETDATE()) BETWEEN 0 AND 117)
    );

    -- Symptoms table
    CREATE TABLE Symptoms (
        SymptomID INT IDENTITY(1,1) PRIMARY KEY,
        SymptomName NVARCHAR(100) NOT NULL UNIQUE,
        Description NVARCHAR(500),
        BodySystem NVARCHAR(50)
    );

    -- Diseases table
    CREATE TABLE Diseases (
        DiseaseID INT IDENTITY(1,1) PRIMARY KEY,
        DiseaseName NVARCHAR(100) NOT NULL,
        ICD11Code CHAR(10) NOT NULL UNIQUE,
        Description NVARCHAR(500)
    );

    -- Doctors table
    CREATE TABLE Doctors (
        DoctorID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Specialty NVARCHAR(100) NOT NULL,
        LicenseNumber NVARCHAR(50) NOT NULL UNIQUE
    );

    -- Treatments table
    CREATE TABLE Treatments (
        TreatmentID INT IDENTITY(1,1) PRIMARY KEY,
        TreatmentName NVARCHAR(100) NOT NULL,
        Description NVARCHAR(MAX),
        TreatmentType NVARCHAR(50) NOT NULL
    );

    -- Diagnoses table (links patients to diseases)
    CREATE TABLE Diagnoses (
        DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
        PatientID INT NOT NULL FOREIGN KEY REFERENCES Patients(PatientID),
        DiseaseID INT NOT NULL FOREIGN KEY REFERENCES Diseases(DiseaseID),
        DoctorID INT NOT NULL FOREIGN KEY REFERENCES Doctors(DoctorID),
        DiagnosisDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        Severity TINYINT NOT NULL CHECK (Severity BETWEEN 1 AND 10),
        Notes NVARCHAR(MAX),
        IsConfirmed BIT NOT NULL DEFAULT 0 
    );

    -- PatientSymptoms table (links patients to symptoms)
    CREATE TABLE PatientSymptoms (
        PatientSymptomID INT IDENTITY(1,1) PRIMARY KEY,
        PatientID INT NOT NULL FOREIGN KEY REFERENCES Patients(PatientID),
        SymptomID INT NOT NULL FOREIGN KEY REFERENCES Symptoms(SymptomID),
        OnsetDate DATETIME NOT NULL DEFAULT GETDATE(),
        Severity TINYINT NOT NULL CHECK (Severity BETWEEN 1 AND 10),
        CurrentStatus NVARCHAR(20) CHECK (CurrentStatus IN ('Active', 'Resolved', 'Chronic'))
    );

    -- TreatmentPlans table (links diagnoses to treatments)
    CREATE TABLE TreatmentPlans (
        TreatmentPlanID INT IDENTITY(1,1) PRIMARY KEY,
        DiagnosisID INT NOT NULL FOREIGN KEY REFERENCES Diagnoses(DiagnosisID),
        TreatmentID INT NOT NULL FOREIGN KEY REFERENCES Treatments(TreatmentID),
        DoctorID INT NOT NULL FOREIGN KEY REFERENCES Doctors(DoctorID),
        StartDate DATETIME NOT NULL DEFAULT GETDATE(),
        EndDate DATETIME,
        Dosage NVARCHAR(100),
        Frequency NVARCHAR(100),
        Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Active', 'Completed', 'Cancelled')),
        LastUpdated DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );

    -- DiseaseSymptoms table (standard symptoms for diseases)
    CREATE TABLE DiseaseSymptoms (
        DiseaseID INT NOT NULL FOREIGN KEY REFERENCES Diseases(DiseaseID),
        SymptomID INT NOT NULL FOREIGN KEY REFERENCES Symptoms(SymptomID),
        IsPrimary BIT NOT NULL DEFAULT 1,
        PRIMARY KEY (DiseaseID, SymptomID)
    );

    -- AuditLog table
    CREATE TABLE AuditLog (
        AuditID INT IDENTITY(1,1) PRIMARY KEY,
        TableName NVARCHAR(100) NOT NULL,
        Operation CHAR(1) NOT NULL CHECK(Operation IN ('I','U','D')),
        RecordID NVARCHAR(100) NOT NULL,
        AuditMessage NVARCHAR(1000) NOT NULL,
        AuditDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        UserName NVARCHAR(128) NOT NULL DEFAULT SUSER_SNAME()
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
END CATCH
GO
