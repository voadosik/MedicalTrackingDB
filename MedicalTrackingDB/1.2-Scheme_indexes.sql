USE MedicalTrackingDB;
GO

-- Foreign Key Indexes
CREATE INDEX IX_Diagnoses_PatientID ON Diagnoses(PatientID);
CREATE INDEX IX_Diagnoses_DiseaseID ON Diagnoses(DiseaseID);
CREATE INDEX IX_Diagnoses_DoctorID ON Diagnoses(DoctorID);
CREATE INDEX IX_PatientSymptoms_PatientID ON PatientSymptoms(PatientID);
CREATE INDEX IX_PatientSymptoms_SymptomID ON PatientSymptoms(SymptomID);
CREATE INDEX IX_TreatmentPlans_DiagnosisID ON TreatmentPlans(DiagnosisID);
CREATE INDEX IX_TreatmentPlans_TreatmentID ON TreatmentPlans(TreatmentID);
CREATE INDEX IX_TreatmentPlans_DoctorID ON TreatmentPlans(DoctorID);
CREATE INDEX IX_DiseaseSymptoms_DiseaseID ON DiseaseSymptoms(DiseaseID);
CREATE INDEX IX_DiseaseSymptoms_SymptomID ON DiseaseSymptoms(SymptomID);


-- Query performance
CREATE INDEX IX_Patients_Name ON Patients(LastName, FirstName);
CREATE INDEX IX_Doctors_Name ON Doctors(LastName, FirstName);
CREATE INDEX IX_Symptoms_Name ON Symptoms(SymptomName);
CREATE INDEX IX_Diseases_Name ON Diseases(DiseaseName);
CREATE INDEX IX_Treatments_Name ON Treatments(TreatmentName);
CREATE INDEX IX_PatientSymptoms_Status ON PatientSymptoms(CurrentStatus);
CREATE INDEX IX_TreatmentPlans_Status ON TreatmentPlans(Status);
CREATE INDEX IX_Diagnoses_Date ON Diagnoses(DiagnosisDate);
CREATE INDEX IX_TreatmentPlans_Dates ON TreatmentPlans(StartDate, EndDate);
CREATE INDEX IX_AuditLog_Date ON AuditLog(AuditDate);

CREATE INDEX IX_vActivePatientTreatments ON TreatmentPlans (Status)
INCLUDE (DiagnosisID, TreatmentID, DoctorID, StartDate);

CREATE INDEX IX_vPatientSymptomSummary ON PatientSymptoms (PatientID, SymptomID) 
INCLUDE (Severity, CurrentStatus, OnsetDate);

GO
