# 🐍 Python Data Generation

This folder contains the Python scripts used to generate and load synthetic data for the **Fraud BI System** project.

Python was used to create realistic datasets for customers, merchants, devices, transactions, payments, refunds, and fraud cases before performing SQL analysis and building Power BI dashboards.

## 📁 Files

| File | Purpose |
|------|---------|
| `db_connection.py` | Creates a secure connection between Python and the MySQL database using environment variables |
| `generate_customers.py` | Generates customer data |
| `generate_merchants.py` | Generates merchant data |
| `generate_devices.py` | Generates customer device data |
| `generate_transactions.py` | Generates transaction records |
| `generate_payments.py` | Generates payment records |
| `generate_refunds.py` | Generates refund records |
| `generate_fraud_cases.py` | Generates fraud case records |

## 🔄 Data Generation Workflow

The scripts follow the database relationships in this order:

`Customers → Merchants → Devices → Transactions → Payments → Refunds → Fraud Cases`

Transaction-related datasets use the generated customer, merchant, and device records to maintain relationships between tables.

## 🔐 Database Security

Database credentials are not stored directly in the Python source code.

The database password is loaded from a local environment variable:

```python
password=os.getenv("MYSQL_PASSWORD")
```

The local `.env` file containing credentials is excluded from Git using `.gitignore`.

## 🛠️ Technologies

- Python
- MySQL Connector
- python-dotenv
- MySQL

## 🎯 Purpose

These scripts support the complete analytics workflow:

**Data Generation → MySQL Database → SQL Analysis → Power BI → Business Insights**
