# 🗄️ SQL Analysis

This folder contains the SQL database schema and analysis queries used in the **Fraud BI System** project.

The SQL work covers database design, transaction analysis, fraud analysis, customer behavior, merchant performance, and business KPI calculations.

## 📁 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates the MySQL database structure, tables, primary keys, and foreign-key relationships |
| `analysis_queries.sql` | Contains business-focused SQL queries used for fraud, transaction, customer, and merchant analysis |

## 🧩 Database Structure

The schema includes the main tables used in the project:

- Customers
- Merchants
- Devices
- Transactions
- Payments
- Refunds
- Fraud Cases

These tables are connected through primary and foreign keys to support relational analysis.

## 🔍 SQL Concepts Demonstrated

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- Aggregate Functions
- INNER JOIN and LEFT JOIN
- CASE Expressions
- Common Table Expressions (CTEs)
- Subqueries
- Conditional Aggregation
- Window Functions
- Fraud Rate and Failure Rate Calculations
- Customer and Merchant Performance Analysis

## 📊 Analysis Areas

The SQL queries were used to analyze:

- Transaction volumes and amounts
- Successful and failed transactions
- Fraud transaction patterns
- Payment-method performance
- Merchant performance
- Customer spending behavior
- Fraud and failure rates
- High-risk merchants and transactions

## 🎯 Purpose

The SQL analysis converts raw transaction data into business-ready insights that are later visualized in Power BI.

**MySQL Database → SQL Analysis → KPIs → Power BI Dashboards → Business Insights**
