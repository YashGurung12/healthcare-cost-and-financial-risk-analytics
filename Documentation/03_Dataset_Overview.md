

This project utilizes a relational healthcare dataset consisting of **five interconnected tables** that capture patient demographics, healthcare encounters, medical procedures, insurance payer information, and healthcare organization details. Together, these datasets provide a comprehensive view of patient interactions within the healthcare system and enable analysis of healthcare costs, insurance reimbursements, operational performance, and financial risk.

The **Encounters** table serves as the central fact table, linking patients, healthcare organizations, insurance payers, and medical procedures. This relational structure enables multi-dimensional analysis across patient demographics, encounter characteristics, procedure costs, and payer contributions.

The dataset is designed to support healthcare analytics use cases such as identifying high-cost patients, evaluating payer performance, analyzing procedure utilization, and assessing financial risk due to uncovered healthcare costs.

---
# Dataset Summary

|Table|Purpose|Primary Key|Related Tables|
|---|---|---|---|
|**Patients**|Stores patient demographic and personal information.|Id|Encounters, Procedures|
|**Encounters**|Records every patient visit including costs, diagnoses, payer information, and encounter details.|Id|Patients, Organizations, Payers, Procedures|
|**Procedures**|Contains medical procedures performed during patient encounters along with procedure costs.|_(No unique procedure ID provided in dataset)_|Encounters, Patients|
|**Payers**|Stores insurance provider information responsible for covering healthcare costs.|Id|Encounters|
|**Organizations**|Contains hospital and healthcare organization details where encounters occurred.|Id|Encounters|

---
# Table Descriptions

## 1. Patients
### Purpose
The **Patients** table contains demographic and personal information for every patient within the healthcare system. It serves as the master table for patient identification and enables demographic analysis of healthcare utilization.

This table supports analyses such as:
- Patient age distribution
- Gender-based healthcare utilization
- Race and ethnicity analysis
- Geographic patient distribution
- Demographic risk assessment

### Key Information
- Patient identification
- Date of birth and age calculation
- Gender
- Race
- Ethnicity
- Marital status
- Birthplace
- Residential location
- Mortality information (Death Date)


---
## 2. Encounters

### Purpose
The **Encounters** table is the central transactional table of the dataset. Each record represents a healthcare encounter between a patient and a healthcare provider.

This table captures both operational and financial information including:
- Encounter timing
- Encounter type
- Diagnosis
- Healthcare costs
- Insurance coverage
- Hospital information

It forms the foundation for almost every business analysis within this project.
### Key Information
- Encounter ID
- Patient ID
- Hospital ID
- Insurance Payer
- Encounter Class
- Diagnosis (ReasonCode)
- Base Encounter Cost
- Total Claim Cost
- Insurance Coverage
- Encounter Start and End Time
**

### Foreign Keys
- Patient
- Organization
- Payer

---

## 3. Procedures

### Purpose
The **Procedures** table stores detailed information about medical procedures performed during patient encounters. A single encounter may involve one or multiple procedures, making this table essential for understanding healthcare resource utilization and treatment costs.

This table supports analyses including:
- Procedure frequency
- Procedure cost trends
- Diagnosis-to-procedure relationships
- Procedure cost contribution
- High-cost treatments

### Key Information
- Procedure date
- Patient
- Encounter
- Procedure description
- Procedure cost
- Diagnosis associated with procedure

### Primary Relationship
Each procedure belongs to:
- One Patient
- One Encounter

---

## 4. Payers

### Purpose
The **Payers** table contains information about insurance providers responsible for reimbursing healthcare costs incurred during patient encounters.

It enables financial analyses related to:
- Insurance reimbursement
- Coverage percentage
- Financial risk
- Uncovered healthcare costs
- Payer comparison

### Key Information
- Insurance company name
- Address
- Headquarters
- Contact information


---

## 5. Organizations
### Purpose
The **Organizations** table contains information about hospitals and healthcare facilities where patient encounters take place.

This dataset supports operational analyses such as:
- Hospital performance
- Encounter volume
- Geographic distribution
- Average encounter cost by hospital
- Average encounter duration

### Key Information
- Hospital name
- Address
- City
- State
- Geographic coordinates


---
# Dataset Relationships

The healthcare dataset follows a relational database structure where the **Encounters** table acts as the central fact table connecting all other entities.

```
                Patients
                   │
                   │
          Patient ID (FK)
                   │
                   ▼
             Encounters
           /      |      \
          /       |       \
         ▼        ▼        ▼
Organizations   Payers   Procedures
```

### Relationship Summary

|Parent Table|Child Table|Relationship|
|---|---|---|
|Patients|Encounters|One-to-Many|
|Organizations|Encounters|One-to-Many|
|Payers|Encounters|One-to-Many|
|Encounters|Procedures|One-to-Many|
|Patients|Procedures|One-to-Many|

---

# Data Granularity
Understanding the level of detail (granularity) in each table is essential for accurate analysis and joins.

|Table|Granularity|
|---|---|
|Patients|One record per patient|
|Encounters|One record per patient encounter|
|Procedures|One record per medical procedure|
|Organizations|One record per healthcare organization|
|Payers|One record per insurance provider|

---

# Analytical Importance of Each Table

|Table|Business Value|
|---|---|
|**Patients**|Enables demographic segmentation and identification of high-risk patient groups.|
|**Encounters**|Captures healthcare utilization, encounter costs, diagnoses, and insurance coverage, making it the primary source for financial and operational analysis.|
|**Procedures**|Provides insight into treatment patterns, procedure costs, and resource-intensive medical services.|
|**Payers**|Supports evaluation of insurance reimbursement performance and identification of uncovered financial risk.|
|**Organizations**|Enables comparison of hospitals based on encounter volume, operational efficiency, and healthcare costs.|

---

# Dataset Scope

The dataset supports analysis across multiple healthcare and financial dimensions, including:
- Patient Demographics
- Healthcare Encounters
- Medical Procedures
- Insurance Reimbursement
- Healthcare Costs
- Financial Risk
- Hospital Performance
- Diagnosis Trends
- Encounter Duration
- Geographic Distribution
- Resource Utilization
- Operational Efficiency

