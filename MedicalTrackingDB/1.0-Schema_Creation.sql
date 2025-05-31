/*
Medical Symptom & Treatment Tracking System
Author: Vladyslav Stashevskyi
Description: Creates tables, constraints, indexes for medical tracking system
*/

USE MedicalTrackingDB;



-- Patients table
CREATE TABLE Patients (
	PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    PhoneNumber VARCHAR(15),
    Email NVARCHAR(100),
    CONSTRAINT CHK_Patient_Age CHECK (DATEDIFF(YEAR,DOB, GETDATE()) BETWEEN 0 AND 117)
);


CREATE TABLE Symptoms (
    SymptomID INT IDENTITY(1,1) PRIMARY KEY,
    SymptomName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    BodySystem NVARCHAR(50)
);

CREATE TABLE Diseases (
    DiseaseID INT IDENTITY(1,1) PRIMARY KEY,
    DiseaseName NVARCHAR(100) NOT NULL,
    ICD11Code CHAR(10) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

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
    TreatmentType NVARCHAR(50) NOT NULL -- Medication, Therapy, Surgery, etc.
);

-- Diagnoses table (links patients to diseases)
CREATE TABLE Diagnoses (
    DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL FOREIGN KEY REFERENCES Patients(PatientID),
    DiseaseID INT NOT NULL FOREIGN KEY REFERENCES Diseases(DiseaseID),
    DoctorID INT NOT NULL FOREIGN KEY REFERENCES Doctors(DoctorID),
    DiagnosisDate DATETIME NOT NULL DEFAULT GETDATE(),
    Severity TINYINT NOT NULL CHECK (Severity BETWEEN 1 AND 10),
    Notes NVARCHAR(MAX)
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
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Active', 'Completed', 'Cancelled'))
);

-- DiseaseSymptoms table (standard symptoms for diseases)
CREATE TABLE DiseaseSymptoms (
    DiseaseID INT NOT NULL FOREIGN KEY REFERENCES Diseases(DiseaseID),
    SymptomID INT NOT NULL FOREIGN KEY REFERENCES Symptoms(SymptomID),
    IsPrimary BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (DiseaseID, SymptomID)
);

-- Add AuditLog table for trigger monitoring
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT NOT NULL,
    AuditMessage NVARCHAR(1000) NOT NULL,
    AuditDate DATETIME NOT NULL DEFAULT GETDATE()
);


