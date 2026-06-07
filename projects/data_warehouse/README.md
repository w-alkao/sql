# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** ! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics. This project demonstrates the design and implementation of a modern data warehouse using a Medallion Architecture (Bronze → Silver → Gold). Data is collected from multiple business systems, transformed into clean and consistent datasets, and finally modeled into a star schema optimized for analytics and reporting.

#### 🚀 Project Goal
The objective of this project is to build a scalable data warehouse that integrates CRM and ERP data, applies data quality transformations through Bronze and Silver layers, and delivers a business-ready Sales Data Mart in the Gold layer for reporting, dashboarding, and advanced analytics.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

#### Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQLSERVER:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **Data Flow Diagram**: Show how data moves from source systems through the data warehouse
3. **Data Relations**: Illustrate how CRM and ERP datasets are related before loading them into the analytical model
4. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
5. **Analytics & Reporting (Coming Soon)**: Creating SQL-based reports and dashboards for actionable insights.
6. **Data Calalog for Gold Layer**: Meta data about Gold layer
7. **Skills**: Skills developed through the project

--- 

## 🏗️ Data Architecture

![Data Architecture](images/high_level_architecture.png)

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---

## Data Flow Diagram

![Data Flow Diagram](images/data_flow.png)

This diagram illustrates the movement of data from source systems to the final analytical layer.

1. **Sources Systems**: The warehouse integrates data from two operational systems CRM and ERP
2. **Bronze Layer**: The Bronze layer stores raw data exactly as received from the source systems. Preserve original source data, Enable data lineage and auditing, Serve as the landing zone for ingestion.
3. **Silver Layer**: The Silver layer contains cleansed and standardized datasets. Typical transformations include Data type corrections Duplicate removal, Missing value handling, Data quality validation, Standardization of business attributes. Improve data quality, create trusted datasets for analytics
4. **Gold Layer**: The Gold layer contains business-ready datasets created by integrating CRM and ERP information. Main entities are Sales, Customers and Product. Provide curated datasets for reporting and dashboards, Support business intelligence and decision-making.

---

## 🏗️ Data Relationship Diagram

![Data Architecture](images/data_relation.png)

This diagram shows how data from CRM and ERP systems are related before being transformed into the analytical model.

1. **Customer Data Integration**: Customer information originates from multiple tables CRM and ERP. These datasets are combined to create a complete customer profile.
2. **Product Data Integration**: Product information is enriched using CRM and ERP source data. This integration produces a richer product dimension for analysis.
3. **Sales Data**: contains transactional sales records and references both customers and Products.This table becomes the foundation of the sales fact table in the Gold layer

---

## 🏗️ Sales Data Mart

![Data Architecture](images/data_model.png)

The Gold layer is modeled as a Star Schema, a dimensional model optimized for reporting and analytical queries.

1. **Fact Sales**:This table stores measurable business events (sales transactions).
2. **Customer Dimension**: Contains descriptive customer attributes. Enable customer segmentation and demographic analysis
3. **Product Dimension**: Contains descriptive product information. Support product performance and category analysis

Relationship Types:
    One customers -> Many Sales
    One Product -> Many Sales

---

## COMING SOON: BI, Analytics & Reporting (Data Analysis) 

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

---

## Data Catalog for Gold Layer

### Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_id      | INT           | Unique numerical identifier assigned to each customer.                                        |
| customer_number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| first_name       | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| last_name        | NVARCHAR(50)  | The customer's last name or family name.                                                     |
| country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                               |
| marital_status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                              |
| gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                  |
| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               |
| create_date      | DATE          | The date and time when the customer record was created in the system|

---

### 2. **gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |
| product_id          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |
| product_number      | NVARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |
| category_id         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.     |
| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.  |
| subcategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |
| maintenance_required| NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |
| cost                | INT           | The cost or base price of the product, measured in monetary units.                            |
| product_line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |
| start_date          | DATE          | The date when the product became available for sale or use, stored in|

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                      |
| product_key     | INT           | Surrogate key linking the order to the product dimension table.                               |
| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                              |
| order_date      | DATE          | The date when the order was placed.                                                           |
| shipping_date   | DATE          | The date when the order was shipped to the customer.                                          |
| due_date        | DATE          | The date when the order payment was due.                                                      |
| sales_amount    | INT           | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |
| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |
| price           | INT           | The price per unit of the product for the line item, in whole currency units (e.g., 25).      |

----

🎯 Showcase expertise:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Developer  
- Data Modeling  
- Data Analytics 

---

## 📂 Project Structure

data-warehouse-project/
│
├── datasets/                  # Raw datasets used for the project (ERP and CRM data)
│
├── diagrams/                  # Project diagrams 
│ 
|── images/                    # Project images
|
├── scripts/                   # SQL scripts for ETL and transformations 
|                   
└── README.md                  # Project overview
```
## ☕ Stay Connected
