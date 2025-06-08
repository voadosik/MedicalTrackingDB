USE MedicalTrackingDB;
GO

INSERT INTO Patients (FirstName, LastName, DOB, Gender, PhoneNumber, Email)
VALUES 
('John', 'Doe', '1990-10-11', 'M', '+420608264888', 'john124243@gmail.com'),
('Lily', 'Smith', '1985-10-12', 'F', '+420608233111', 'smith124@gmail.com'),
('James', 'Brown', '1975-10-10', 'M', '+420608264000', 'james.brown@gmail.com'),
('Kamala', 'Harris', '1980-11-11', 'F', '+420608274088', 'kamala1111@gmail.com'),
('Robert', 'Kubica', '1995-12-21', 'M', '+420608233377', 'kubica@yahoo.com');

INSERT INTO Symptoms (SymptomName, Description, BodySystem)
VALUES 
('Fever', 'Elevated body temperature above 38°C', 'General'),
('Cough', 'Expulsion of air from lungs with characteristic sound', 'Respiratory'),
('Headache', 'Pain in any region of the head', 'Neurological'),
('Sore throat', 'Pain, scratchiness or irritation of the throat', 'ENT'),
('Fatigue', 'Persistent feeling of tiredness or weakness', 'General'),
('Shortness of breath', 'Difficulty breathing or feeling breathless', 'Respiratory'),
('Diarrhea', 'Loose, watery bowel movements occurring more frequently', 'Gastrointestinal'),
('Muscle pain', 'Aching or pain in muscles', 'Musculoskeletal'),
('Loss of smell', 'Reduced or absent ability to detect odors', 'Neurological');

INSERT INTO Diseases (DiseaseName, ICD11Code, Description)
VALUES
('Influenza', '1E30', 'Viral respiratory infection causing fever, cough and body aches'),
('Migraine', '8A80', 'Neurological disorder characterized by recurrent headaches'),
('COVID-19', 'RA01', 'Respiratory illness caused by SARS-CoV-2 coronavirus'),
('Asthma', 'CA23', 'Chronic inflammatory disease of the airways'),
('Hypertension', 'BA00', 'Elevated systemic arterial blood pressure'),
('Diabetes Mellitus', '5A10', 'Metabolic disorder characterized by high blood sugar'),
('Gastroenteritis', '1A40', 'Inflammation of the gastrointestinal tract'),
('Allergic Reaction', '4A84', 'Immune response to a foreign substance'),
('Pneumonia', 'CA40', 'Inflammatory condition of the lung primarily affecting alveoli');

INSERT INTO Doctors (FirstName, LastName, Specialty, LicenseNumber)
VALUES
('Robert', 'Johnson', 'General Practitioner', 'ID-12345'),
('Emily', 'Williams', 'Neurologist', 'ID-67890'),
('Michael', 'Chen', 'Infectious Disease', 'ID-54321'),
('Sarah', 'Davis', 'Pulmonologist', 'ID-09876'),
('David', 'Brown', 'Cardiologist', 'ID-11223'),
('Jennifer', 'Wilson', 'Endocrinologist', 'ID-33445'),
('James', 'Miller', 'Gastroenterologist', 'ID-55667'),
('Lisa', 'Garcia', 'Allergist', 'ID-77889'),
('Thomas', 'Taylor', 'Rheumatologist', 'ID-99990');

INSERT INTO Treatments (TreatmentName, Description, TreatmentType)
VALUES
('Oseltamivir', 'Neuraminidase inhibitor for influenza', 'Medication'),
('Ibuprofen', 'NSAID for pain and inflammation', 'Medication'),
('Remdesivir', 'Antiviral medication for COVID-19', 'Medication'),
('Albuterol Inhaler', 'Short-acting bronchodilator', 'Medical Device'),
('Lisinopril', 'ACE inhibitor for hypertension', 'Medication'),
('Metformin', 'Biguanide antidiabetic medication', 'Medication'),
('Oral Rehydration Solution', 'Electrolyte replacement therapy', 'Fluid Therapy'),
('Epinephrine Auto-injector', 'Emergency treatment for anaphylaxis', 'Medical Device'),
('Naproxen', 'NSAID for pain and inflammation', 'Medication'),
('Amoxicillin', 'Penicillin antibiotic for bacterial infections', 'Medication');

INSERT INTO DiseaseSymptoms (DiseaseID, SymptomID, IsPrimary)
VALUES
(1, 1, 1), (1, 2, 1), 
(1, 5, 1), (1, 3, 0),
(2, 3, 1), (2, 8, 1), 
(3, 1, 1), (3, 2, 1), 
(3, 6, 1), (4, 2, 1), 
(4, 6, 1), (4, 7, 0);

INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity, Notes, IsConfirmed)
VALUES
(1, 1, 1, 7, 'Patient presents with high fever and persistent cough', 1),
(2, 2, 2, 8, 'Severe unilateral headache with photophobia', 1),
(3, 3, 3, 9, 'Confirmed COVID-19 with respiratory distress', 1),
(4, 4, 4, 6, 'Exercise-induced bronchospasm', 1),
(5, 5, 5, 5, 'Stage 1 hypertension, newly diagnosed', 1);

INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity, CurrentStatus)
VALUES
(1, 1, 8, 'Active'), (1, 2, 7, 'Active'), (1, 5, 6, 'Active'),
(2, 3, 9, 'Active'), (2, 8, 5, 'Active'),
(3, 1, 8, 'Active'), (3, 2, 6, 'Active'), (3, 6, 7, 'Active'),
(4, 2, 5, 'Chronic'), (4, 6, 6, 'Chronic'),
(5, 5, 4, 'Active');

INSERT INTO TreatmentPlans (DiagnosisID, TreatmentID, DoctorID, StartDate, EndDate, Dosage, Frequency, Status)
VALUES
(1, 1, 1, GETDATE(), DATEADD(day, 5, GETDATE()), '75mg', 'Twice daily', 'Active'),
(2, 2, 2, GETDATE(), NULL, '400mg', 'Every 6 hours as needed', 'Active'),
(3, 3, 3, GETDATE(), DATEADD(day, 5, GETDATE()), '200mg', 'Once daily', 'Active'),
(4, 4, 4, GETDATE(), NULL, '2 puffs', 'As needed', 'Active'),
(5, 5, 5, GETDATE(), NULL, '10mg', 'Once daily', 'Active');

