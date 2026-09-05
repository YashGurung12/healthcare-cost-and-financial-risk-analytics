## Overview

The **Data Dictionary** provides a detailed description of the key data elements used throughout this project. It serves as a reference for understanding the meaning, data type, business context, and analytical purpose of each field within the healthcare dataset.

The dataset consists of five related tables containing patient demographics, healthcare encounters, medical procedures, insurance payer information, and healthcare organization details. While each table contains numerous attributes, this data dictionary focuses on the fields that are essential for data cleaning, SQL analysis, KPI calculations, and Tableau dashboard development.

---

# 1. Patients Table

**Purpose:** Stores demographic and personal information for each patient.

|Column|Data Type|Description|Business Use|
|---|---|---|---|
|Id|VARCHAR|Unique identifier for each patient.|Used to join patients with encounters and procedures.|
|BirthDate|DATE|Patient's date of birth.|Used to calculate patient age and age groups.|
|DeathDate|DATE|Date of patient's death, if applicable.|Identifies deceased patients and supports mortality-related analysis.|
|Gender|VARCHAR|Patient gender (M/F).|Demographic segmentation and utilization analysis.|
|Race|VARCHAR|Patient's race.|Population health and demographic analysis.|
|Ethnicity|VARCHAR|Patient ethnicity.|Diversity and healthcare utilization analysis.|
|Marital|VARCHAR|Marital status (M = Married, S = Single).|Demographic segmentation.|
|BirthPlace|VARCHAR|Patient's birthplace.|Geographic demographic analysis.|
|City|VARCHAR|Patient's city of residence.|Regional patient distribution.|
|State|VARCHAR|Patient's state of residence.|Geographic analysis.|
|County|VARCHAR|County of residence.|Regional healthcare utilization.|
|Zip|VARCHAR|Postal code.|Geographic mapping.|
|Lat|DECIMAL|Latitude of patient residence.|Geographic visualization.|
|Lon|DECIMAL|Longitude of patient residence.|Geographic visualization.|

---

# 2. Encounters Table

**Purpose:** Records every patient visit and serves as the primary transactional table for healthcare cost and utilization analysis.

|Column|Data Type|Description|Business Use|
|---|---|---|---|
|Id|VARCHAR|Unique encounter identifier.|Primary key for encounter-level analysis.|
|Patient|VARCHAR|Patient identifier.|Links encounters to patients.|
|Organization|VARCHAR|Hospital identifier.|Links encounters to healthcare organizations.|
|Payer|VARCHAR|Insurance provider identifier.|Links encounters to insurance companies.|
|Start|DATETIME|Encounter start date and time.|Duration analysis and time-based trends.|
|Stop|DATETIME|Encounter end date and time.|Encounter duration calculation.|
|EncounterClass|VARCHAR|Type of healthcare encounter (Emergency, Inpatient, Ambulatory, Wellness, Urgent Care).|Encounter classification and utilization analysis.|
|Code|VARCHAR|SNOMED encounter code.|Clinical classification.|
|Description|VARCHAR|Description of encounter.|Reporting and interpretation.|
|Base_Encounter_Cost|DECIMAL|Base cost before additional services.|Cost comparison and financial analysis.|
|Total_Claim_Cost|DECIMAL|Total healthcare claim amount including procedures and services.|Primary financial KPI.|
|Payer_Coverage|DECIMAL|Amount reimbursed by insurance provider.|Insurance performance analysis.|
|ReasonCode|VARCHAR|Diagnosis code associated with encounter.|Disease-specific analysis.|
|ReasonDescription|VARCHAR|Description of diagnosis.|Clinical interpretation and reporting.|

---

# 3. Procedures Table

**Purpose:** Contains information about medical procedures performed during patient encounters.

|Column|Data Type|Description|Business Use|
|---|---|---|---|
|Patient|VARCHAR|Patient identifier.|Links procedures to patients.|
|Encounter|VARCHAR|Encounter identifier.|Associates procedures with encounters.|
|Start|DATETIME|Procedure start time.|Procedure timeline analysis.|
|Stop|DATETIME|Procedure completion time.|Procedure duration analysis.|
|Code|VARCHAR|SNOMED procedure code.|Procedure categorization.|
|Description|VARCHAR|Procedure description.|Reporting and procedure analysis.|
|Base_Cost|DECIMAL|Cost of the individual procedure.|Procedure cost analysis.|
|ReasonCode|VARCHAR|Diagnosis code associated with procedure.|Diagnosis-to-procedure mapping.|
|ReasonDescription|VARCHAR|Diagnosis description.|Clinical reporting.|

---

# 4. Organizations Table

**Purpose:** Stores information about healthcare providers and hospitals.

|Column|Data Type|Description|Business Use|
|---|---|---|---|
|Id|VARCHAR|Unique organization identifier.|Links hospitals to encounters.|
|Name|VARCHAR|Hospital or healthcare organization name.|Organization-level reporting.|
|Address|VARCHAR|Organization address.|Geographic reporting.|
|City|VARCHAR|Organization city.|Regional analysis.|
|State|VARCHAR|Organization state.|Geographic comparison.|
|Zip|VARCHAR|Postal code.|Location analysis.|
|Lat|DECIMAL|Latitude.|Geographic visualization.|
|Lon|DECIMAL|Longitude.|Geographic visualization.|

---

# 5. Payers Table

**Purpose:** Contains insurance provider information responsible for healthcare reimbursement.

|Column|Data Type|Description|Business Use|
|---|---|---|---|
|Id|VARCHAR|Unique payer identifier.|Links insurance providers to encounters.|
|Name|VARCHAR|Insurance provider name.|Payer performance reporting.|
|Address|VARCHAR|Payer address.|Administrative information.|
|City|VARCHAR|Headquarters city.|Geographic reporting.|
|State_Headquartered|VARCHAR|Headquarters state.|Regional analysis.|
|Zip|VARCHAR|Postal code.|Administrative information.|
|Phone|VARCHAR|Contact number.|Reference information.|

---

# Derived (Calculated) Fields

The following fields are **not directly available** in the dataset but are created during SQL analysis to support business insights.

|Derived Field|Formula|Business Purpose|
|---|---|---|
|Patient Age|`Current Date - BirthDate`|Age-based demographic analysis.|
|Age Group|Based on calculated age (e.g., 0–18, 19–35, 36–50, 51–65, 65+)|Population segmentation.|
|Encounter Duration|`Stop - Start`|Measures length of patient encounters.|
|Procedure Duration|`Stop - Start`|Measures duration of medical procedures.|
|Uncovered Cost|`Total_Claim_Cost - Payer_Coverage`|Quantifies financial risk to healthcare providers.|
|Coverage Percentage|`(Payer_Coverage / Total_Claim_Cost) × 100`|Evaluates insurance reimbursement performance.|
|High-Cost Encounter Flag|`CASE WHEN Total_Claim_Cost > 10000 THEN 'High Cost' END`|Identifies expensive patient encounters.|
|Encounter Year|`YEAR(Start)`|Supports yearly trend analysis.|
|Encounter Month|`MONTH(Start)`|Monthly healthcare utilization trends.|

---

# Key Fields Used in Analysis

The following columns play a central role in answering the business questions and building Tableau dashboards.

|Field|Used For|
|---|---|
|Patient|Patient-level analysis and encounter history|
|Total_Claim_Cost|Cost analysis and financial KPIs|
|Payer_Coverage|Insurance reimbursement analysis|
|Uncovered Cost (Derived)|Financial risk assessment|
|EncounterClass|Encounter distribution and utilization analysis|
|ReasonCode|Diagnosis-based cost and risk analysis|
|Base_Cost|Procedure cost analysis|
|Organization|Hospital performance comparison|
|Payer|Insurance provider performance|
|Start / Stop|Duration and time-series analysis|
|BirthDate|Age calculation and demographic segmentation|

---

# Business Terminology

| Term                | Definition                                                                                                                                          |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Encounter**       | A patient’s interaction with a healthcare provider, such as an emergency visit, inpatient admission, wellness check-up, or outpatient consultation. |
| **Procedure**       | A medical treatment, surgery, diagnostic test, or intervention performed during an encounter.                                                       |
| **Payer**           | An insurance company or organization responsible for reimbursing healthcare costs.                                                                  |
| **Claim Cost**      | The total amount billed for a patient encounter, including all associated services.                                                                 |
| **Payer Coverage**  | The portion of the claim cost reimbursed by the insurance provider.                                                                                 |
| **Uncovered Cost**  | The remaining amount not covered by insurance, representing potential financial risk for the healthcare provider or patient.                        |
| **ReasonCode**      | A standardized diagnosis code (SNOMED-CT) indicating the medical condition or reason for the encounter or procedure.                                |
| **Encounter Class** | The category of healthcare visit, such as emergency, inpatient, ambulatory, wellness, or urgent care.                                               |