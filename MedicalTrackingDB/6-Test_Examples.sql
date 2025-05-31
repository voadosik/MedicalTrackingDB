
USE MedicalTrackingDB;
GO

-- Test 1: Register a new patient
DECLARE @NewPatientID INT;
EXEC @NewPatientID = RegisterPatient 
    @FirstName = 'Jennifer',
    @LastName = 'Adams',
    @DOB = '1988-07-25',
    @Gender = 'F',
    @PhoneNumber = '555-987-6543',
    @Email = 'jennifer.a@example.com';
    
PRINT 'New Patient ID: ' + CAST(@NewPatientID AS VARCHAR(10));
SELECT * FROM Patients WHERE PatientID = @NewPatientID;
GO

-- Test 2: Add symptoms to patient
DECLARE @PatientID INT = 1; -- John Smith
DECLARE @SymptomID INT;

-- Get symptom ID for Fever
SELECT @SymptomID = SymptomID FROM Symptoms WHERE SymptomName = 'Fever';

-- Try to add symptom with invalid severity (should fail)
BEGIN TRY
    EXEC AddPatientSymptom 
        @PatientID = @PatientID,
        @SymptomID = @SymptomID,
        @Severity = 11; -- Invalid severity
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

-- Add symptom correctly
EXEC AddPatientSymptom 
    @PatientID = @PatientID,
    @SymptomID = @SymptomID,
    @Severity = 7;
    
SELECT * FROM vPatientSymptomSummary WHERE PatientID = @PatientID;
GO

-- Test 3: Create diagnosis and treatment plan
DECLARE @DiagnosisID INT;
DECLARE @TreatmentPlanID INT;

-- Create diagnosis
EXEC @DiagnosisID = CreateDiagnosis
    @PatientID = 1,
    @DiseaseID = 1, -- Influenza
    @DoctorID = 1, -- Dr. Brown
    @Severity = 6,
    @Notes = 'Patient shows classic flu symptoms';
    
PRINT 'New Diagnosis ID: ' + CAST(@DiagnosisID AS VARCHAR(10));

-- Prescribe treatment
EXEC @TreatmentPlanID = PrescribeTreatment
    @DiagnosisID = @DiagnosisID,
    @TreatmentID = 1, -- Ibuprofen
    @DoctorID = 1,
    @Dosage = '400mg',
    @Frequency = 'Every 6 hours';
    
PRINT 'New Treatment Plan ID: ' + CAST(@TreatmentPlanID AS VARCHAR(10));

-- View active treatments
SELECT * FROM vActivePatientTreatments WHERE PatientID = 1;
GO

-- Test 4: View disease-symptom relationships
SELECT * FROM vDiseaseSymptomRelationships WHERE DiseaseName = 'Influenza';
GO

-- Test 5: Test constraints
-- Try to add patient with invalid age (should fail)
BEGIN TRY
    INSERT INTO Patients (FirstName, LastName, DOB, Gender)
    VALUES ('Invalid', 'Patient', '1900-01-01', 'M');
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

-- Try to add diagnosis with invalid severity (should fail)
BEGIN TRY
    INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity)
    VALUES (1, 1, 1, 11);
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test trigger functionality
BEGIN TRY
    -- Create diagnosis without matching symptoms (should trigger warning)
    EXEC CreateDiagnosis
        @PatientID = 3, -- Michael Williams (has shortness of breath)
        @DiseaseID = 1, -- Influenza (requires fever/cough)
        @DoctorID = 1,
        @Severity = 5;
    
    -- Check audit log
    SELECT * FROM AuditLog WHERE TableName = 'Diagnoses';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test concurrency handling
BEGIN TRANSACTION;
    EXEC UpdateTreatmentPlan @TreatmentPlanID = 1, @Status = 'Completed';
    -- Simulate concurrent update
    UPDATE TreatmentPlans SET Status = 'Cancelled' WHERE TreatmentPlanID = 1; -- Should block
COMMIT TRANSACTION;