/*
============================================================
 FRAUD BI SYSTEM - DATABASE SCHEMA
============================================================

 Database: MySQL
 Project: Fraud BI System

 Purpose:
 Relational database designed to support fraud detection,
 transaction analysis, customer behavior analysis,
 merchant performance, payments, and refund analysis.

 Tables:
 1. customers
 2. merchants
 3. devices
 4. transactions
 5. payments
 6. refunds
 7. fraud_cases

 Relationships:
 - customers  -> devices
 - customers  -> transactions
 - merchants  -> transactions
 - devices    -> transactions
 - transactions -> payments
 - transactions -> refunds
 - transactions -> fraud_cases

============================================================
*/

CREATE DATABASE fraud_bi_system;
USE fraud_bi_system;

CREATE DATABASE fraud_bi_system;
USE fraud_bi_system;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);


CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY AUTO_INCREMENT,
    merchant_name VARCHAR(100),
    category VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    onboard_date DATE
);

CREATE TABLE devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    device_type VARCHAR(50),
    os VARCHAR(50),
    browser VARCHAR(50),
    ip_address VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    merchant_id INT,
    device_id INT,
    transaction_date DATETIME,
    transaction_amount DECIMAL(10,2),
    transaction_status VARCHAR(30),
    payment_method VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id),
    FOREIGN KEY (device_id) REFERENCES devices(device_id)
);


CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    payment_date DATETIME,
    payment_status VARCHAR(30),
    payment_gateway VARCHAR(50),
    gateway_fee DECIMAL(10,2),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


CREATE TABLE refunds (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    refund_date DATE,
    refund_amount DECIMAL(10,2),
    refund_reason VARCHAR(100),
    refund_status VARCHAR(30),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


CREATE TABLE fraud_cases (
    fraud_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    fraud_type VARCHAR(100),
    risk_level VARCHAR(30),
    detected_date DATE,
    fraud_status VARCHAR(30),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);
