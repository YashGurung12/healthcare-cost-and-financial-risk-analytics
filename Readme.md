# Healthcare Analytics Pipeline & Financial Risk Analysis

An end-to-end data engineering, database integration, and business intelligence pipeline focused on patient encounter costs, insurance coverage gaps, procedure costs, and financial risk assessment across healthcare systems.

---

## Executive Summary

Healthcare organizations face mounting financial pressure due to rising treatment costs, repeated high-cost patient encounters, and reimbursement gaps where insurance providers do not cover full claim amounts. This project standardizes multi-source healthcare datasets, builds a MySQL relational database schema, executes analytical queries, and powers interactive Tableau dashboards.

The pipeline identifies cost drivers across **5 core datasets**:

- **Patients:** 974 records (Demographics, locations, mortality)
    
- **Encounters:** 27,891 records (Central fact table tracking visits, claim costs, and coverage)
    
- **Procedures:** 47,701 records (Detailed medical procedures and costs)
    
- **Payers:** 10 records (Insurance providers and reimbursement info)
    
- **Organizations:** 1 record (Healthcare facilities and networks)
    

---

## Directory Structure

Plaintext

```
├── data/
│   ├── raw/                  # Standardized UTF-8 CSV files (BOM stripped)
│   │   ├── patients.csv
│   │   ├── encounters.csv
│   │   ├── procedures.csv
│   │   ├── organizations.csv
│   │   └── payers.csv
│   └── processed/            # Cleaned & transformed outputs
├── docs/
│   ├── 01_Business_Understanding.md
│   ├── 02_Project_Objective.md
│   ├── 03_Dataset_Overview.md
│   ├── 04_Data_Model.md
│   └── 05_Data_Dictionary.md
├── scripts/
│   └── data_conversion.py    # Python script for UTF-8 conversion and encoding
├── sql/
│   ├── schema.sql            # MySQL DDL for Star Schema with FK constraints
│   └── analytical_queries.sql# Business intelligence and KPI queries
└── README.md
```

---

## Relational Data Model

The data architecture follows a normalized Star Schema with `Encounters` as the central transactional fact table.

```
                Patients (1)
                   │
                   │ PK: Id / FK: Patient
                   ▼
Organisations ──► Encounters (M) ◄── Payers
   (1:M)           │                (1:M)
                   │ PK: Id / FK: Encounter
                   ▼
                Procedures (M)
```

### Table Relationships & Key Mapping

- **Patients → Encounters (1:M):** `patients.Id = encounters.Patient`
    
- **Organizations → Encounters (1:M):** `organizations.Id = encounters.Organization`
    
- **Payers → Encounters (1:M):** `payers.Id = encounters.Payer`
    
- **Encounters → Procedures (1:M):** `encounters.Id = procedures.Encounter`
    
- **Patients → Procedures (1:M):** `patients.Id = procedures.Patient`
    

---

## Key Business Questions & Analytical Focus

This pipeline provides automated reporting and SQL calculations for key operational and financial metrics:

1. **Uncovered Financial Risk:** Measures `Total_Claim_Cost - Payer_Coverage` across diagnosis codes (`ReasonCode`) and insurance providers.
    
2. **High-Cost Patient Tracking:** Identifies patients with repeated high-cost encounters within a single year.
    
3. **Reimbursement Efficiency:** Evaluates coverage percentages `(Payer_Coverage / Total_Claim_Cost) * 100` across payers.
    
4. **Procedure Cost Contribution:** Analyzes resource-intensive treatments and procedure cost trends.
    
5. **Length of Stay (LOS) & Duration:** Calculates visit duration `Stop - Start` across encounter classes (Emergency, Inpatient, Ambulatory, Urgent Care, Wellness).
    
6. **Demographic Risk Factors:** Examines cost patterns broken down by Age Group, Gender, Race, and Ethnicity.