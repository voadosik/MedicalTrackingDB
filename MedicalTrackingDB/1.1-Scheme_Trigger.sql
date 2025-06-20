USE MedicalTrackingDB;

GO
-- Symptom-Disease Relationship Trigger
CREATE TRIGGER TR_Diagnoses_SymptomCheck ON Diagnoses AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE d
        SET IsConfirmed = CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM DiseaseSymptoms ds 
                    JOIN PatientSymptoms ps ON ds.SymptomID = ps.SymptomID 
                    WHERE ds.DiseaseID = i.DiseaseID
                    AND ps.PatientID = i.PatientID
                    AND ds.IsPrimary = 1
                    AND ps.CurrentStatus = 'Active'
                ) THEN 1
                ELSE 0
            END
        FROM Diagnoses d
        INNER JOIN inserted i ON d.DiagnosisID = i.DiagnosisID;
        INSERT INTO AuditLog (TableName, Operation, RecordID, AuditMessage)
        SELECT 
            'Diagnoses', 
            'I', 
            CAST(i.DiagnosisID AS NVARCHAR(100)),
            'Diagnosis ' + CAST(i.DiagnosisID AS NVARCHAR) + 
            ' is unconfirmed due to missing primary symptoms for ' + d.DiseaseName
        FROM inserted i
        JOIN Diseases d ON i.DiseaseID = d.DiseaseID
        WHERE NOT EXISTS (
            SELECT 1 
            FROM DiseaseSymptoms ds 
            JOIN PatientSymptoms ps ON ds.SymptomID = ps.SymptomID 
            WHERE ds.DiseaseID = i.DiseaseID
            AND ps.PatientID = i.PatientID
            AND ds.IsPrimary = 1
            AND ps.CurrentStatus = 'Active'
        );
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog (TableName, Operation, RecordID, AuditMessage)
        VALUES ('Diagnoses', 'E', '5', 'Trigger error: ' + ERROR_MESSAGE());
    END CATCH
END;
GO

-- Concurrency control trigger for TreatmentPlans
CREATE TRIGGER TR_TreatmentPlans_Concurrency ON TreatmentPlans AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF UPDATE(LastUpdated)
        BEGIN
            RAISERROR('Concurrency conflict detected', 16, 1);
        END
        ELSE
        BEGIN
            UPDATE tp with (ROWLOCK)
            SET LastUpdated = SYSDATETIME()
            FROM TreatmentPlans tp
            INNER JOIN inserted i ON tp.TreatmentPlanID = i.TreatmentPlanID;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog (TableName, Operation, RecordID, AuditMessage)
        VALUES ('TreatmentPlans', 'E', '3', 'Concurrency error: ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO
