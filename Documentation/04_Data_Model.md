## Overview

The healthcare dataset follows a **relational data model** consisting of five interconnected tables. Each table represents a distinct business entity within the healthcare system, while primary and foreign key relationships ensure data integrity and enable comprehensive analysis across patient encounters, medical procedures, healthcare organizations, and insurance payers.

The **Encounters** table acts as the **central fact table**, linking patient demographics, healthcare providers, insurance companies, and medical procedures. This design enables multidimensional analysis of healthcare utilization, operational performance, and financial risk.

The data model follows a **normalized relational structure**, minimizing data redundancy while maintaining efficient relationships between entities.

---

# Entity Relationship Diagram (ERD)

```
                               Patients
                           ┌──────────────┐
                           │ PK : Id      │
                           └──────┬───────┘
                                  │
                     Patient (FK) │
                                  │
                                  ▼
                     ┌───────────────────────────┐
                     │        Encounters         │
                     │---------------------------│
                     │ PK : Id                   │
                     │ FK : Patient             │
                     │ FK : Organization        │
                     │ FK : Payer              │
                     └──────┬─────────┬─────────┘
                            │         │
             Organization   │         │  Payer
                  (FK)       │         │ (FK)
                            ▼         ▼
                  ┌──────────────┐   ┌──────────────┐
                  │ Organizations│   │    Payers    │
                  │ PK : Id      │   │ PK : Id      │
                  └──────────────┘   └──────────────┘
                            │
                            │ Encounter (FK)
                            ▼
                   ┌────────────────────┐
                   │     Procedures     │
                   │--------------------│
                   │ FK : Patient       │
                   │ FK : Encounter     │
                   └────────────────────┘
```

---

# Table Relationships

## 1. Patients → Encounters

### Relationship
**One-to-Many (1:M)**
### Join Condition
```
patients.Id = encounters.Patient
```
### Description
A single patient may visit a healthcare provider multiple times throughout their lifetime. Therefore, one patient can have many encounters, while each encounter belongs to only one patient.

### Business Significance

This relationship enables:
- Patient utilization analysis
- Repeat encounter identification
- High-cost patient analysis
- Demographic segmentation
- Patient history tracking

---

## 2. Organizations → Encounters

### Relationship
**One-to-Many (1:M)**
### Join Condition
```
organizations.Id = encounters.Organization
```
### Description
Each healthcare organization (hospital or clinic) manages many patient encounters. Every encounter is associated with exactly one healthcare organization.

### Business Significance
Supports analysis of:
- Hospital performance
- Encounter volume
- Average encounter cost
- Resource utilization
- Operational efficiency

---

## 3. Payers → Encounters

### Relationship
**One-to-Many (1:M)**
### Join Condition
```
payers.Id = encounters.Payer
```
### Description
Each insurance provider covers multiple patient encounters, while each encounter is billed to one payer.

### Business Significance
Enables:
- Insurance reimbursement analysis
- Coverage comparison
- Financial risk assessment
- Payer performance evaluation
- Uncovered cost analysis

---

## 4. Encounters → Procedures

### Relationship
**One-to-Many (1:M)**
### Join condition
```
encounters.Id = procedures.Encounter
```

### Description
A patient encounter may involve multiple medical procedures. Each procedure is performed within a single encounter.

### Business Significance
Supports:
- Procedure utilization analysis
- Treatment cost analysis
- Encounter-level resource consumption
- Procedure trend analysis

---
## 5. Patients → Procedures

### Relationship
**One-to-Many (1:M)**
### Join Condition
```
patients.Id = procedures.Patient
```

### Description
Each patient may undergo multiple medical procedures over time. Every procedure is linked to one patient.

### Business Significance
Enables:
- Patient treatment history
- Repeat procedure analysis
- Longitudinal patient care analysis

---

# Primary Keys

|Table|Primary Key|Description|
|---|---|---|
|Patients|Id|Unique identifier for each patient|
|Encounters|Id|Unique identifier for each encounter|
|Organizations|Id|Unique identifier for each healthcare organization|
|Payers|Id|Unique identifier for each insurance provider|
|Procedures|_(No primary key provided in dataset)_|Each record represents a medical procedure|

> **Note:** The provided dataset does not include a dedicated primary key for the **Procedures** table. If required for database design, a surrogate key such as `Procedure_ID` could be introduced to uniquely identify each procedure record.

---

# Foreign Keys

|Child Table|Foreign Key|Parent Table|
|---|---|---|
|Encounters|Patient|Patients|
|Encounters|Organization|Organizations|
|Encounters|Payer|Payers|
|Procedures|Patient|Patients|
|Procedures|Encounter|Encounters|

---

# Cardinality

|Relationship|Cardinality|
|---|---|
|Patients → Encounters|One-to-Many|
|Organizations → Encounters|One-to-Many|
|Payers → Encounters|One-to-Many|
|Encounters → Procedures|One-to-Many|
|Patients → Procedures|One-to-Many|

---

# Fact and Dimension Tables

For analytical reporting and dashboard development, the dataset can be viewed as a simple star-like analytical model.

### Fact Table

|Table|Reason|
|---|---|
|**Encounters**|Stores transactional healthcare events, costs, diagnoses, payer information, and serves as the central table for analysis.|

### Dimension Tables

|Table|Purpose|
|---|---|
|Patients|Patient demographics|
|Organizations|Hospital information|
|Payers|Insurance provider information|
|Procedures*|Procedure-level details related to encounters|

> *Although **Procedures** contains transactional data, it functions as a detail (child) table of **Encounters** in this project rather than a standalone fact table.

---

# Data Flow

The analytical workflow follows the sequence below:

```
Patients
     │
     ▼
Patient Encounter
     │
     ├────────► Organization
     │
     ├────────► Payer
     │
     └────────► Procedures
                     │
                     ▼
           Cost & Financial Analysis
```