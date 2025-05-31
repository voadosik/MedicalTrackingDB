USE MedicalTrackingDB;
GO

-- Create indexes for performance
CREATE INDEX IX_Diagnoses_PatientID ON Diagnoses(PatientID);
CREATE INDEX IX_Diagnoses_DiseaseID ON Diagnoses(DiseaseID);
CREATE INDEX IX_PatientSymptoms_PatientID ON PatientSymptoms(PatientID);
CREATE INDEX IX_PatientSymptoms_SymptomID ON PatientSymptoms(SymptomID);
CREATE INDEX IX_TreatmentPlans_DiagnosisID ON TreatmentPlans(DiagnosisID);
CREATE INDEX IX_TreatmentPlans_TreatmentID ON TreatmentPlans(TreatmentID);
CREATE INDEX IX_DiseaseSymptoms_DiseaseID ON DiseaseSymptoms(DiseaseID);
CREATE INDEX IX_DiseaseSymptoms_SymptomID ON DiseaseSymptoms(SymptomID);

GO
