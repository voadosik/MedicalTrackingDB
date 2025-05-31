USE MedicalTrackingDB;
GO


-- View for active patient treatments
CREATE VIEW vActivePatientTreatments AS
SELECT 
    tp.TreatmentPlanID, 
    di.DiagnosisID, 
    p.PatientID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    d.DiseaseName,
    t.TreatmentName,
    doc.FirstName + ' ' + doc.LastName + ' ' AS DoctorName,
    tp.StartDate,
    tp.Status
FROM TreatmentPlans tp
JOIN Diagnoses di ON tp.DiagnosisID = di.DiagnosisID
JOIN Patients p ON di.PatientID = p.PatientID
JOIN Diseases d ON di.DiseaseID = d.DiseaseID
JOIN Treatments t ON tp.TreatmentID = t.TreatmentID
JOIN Doctors doc ON tp.DoctorID = doc.DoctorID
WHERE tp.Status = 'Active';
GO

-- View for patient symptom summaries
CREATE VIEW vPatientSymptomSummary AS
SELECT 
    p.PatientID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    s.SymptomName,
    ps.Severity,
    ps.CurrentStatus,
    ps.OnsetDate
FROM Patients p
INNER JOIN PatientSymptoms ps ON p.PatientID = ps.PatientID
INNER JOIN Symptoms s ON ps.SymptomID = s.SymptomID;
GO

-- View for disease-symptom relationships
CREATE VIEW vDiseaseSymptomRelationships AS
SELECT 
    d.DiseaseName,
    d.ICD11Code,
    s.SymptomName,
    s.BodySystem,
    CASE WHEN ds.IsPrimary = 1 THEN 'Primary' ELSE 'Secondary' END AS SymptomType
FROM Diseases d
INNER JOIN DiseaseSymptoms ds ON d.DiseaseID = ds.DiseaseID
INNER JOIN Symptoms s ON ds.SymptomID = s.SymptomID;
GO

-- View for treatment effectiveness (requires completion data)
CREATE VIEW vTreatmentEffectiveness AS
SELECT 
    d.DiseaseName,
    t.TreatmentName,
    AVG(di.Severity) AS AvgInitialSeverity,
    COUNT(*) AS CasesTreated,
    SUM(CASE WHEN ps.CurrentStatus = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedCases
FROM Diagnoses di
INNER JOIN Diseases d ON di.DiseaseID = d.DiseaseID
INNER JOIN TreatmentPlans tp ON di.DiagnosisID = tp.DiagnosisID
INNER JOIN Treatments t ON tp.TreatmentID = t.TreatmentID
LEFT JOIN PatientSymptoms ps ON di.PatientID = ps.PatientID
WHERE tp.Status = 'Completed'
GROUP BY d.DiseaseName, t.TreatmentName;
GO

-- Symptom Prevalence
CREATE VIEW vSymptomPrevalence AS
SELECT 
    s.SymptomName,
    COUNT(ps.PatientSymptomID) AS PatientCount,
    AVG(ps.Severity) AS AvgSeverity
FROM Symptoms s
LEFT JOIN PatientSymptoms ps ON s.SymptomID = ps.SymptomID
GROUP BY s.SymptomName;
GO


-- Unconfirmed diagnoses
CREATE VIEW vUnconfirmedDiagnoses AS
SELECT
    d.DiagnosisID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    dis.DiseaseName,
    doc.FirstName + ' ' + doc.LastName AS DoctorName,
    d.DiagnosisDate
FROM Diagnoses d
INNER JOIN Patients p ON d.PatientID = p.PatientID
INNER JOIN Diseases dis ON d.DiseaseID = dis.DiseaseID
INNER JOIN Doctors doc ON d.DoctorID = doc.DoctorID
WHERE d.isConfirmed = 0;
GO
