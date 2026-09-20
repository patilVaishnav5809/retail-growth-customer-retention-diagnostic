# Project Charter — Retail Growth & Customer Retention Diagnostic

## 1. Project Overview

| Field                 | Details                                       |
| --------------------- | --------------------------------------------- |
| **Project**           | Retail Growth & Customer Retention Diagnostic |
| **Role**              | Business Intelligence Engineer                |
| **Business Context**  | Online Retail Marketplace — Brazil            |
| **Executive Sponsor** | Head of Sales Operations                      |
| **Project Stage**     | Initiation & Chartering                       |
| **Status**            | Baseline for Discovery                        |

---

## 2. Business Problem

The business is experiencing **flattening revenue growth despite relatively stable order volume**.

Initial business observations indicate:

* Declining average revenue per customer
* Increasing proportion of customers placing only one order
* Variation in customer satisfaction
* Potential relationship between late deliveries and lower review scores
* Limited integration between customer, product/category, seller, and delivery reporting

Leadership therefore lacks an integrated, data-backed view of **why customer value and revenue growth are changing** and where intervention should be focused.

> **Note:** These observations are initial hypotheses and will be validated through analysis.

---

## 3. Project Objective

The objective is to identify and quantify the most material drivers associated with:

* Customer value
* Repeat purchasing
* Customer retention
* Product/category performance
* Seller contribution
* Delivery performance
* Customer satisfaction

The final analysis will translate validated findings into **actionable business recommendations and a repeatable BI reporting view**.

---

## 4. Decision-First Approach

```text
Business Problem
       ↓
Business Decisions
       ↓
Requirements
       ↓
Data Requirements
       ↓
Data Quality & Reconciliation
       ↓
Diagnostic Analysis
       ↓
Validated Findings
       ↓
BI Reporting
       ↓
Recommendations
```

The dashboard is treated as a **decision-support mechanism**, not the primary objective of the project.

---

## 5. Key Business Questions

### Customer & Retention

* Are customers purchasing only once?
* Which customer segments have the weakest repeat-purchase behavior?
* How are high-value customers behaving compared with the broader customer base?

### Product & Category

* Are category trends affecting customer value?
* Is product mix changing revenue contribution?
* Which sellers or categories contribute disproportionately to revenue?

### Delivery & Customer Experience

* Are late deliveries associated with lower customer satisfaction?
* Are certain sellers, regions, or operational patterns associated with poor delivery performance?
* Does delivery experience appear to influence repeat purchasing?

### Cross-Factor Analysis

* Is the problem driven by one factor or multiple interacting factors?
* Which findings are actionable by Marketing, Sales Operations, and Logistics?

---

## 6. Initial Hypotheses

| Hypothesis                      | Validation Required                                                         |
| ------------------------------- | --------------------------------------------------------------------------- |
| **Customer Retention Issue**    | Repeat-purchase behavior, customer segmentation, high-value customer trends |
| **Product / Category Issue**    | Category trends, product mix, seller contribution, revenue concentration    |
| **Delivery / Operations Issue** | Delivery performance, late deliveries, reviews, regional/seller patterns    |
| **Combination Effect**          | Interaction between customer, product/seller, and delivery factors          |

These hypotheses will **not be treated as conclusions until supported by data**.

---

## 7. Scope

### In Scope

* Customer purchase behavior
* Customer retention and repeat purchasing
* Revenue and customer-value analysis
* Product and category performance
* Seller performance
* Delivery performance
* Customer satisfaction
* Cross-functional stakeholder requirements
* KPI definition and validation
* Data-quality analysis
* BI reporting
* Executive recommendations

### Out of Scope

* Marketing campaign execution
* Production predictive-model deployment
* Real-time operational integration
* IT infrastructure changes
* Seller contract/legal review
* Financial/accounting reconciliation unless separately approved

---

## 8. Major Deliverables

### Phase 1 — Initiation

* Project Charter
* Stakeholder Register
* Scope Definition
* Success Criteria

### Phase 2 — Business Discovery

* Interview Plan
* Requirement Log
* KPI & Measure Catalog
* Data Requirement Checklist
* Decision Log

### Phase 3 — Data & Technical Discovery

* Source Analysis
* Data Profiling
* Data Quality Report
* Reconciliation Checks
* ERD / Data Model
* Data Flow Documentation

### Phase 4 — Diagnostic Analysis

* Customer & Retention Analysis
* Revenue Analysis
* Product/Category Analysis
* Seller Analysis
* Delivery Analysis
* Customer Satisfaction Analysis
* Cross-factor Analysis

### Phase 5 — BI Delivery

* Validated BI Dashboard
* Data Dictionary
* User Guide
* Reporting Documentation

### Phase 6 — Executive Outcome

* Root-Cause Findings
* Prioritized Recommendations
* Business Impact Assessment

---

## 9. Success Criteria

| Area                           | Success Measure                                                             |
| ------------------------------ | --------------------------------------------------------------------------- |
| **Retention Visibility**       | Repeat-purchase trends are clearly segmented and measurable                 |
| **Root-Cause Clarity**         | Material business drivers are identified and quantified                     |
| **Data Reliability**           | Key datasets undergo documented quality and reconciliation checks           |
| **Reporting**                  | Leadership receives a consistent decision-oriented reporting view           |
| **Delivery–Satisfaction Link** | Relationship is tested using available evidence                             |
| **Actionability**              | 2–3 prioritized actions are supported by quantified findings where feasible |

---

## 10. Stakeholders

| Stakeholder                     | Responsibility / Interest                   |
| ------------------------------- | ------------------------------------------- |
| **Head of Sales Operations**    | Executive sponsorship, direction, decisions |
| **Marketing / Customer Growth** | Customer acquisition and retention          |
| **Logistics / Operations**      | Delivery performance                        |
| **Data Engineering**            | Data access, pipelines, data quality        |
| **Finance**                     | Revenue and KPI validation                  |
| **Data & Analytics**            | Analytical validation and reporting         |

---

## 11. Key Risks

| Risk                        | Mitigation                                           |
| --------------------------- | ---------------------------------------------------- |
| Conflicting KPI definitions | Establish KPI & Measure Catalog                      |
| Poor data quality           | Perform systematic data profiling and reconciliation |
| Stakeholder availability    | Prioritize decision owners and critical interviews   |
| Hypotheses treated as facts | Require analytical validation before conclusions     |
| Scope expansion             | Maintain Requirement Log and change control          |
| Dashboard-first thinking    | Link every report element to a business question     |

---

## 12. Governance

* Project direction and scope are controlled by the executive sponsor.
* Major scope or timeline changes are documented through change control.
* Requirements and decisions are traceable to stakeholder discussions.
* KPI definitions are validated with relevant business owners.
* Findings must be supported by documented analytical evidence.

---

## 13. Project Milestones

```text
Charter Approved
       ↓
Stakeholder Discovery
       ↓
Requirements Baseline
       ↓
Data Discovery
       ↓
Data Quality & Reconciliation
       ↓
Diagnostic Analysis
       ↓
BI Dashboard
       ↓
Validation
       ↓
Executive Recommendations
```

---

## 14. Definition of Done

The project will be considered complete when:

* Business questions and KPIs are documented.
* Relevant data sources have been assessed.
* Data-quality and reconciliation checks are documented.
* Customer, revenue, product/category, seller, delivery, and satisfaction analyses are completed where supported by available data.
* Key findings have been validated.
* BI reporting has been validated against requirements.
* Recommendations are linked to quantified findings.
* Project documentation is maintained in the repository.

---

## 15. Repository Structure

```text
Retail-Growth-Customer-Retention-Diagnostic/
│
├── README.md
│
├── docs/
│   ├── project-charter.md
│   ├── stakeholder-register.md
│   ├── power-interest-grid.md
│   ├── raci-matrix.md
│   ├── brd.md
│   ├── requirements-log.md
│   ├── kpi-measure-catalog.md
│   ├── data-dictionary.md
│   ├── data-quality-report.md
│   └── decision-log.md
│
├── sql/
│   ├── profiling/
│   ├── data_quality/
│   ├── reconciliation/
│   ├── analysis/
│   └── reporting/
│
├── data/
│   └── README.md
│
├── dashboard/
│   └── README.md
│
├── analysis/
│   └── README.md
│
└── visuals/
    └── README.md
```

---

## 16. Project Principle

> **The objective is not to build a dashboard that describes the business.
> The objective is to build an evidence-based decision system that explains what is happening, why it is happening, and where leadership should investigate or act.**
