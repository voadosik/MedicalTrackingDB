USE MedicalTrackingDB;
GO

INSERT INTO Patients (FirstName, LastName, DOB, Gender, PhoneNumber, Email)
VALUES 
('John', 'Doe', '1990-01-15', 'M', '555-123-4567', 'john.doe@example.com'),
('Jane', 'Smith', '1985-07-22', 'F', '555-234-5678', 'jane.smith@example.com'),
('James', 'Brown', '1975-03-12', 'M', '555-345-6789', 'james.brown@example.com'),
('Emily', 'Davis', '1999-11-30', 'F', '555-456-7890', 'emily.davis@example.com'),
('Michael', 'Wilson', '1987-06-09', 'M', '555-567-8901', 'michael.wilson@example.com'),
('Sarah', 'Miller', '1993-05-18', 'F', '555-678-9012', 'sarah.miller@example.com'),
('Robert', 'Garcia', '1965-12-21', 'M', '555-789-0123', 'robert.garcia@example.com'),
('Jessica', 'Martinez', '1995-08-24', 'F', '555-890-1234', 'jessica.martinez@example.com'),
('David', 'Anderson', '1980-02-19', 'M', '555-901-2345', 'david.anderson@example.com'),
('Laura', 'Taylor', '2000-09-02', 'F', '555-012-3456', 'laura.taylor@example.com');

INSERT INTO Symptoms (SymptomName, Description, BodySystem)
VALUES 
('Fever', 'Elevated body temperature above 38°C', 'General'),
('Cough', 'Expulsion of air from lungs with characteristic sound', 'Respiratory'),
('Headache', 'Pain in any region of the head', 'Neurological'),
('Sore throat', 'Pain, scratchiness or irritation of the throat', 'ENT'),
('Fatigue', 'Persistent feeling of tiredness or weakness', 'General'),
('Shortness of breath', 'Difficulty breathing or feeling breathless', 'Respiratory'),
('Chest pain', 'Discomfort or pain in the chest area', 'Cardiovascular'),
('Nausea', 'Uneasy sensation often preceding vomiting', 'Gastrointestinal'),
('Vomiting', 'Forceful expulsion of stomach contents', 'Gastrointestinal'),
('Diarrhea', 'Loose, watery bowel movements occurring more frequently', 'Gastrointestinal'),
('Rash', 'Noticeable change in skin texture or color', 'Dermatological'),
('Dizziness', 'Sensation of spinning or lightheadedness', 'Neurological'),
('Muscle pain', 'Aching or pain in muscles', 'Musculoskeletal'),
('Joint pain', 'Discomfort in joints where bones connect', 'Musculoskeletal'),
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
('Osteoarthritis', 'FA00', 'Degenerative joint disease causing cartilage breakdown'),
('Pneumonia', 'CA40', 'Inflammatory condition of the lung primarily affecting alveoli');

INSERT INTO Doctors (FirstName, LastName, Specialty, LicenseNumber)
VALUES
('Robert', 'Johnson', 'General Practitioner', 'GP-12345'),
('Emily', 'Williams', 'Neurologist', 'NEU-67890'),
('Michael', 'Chen', 'Infectious Disease', 'ID-54321'),
('Sarah', 'Davis', 'Pulmonologist', 'PULM-09876'),
('David', 'Brown', 'Cardiologist', 'CARD-11223'),
('Jennifer', 'Wilson', 'Endocrinologist', 'ENDO-33445'),
('James', 'Miller', 'Gastroenterologist', 'GI-55667'),
('Lisa', 'Garcia', 'Allergist', 'ALL-77889'),
('Thomas', 'Taylor', 'Rheumatologist', 'RHEUM-99001'),
('Patricia', 'Moore', 'Internist', 'INT-11223');

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

-- Link diseases to their symptoms
INSERT INTO DiseaseSymptoms (DiseaseID, SymptomID, IsPrimary)
VALUES
-- Influenza
(1, 1, 1), (1, 2, 1), (1, 5, 1), (1, 3, 0),
-- Migraine
(2, 3, 1), (2, 8, 1), (2, 12, 1),
-- COVID-19
(3, 1, 1), (3, 2, 1), (3, 6, 1), (3, 15, 1),
-- Asthma
(4, 2, 1), (4, 6, 1), (4, 7, 0),
-- Hypertension
(5, 5, 1), (5, 12, 1), (5, 3, 0),
-- Diabetes
(6, 5, 1), (6, 9, 1), (6, 10, 1),
-- Gastroenteritis
(7, 8, 1), (7, 9, 1), (7, 10, 1),
-- Allergic Reaction
(8, 11, 1), (8, 6, 1), (8, 8, 1),
-- Osteoarthritis
(9, 13, 1), (9, 14, 1), (9, 3, 0),
-- Pneumonia
(10, 1, 1), (10, 2, 1), (10, 6, 1), (10, 7, 1);

-- Create diagnoses
INSERT INTO Diagnoses (PatientID, DiseaseID, DoctorID, Severity, Notes, IsConfirmed)
VALUES
(1, 1, 1, 7, 'Patient presents with high fever and persistent cough', 1),
(2, 2, 2, 8, 'Severe unilateral headache with photophobia', 1),
(3, 3, 3, 9, 'Confirmed COVID-19 with respiratory distress', 1),
(4, 4, 4, 6, 'Exercise-induced bronchospasm', 1),
(5, 5, 5, 5, 'Stage 1 hypertension, newly diagnosed', 1),
(6, 6, 6, 7, 'Type 2 diabetes with hyperglycemia', 1),
(7, 7, 7, 6, 'Suspected viral gastroenteritis', 1),
(8, 8, 8, 8, 'Anaphylactic reaction to unknown allergen', 1),
(9, 9, 9, 5, 'Osteoarthritis in knee joints', 1),
(10, 10, 10, 7, 'Community-acquired pneumonia', 1);

-- Record patient symptoms
INSERT INTO PatientSymptoms (PatientID, SymptomID, Severity, CurrentStatus)
VALUES
-- John Doe (Influenza)
(1, 1, 8, 'Active'), (1, 2, 7, 'Active'), (1, 5, 6, 'Active'),
-- Jane Smith (Migraine)
(2, 3, 9, 'Active'), (2, 8, 5, 'Active'), (2, 12, 4, 'Active'),
-- James Brown (COVID-19)
(3, 1, 8, 'Active'), (3, 2, 6, 'Active'), (3, 6, 7, 'Active'), (3, 15, 9, 'Active'),
-- Emily Davis (Asthma)
(4, 2, 5, 'Chronic'), (4, 6, 6, 'Chronic'),
-- Michael Wilson (Hypertension)
(5, 5, 4, 'Active'), (5, 12, 3, 'Active'),
-- Sarah Miller (Diabetes)
(6, 5, 5, 'Chronic'), (6, 9, 4, 'Resolved'), (6, 10, 3, 'Resolved'),
-- Robert Garcia (Gastroenteritis)
(7, 8, 7, 'Active'), (7, 9, 6, 'Active'), (7, 10, 8, 'Active'),
-- Jessica Martinez (Allergic Reaction)
(8, 11, 8, 'Active'), (8, 6, 7, 'Active'),
-- David Anderson (Osteoarthritis)
(9, 13, 6, 'Chronic'), (9, 14, 7, 'Chronic'),
-- Laura Taylor (Pneumonia)
(10, 1, 8, 'Active'), (10, 2, 7, 'Active'), (10, 6, 8, 'Active');

-- Create treatment plans
INSERT INTO TreatmentPlans (DiagnosisID, TreatmentID, DoctorID, StartDate, EndDate, Dosage, Frequency, Status)
VALUES
(1, 1, 1, GETDATE(), DATEADD(day, 5, GETDATE()), '75mg', 'Twice daily', 'Active'),
(2, 2, 2, GETDATE(), NULL, '400mg', 'Every 6 hours as needed', 'Active'),
(3, 3, 3, GETDATE(), DATEADD(day, 5, GETDATE()), '200mg', 'Once daily', 'Active'),
(4, 4, 4, GETDATE(), NULL, '2 puffs', 'As needed', 'Active'),
(5, 5, 5, GETDATE(), NULL, '10mg', 'Once daily', 'Active'),
(6, 6, 6, GETDATE(), NULL, '500mg', 'Twice daily', 'Active'),
(7, 7, 7, GETDATE(), DATEADD(day, 3, GETDATE()), '1 packet', 'After each loose stool', 'Active'),
(8, 8, 8, GETDATE(), NULL, '0.3mg', 'As needed for allergic reaction', 'Active'),
(9, 9, 9, GETDATE(), NULL, '500mg', 'Twice daily', 'Active'),
(10, 10, 10, GETDATE(), DATEADD(day, 7, GETDATE()), '500mg', 'Three times daily', 'Active');