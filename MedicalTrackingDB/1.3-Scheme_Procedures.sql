USE MedicalTrackingDB;
GO

-- Procedure to register a new patient
CREATE PROCEDURE RegisterPatient
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DOB DATE,
    @Gender CHAR(1),
    @PhoneNumber VARCHAR(15) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Patients (FirstName, LastName, DOB, Gender, PhoneNumber, Email)
        VALUES (@FirstName, @LastName, @DOB, @Gender, @PhoneNumber, @Email);
        
        RETURN SCOPE_IDENTITY(); -- Return the new PatientID
    END TRY
    BEGIN CATCH
        THROW 50001, 'Error registering new patient', 1;
    END CATCH
END;
GO

CREATE PROCEDURE UpdatePatient
    @PatientID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @PhoneNumber VARCHAR(15) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE Patients WITH (ROWLOCK)
        SET FirstName = ISNULL(@FirstName, FirstName),
            LastName = ISNULL(@LastName, LastName),
            PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
            Email = ISNULL(@Email, Email)
        WHERE PatientID = @PatientID;
    END TRY
    BEGIN CATCH
        THROW 50012, 'Error updating patient information', 1;
    END CATCH
END;
GO


-- Procedure to add a new symptom for a patient
CREATE PROCEDURE AddPatientSymptom
    @PatientID INT,
    @SymptomID INT,
    @Severity TINYINT,
    @CurrentStatus NVARCHAR(20) = 'Active'
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Patients WHERE PatientID = @PatientID)
            THROW 50002, 'Patient does not exist', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Symptoms WHERE SymptomID = @SymptomID)
            THROW 50003, 'Symptom does not exist', 1;
            
        INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity, CurrentStatus)
        VALUES (@PatientID, @SymptomID, @Severity, @CurrentStatus);
        
        RETURN SCOPE_IDENTITY(); -- Return the new PatientSymptomID
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Procedure to create a new diagnosis
CREATE PROCEDURE CreateDiagnosis
    @PatientID INT,
    @DiseaseID INT,
    @DoctorID INT,
    @Severity TINYINT,
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate inputs
        IF NOT EXISTS (SELECT 1 FROM Patients WHERE PatientID = @PatientID)
            THROW 50004, 'Invalid PatientID', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Diseases WHERE DiseaseID = @DiseaseID)
            THROW 50005, 'Invalid DiseaseID', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Doctors WHERE DoctorID = @DoctorID)
            THROW 50006, 'Invalid DoctorID', 1;
            
        IF @Severity < 1 OR @Severity > 10
            THROW 50007, 'Severity must be between 1 and 10', 1;
            
        -- Create diagnosis
        INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity, Notes)
        VALUES (@PatientID, @DiseaseID, @DoctorID, @Severity, @Notes);
        
        COMMIT TRANSACTION;
        RETURN SCOPE_IDENTITY(); -- Return the new DiagnosisID
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Procedure to prescribe a treatment
CREATE PROCEDURE PrescribeTreatment
    @DiagnosisID INT,
    @TreatmentID INT,
    @DoctorID INT,
    @Dosage NVARCHAR(100),
    @Frequency NVARCHAR(100),
    @Status NVARCHAR(20) = 'Pending'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate inputs
        IF NOT EXISTS (SELECT 1 FROM Diagnoses WHERE DiagnosisID = @DiagnosisID)
            THROW 50008, 'Invalid DiagnosisID', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Treatments WHERE TreatmentID = @TreatmentID)
            THROW 50009, 'Invalid TreatmentID', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Doctors WHERE DoctorID = @DoctorID)
            THROW 50010, 'Invalid DoctorID', 1;
            
        -- Create treatment plan
        INSERT INTO TreatmentPlans (DiagnosisID, TreatmentID, DoctorID, Dosage, Frequency, Status)
        VALUES (@DiagnosisID, @TreatmentID, @DoctorID, @Dosage, @Frequency, @Status);
        
        COMMIT TRANSACTION;
        RETURN SCOPE_IDENTITY(); -- Return the new TreatmentPlanID
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE UpdateTreatmentPlan
    @TreatmentPlanID INT,
    @Status NVARCHAR(20) = NULL,
    @Dosage NVARCHAR(100) = NULL,
    @Frequency NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        UPDATE TreatmentPlans WITH (UPDLOCK, ROWLOCK)
        SET Status = ISNULL(@Status, Status),
            Dosage = ISNULL(@Dosage, Dosage),
            Frequency = ISNULL(@Frequency, Frequency)
        WHERE TreatmentPlanID = @TreatmentPlanID;
    END TRY
    BEGIN CATCH
        THROW 50013, 'Error updating treatment plan', 1;
    END CATCH
END;
GO
