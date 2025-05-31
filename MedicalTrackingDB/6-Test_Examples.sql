

-- MEDICAL TRACKING SYSTEM TESTS


USE MedicalTrackingDB;
GO


-- View Tests
-----------------------

-- View: Active Patient Treatments
SELECT * FROM vActivePatientTreatments;

-- View: Patient Symptom Summary
-- Lists all patients with their reported symptoms and status
SELECT * FROM vPatientSymptomSummary;

-- View: Disease-Symptom Relationships
-- Shows standard symptoms associated with each disease
SELECT * FROM vDiseaseSymptomRelationships;

-- View: Treatment Effectiveness
-- Displays treatment success rates for completed cases
SELECT * FROM vTreatmentEffectiveness;

-- View: Symptom Prevalence
-- Shows how common each symptom is across patients
SELECT * FROM vSymptomPrevalence;

-- View: Unconfirmed Diagnoses
-- Lists diagnoses needing symptom verification
SELECT * FROM vUnconfirmedDiagnoses;
GO

------------------------------
-- Procedure Tests
------------------------------

-- Test: Patient Registration
DECLARE @NewPatientID INT;
EXEC RegisterPatient 
    @FirstName = 'Test', 
    @LastName = 'User', 
    @DOB = '1990-01-01',
    @Gender = 'M',
    @PatientID = @NewPatientID OUTPUT;
SELECT * FROM Patients WHERE PatientID = @NewPatientID;

-- Test: Update Patient Information
EXEC UpdatePatient 
    @PatientID = @NewPatientID,
    @PhoneNumber = '111-TEST-123';
SELECT * FROM Patients WHERE PatientID = @NewPatientID;

-- Test: Add Patient Symptom
DECLARE @SymptomID INT = (SELECT TOP 1 SymptomID FROM Symptoms);
EXEC AddPatientSymptom 
    @PatientID = @NewPatientID,
    @SymptomID = @SymptomID,
    @Severity = 5;
SELECT * FROM vPatientSymptomSummary WHERE PatientID = @NewPatientID;

-- Test: Create Diagnosis
DECLARE @DiseaseID INT = (SELECT TOP 1 DiseaseID FROM Diseases);
DECLARE @DoctorID INT = (SELECT TOP 1 DoctorID FROM Doctors);
DECLARE @DiagnosisID INT;

EXEC CreateDiagnosis 
    @PatientID = @NewPatientID,
    @DiseaseID = @DiseaseID,
    @DoctorID = @DoctorID,
    @Severity = 6,
    @DiagnosisID = @DiagnosisID OUTPUT;
    
SELECT * FROM Diagnoses WHERE DiagnosisID = @DiagnosisID;

-- Test: Prescribe Treatment
DECLARE @TreatmentID INT = (SELECT TOP 1 TreatmentID FROM Treatments);
DECLARE @TreatmentPlanID INT;

EXEC PrescribeTreatment 
    @DiagnosisID = @DiagnosisID,
    @TreatmentID = @TreatmentID,
    @DoctorID = @DoctorID,
    @Status = 'Active',
    @Dosage = '10',
    @Frequency = 'Once a day',
    @TreatmentPlanID = @TreatmentPlanID OUTPUT;
    
SELECT * FROM TreatmentPlans WHERE TreatmentPlanID = @TreatmentPlanID;

-- Test: Update Treatment Plan
EXEC UpdateTreatmentPlan 
    @TreatmentPlanID = @TreatmentPlanID,
    @Status = 'Completed';
SELECT * FROM TreatmentPlans WHERE TreatmentPlanID = @TreatmentPlanID;

-- Test: Confirm Diagnosis
EXEC ConfirmDiagnosis @DiagnosisID = @DiagnosisID, @DoctorID = @DoctorID;
SELECT * FROM Diagnoses WHERE DiagnosisID = @DiagnosisID;
GO

-------------------------------
-- Trigger Tests 
-------------------------------

DECLARE @TestPatient INT, @TestDisease INT, @TestDoctor INT, @TestDiag INT, @TestTreatmentPlanID INT;
DECLARE @TreatmentPlanID INT;

-- Test: Symptom-Disease Relationship Check

-- Create test patient without symptoms
EXEC RegisterPatient 
    @FirstName = 'Trigger', 
    @LastName = 'Test', 
    @DOB = '2000-01-01',
    @Gender = 'F',
    @PatientID = @TestPatient OUTPUT;

SET @TestDisease = (SELECT TOP 1 DiseaseID FROM Diseases);
SET @TestDoctor = (SELECT TOP 1 DoctorID FROM Doctors);

-- Create diagnosis that should trigger warning
EXEC CreateDiagnosis 
    @PatientID = @TestPatient,
    @DiseaseID = @TestDisease,
    @DoctorID = @TestDoctor,
    @Severity = 5,
    @DiagnosisID = @TestDiag OUTPUT;

-- Check audit log for warning
SELECT * FROM AuditLog 
WHERE TableName = 'Diagnoses' 
AND RecordID = CAST(@TestDiag AS NVARCHAR(100));

-- Check diagnosis confirmation status
-- Diagnosis should be unconfirmed
SELECT DiagnosisID, IsConfirmed FROM Diagnoses WHERE DiagnosisID = @TestDiag;

-- Test: Concurrency Trigger
BEGIN TRY
    -- First update (should succeed and update timestamp)
    UPDATE TreatmentPlans 
    SET Status = 'Active'
    WHERE TreatmentPlanID = @TestTreatmentPlanID;
    SELECT LastUpdated FROM TreatmentPlans 
    WHERE TreatmentPlanID = @TestTreatmentPlanID;
    
    -- Check audit log for automatic timestamp update
    SELECT * FROM AuditLog 
    WHERE TableName = 'TreatmentPlans' 
    AND RecordID = CAST(@TestTreatmentPlanID AS NVARCHAR(100));
    
    -- Attempt to manually update timestamp
    BEGIN TRY
        UPDATE TreatmentPlans 
        SET LastUpdated = '1900-01-01'  -- This should trigger error
        WHERE TreatmentPlanID = @TestTreatmentPlanID;
    END TRY
    BEGIN CATCH
        PRINT 'Expected: ' + ERROR_MESSAGE();
    END CATCH
END TRY
BEGIN CATCH
    THROW;
END CATCH

------------------------------
-- Constraint Tests
------------------------------
-- Test: Patient Age Constraint
BEGIN TRY
    INSERT INTO Patients (FirstName, LastName, DOB, Gender)
    VALUES ('Invalid', 'Age', '1800-01-01', 'M');
END TRY
BEGIN CATCH
    PRINT 'Expected: ' + ERROR_MESSAGE();
END CATCH

-- Test: Symptom Severity Constraint
BEGIN TRY
    INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity)
    VALUES (1, 1, 11);  -- Invalid severity
END TRY
BEGIN CATCH
    PRINT 'Expected: ' + ERROR_MESSAGE();
END CATCH

-- Test: Unique ICD11 Code Constraint
BEGIN TRY
    DECLARE @ExistingCode CHAR(10) = (SELECT TOP 1 ICD11Code FROM Diseases);
    INSERT INTO Diseases (DiseaseName, ICD11Code)
    VALUES ('Duplicate', @ExistingCode);
END TRY
BEGIN CATCH
    PRINT 'Expected: ' + ERROR_MESSAGE();
END CATCH
GO

