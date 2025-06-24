USE MedicalTrackingDB;
GO

-- Procedure to register a new patient
CREATE PROCEDURE RegisterPatient
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DOB DATE,
    @Gender CHAR(1),
    @PhoneNumber VARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @PatientID INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Patients (FirstName, LastName, DOB, Gender, PhoneNumber, Email)
        VALUES (@FirstName, @LastName, @DOB, @Gender, @PhoneNumber, @Email);

        SET @PatientID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW 50001, 'Error registering new patient', 1;
    END CATCH
END;
GO

CREATE PROCEDURE UpdatePatient
    @PatientID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @DOB DATE = NULL,
    @GENDER CHAR(1) = NULL,
    @PhoneNumber VARCHAR(15) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Patients with (ROWLOCK)
        SET
            FirstName = ISNULL(@FirstName, FirstName),
            LastName = ISNULL(@LastName, LastName),
            DOB = ISNULL(@DOB, DOB),
            Gender = ISNULL(@GENDER, Gender),
            PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
            Email = ISNULL(@Email, Email)
        WHERE PatientID = @PatientID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
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
        BEGIN TRANSACTION;
            
        INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity, CurrentStatus)
        VALUES (@PatientID, @SymptomID, @Severity, @CurrentStatus);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW 50025, 'Error adding new symptom for a patient', 1;
    END CATCH
END;
GO

-- Procedure to create a new diagnosis
CREATE PROCEDURE CreateDiagnosis
    @PatientID INT,
    @DiseaseID INT,
    @DoctorID INT,
    @Severity TINYINT,
    @Notes NVARCHAR(MAX) = NULL,
    @DiagnosisID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity, Notes)
        VALUES (@PatientID, @DiseaseID, @DoctorID, @Severity, @Notes);
        
        SET @DiagnosisID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW 50026, 'Error creating a new diagnosis', 1;
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
    @Status NVARCHAR(20) = 'Pending',
    @TreatmentPlanID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO TreatmentPlans (DiagnosisID, TreatmentID, DoctorID, Dosage, Frequency, Status)
        VALUES (@DiagnosisID, @TreatmentID, @DoctorID, @Dosage, @Frequency, @Status);
        
        SET @TreatmentPlanID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW 50027, 'Error prescribing a treatment', 1;
    END CATCH
END;
GO

CREATE PROCEDURE UpdateTreatmentPlan
    @TreatmentPlanID INT,
    @Status NVARCHAR(20) = NULL,
    @Dosage NVARCHAR(100) = NULL,
    @Frequency NVARCHAR(100) = NULL,
    @OriginalRowVersion ROWVERSION
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TreatmentPlans WITH (UPDLOCK, ROWLOCK)
        SET 
            Status = ISNULL(@Status, Status),
            Dosage = ISNULL(@Dosage, Dosage),
            Frequency = ISNULL(@Frequency, Frequency)
        WHERE TreatmentPlanID = @TreatmentPlanID
        AND RowVersion = @OriginalRowVersion; 
        
        IF @@ROWCOUNT = 0
        BEGIN
            IF EXISTS(SELECT 1 FROM TreatmentPlans WHERE TreatmentPlanID = @TreatmentPlanID)
                THROW 50500, 'Data was modified by another user', 1;
            ELSE
                THROW 50501, 'Record not found', 1;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE ConfirmDiagnosis
    @DiagnosisID INT,
    @DoctorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1 
            FROM Diagnoses 
            WHERE DiagnosisID = @DiagnosisID 
            AND DoctorID = @DoctorID
        )
        
        UPDATE d with (ROWLOCK)
        SET IsConfirmed = 1
        FROM Diagnoses d
        WHERE d.DiagnosisID = @DiagnosisID

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW 50027, 'Error confirming diagnosis', 1;
    END CATCH
END;
GO

