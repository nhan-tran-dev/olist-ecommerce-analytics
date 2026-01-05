# Olist E-Commerce Analytics Platform

End-to-end analytics platform built on the Olist Brazilian E-Commerce dataset, designed with
production-style data warehousing, incremental ETL, and semantic BI modeling.

This project demonstrates how to move from raw data to business insights using SQL Server,
SSIS, and Power BI.

---

## 1. Business Context

Olist is a Brazilian e-commerce marketplace connecting small sellers to customers across Brazil.

This project aims to answer:
- How sales, revenue, and customer behavior evolve over time
- Which product categories and regions drive performance
- How customers differ between new, returning, and repeat buyers
- How payment methods impact category performance

---

## 2. Solution Architecture

The platform follows a layered data architecture designed for production-style
analytics with incremental ETL and clear separation of concerns.

Data flows from raw CSV sources through staging layers into a dimensional
data warehouse, which serves as the single source of truth for BI and analytics.

![Architecture Overview](03_Data_Architecture/architecture_overview.png)

---

## 3. Data Model (DW Core)

The data warehouse is modeled using a dimensional (star-schema) approach with
clear separation of fact tables by grain.

### High-level dimensional model
![DW Summary ERD](03_Data_Architecture/erd_dw_summary.jpg)

### Full dimensional model (technical view)
![DW Full ERD](03_Data_Architecture/erd_dw_full.jpg)

---

## 4. ETL & Data Engineering (SSIS)

The ETL layer is implemented using SQL Server Integration Services (SSIS) and
designed to support incremental, production-style data loading.

SSIS is responsible for orchestration, while business logic and incremental
load rules are encapsulated in SQL Server stored procedures.

### ETL Control Flow
![SSIS Control Flow](04_ETL_SSIS/ssis_control_flow.png)

### Incremental Load Implementation
![SSIS Incremental Logic](04_ETL_SSIS/ssis_incremental_logic.png)

---

## 5. Power BI Semantic Model

Power BI imports curated tables from the DW core (Import mode) and applies a star-schema semantic layer.
The model keeps facts at their natural grain (orders, items, payments, reviews) and uses a bridge table to
enable Payment × Category analysis without using bidirectional relationships.

### Semantic model (relationships)
![Power BI Model](06_Power_BI/pbi_model_relationships.png)

### Payment × Category using bridge + TREATAS
![TREATAS Example](06_Power_BI/pbi_bridge_or_treatas.png)

---

## 6. Dashboards

### 6.1 Overview Dashboard
![Overview Dashboard](06_Power_BI/dashboard_overview.png)

Key KPIs:
- Total Orders
- Delivery & Cancellation Rates
- On-time Delivery
- Average Review Score

---

### 6.2 Sales Performance
![Sales Performance](06_Power_BI/dashboard_sales_performance.png)

Focus:
- Revenue & order trends
- Monthly growth
- Regional performance

---

### 6.3 Category Analysis
![Category Analysis](06_Power_BI/dashboard_category_analysis.png)

Focus:
- Top & bottom categories
- Revenue contribution
- Product mix

---

### 6.4 Customer Behavior
![Customer Behavior](06_Power_BI/dashboard_customer_behavior.png)

Focus:
- New vs Returning customers
- RFM segmentation
- Purchase frequency

---

### 6.5 Drill-through Analysis
![Drill Through](06_Power_BI/dashboard_drill_through.png)

Focus:
- Category → Order → Customer drill-through
- Payment & delivery impact analysis


---

## 7. Key Business Insights

### 1. Delivery performance strongly impacts customer satisfaction
- Orders delivered on time have significantly higher review scores
- Late deliveries correlate with lower ratings and repeat purchase drop

**Action:**  
Improve seller handling SLA and prioritize high-delay regions.

---

### 2. A small number of categories drive most revenue
- Top 5 categories contribute the majority of total revenue
- Long-tail categories have low volume but high operational cost

**Action:**  
Focus marketing and inventory optimization on high-performing categories.

---

### 3. High churn after first purchase
- Majority of customers purchase only once
- Returning customers generate higher AOV and better reviews

**Action:**  
Introduce loyalty campaigns targeting first-time buyers.

---

### 4. Payment method influences order completion
- Installment-based payments show higher completion rates
- Certain payment types correlate with cancellations

**Action:**  
Promote preferred payment methods during checkout.

---

## 8. Reproducibility

Steps to reproduce:
1. Restore SQL Server database
2. Run SSIS packages
3. Open Power BI report

---

## 9. Repository Structure

01_Business_Context
02_Data_Source
03_Data_Architecture
04_ETL_SSIS
05_SQL_Data_Warehouse
06_Power_BI

---

## 10. Tech Stack

- SQL Server
- SSIS
- Power BI
- Git & GitHub

---

## 11. Future Improvements

- Incremental refresh in Power BI Service
- Automated data quality tests
- CI/CD for ETL deployment
