USE MedicalTrackingDB;

GO
-- Symptom-Disease Relationship Trigger
CREATE TRIGGER TR_Diagnoses_SymptomCheck ON Diagnoses AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO AuditLog (TableName, RecordID, AuditMessage)
    SELECT 'Diagnoses', i.DiagnosisID,
           'Warning: No matching primary symptoms recorded for ' + d.DiseaseName
    FROM inserted i
    JOIN Diseases d ON i.DiseaseID = d.DiseaseID
    WHERE NOT EXISTS (
        SELECT 1 
        FROM DiseaseSymptoms ds 
        JOIN PatientSymptoms ps ON ds.SymptomID = ps.SymptomID 
        WHERE ds.DiseaseID = i.DiseaseID
        AND ps.PatientID = i.PatientID
        AND ds.IsPrimary = 1
    );
END;
GO