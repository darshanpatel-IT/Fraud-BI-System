-- Q1. Show all customers
SELECT *
FROM customers;

-- Q2. Show all merchants
SELECT *
FROM merchants;

-- Q3. Show all transactions
SELECT *
FROM transactions;

-- Q4. Find all successful transactions
SELECT *
FROM transactions
WHERE transaction_status = 'success';

-- Q5. Find all failed transactions
SELECT *
FROM transactions
WHERE transaction_status = 'failed';

SELECT COUNT(*) AS failed_transaction
FROM transactions
WHERE transaction_status = 'failed';

SELECT COUNT(*)  AS successful_transaction
FROM transactions
WHERE transaction_status = 'success';

SELECT COUNT(*) AS pending_transaction
FROM transactions
WHERE transaction_status = 'pending';
  
-- Q6. Count total transactions made by each customer.  
  
SELECT c.customer_id,
       c.customer_name,
       COUNT(t.transaction_id) AS total_transaction
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_transaction DESC;   

-- Q7 – Find the Top 10 customers by total successful transaction amount.    
  
SELECT c.customer_id,
	   c.customer_name,
       SUM(t.transaction_amount) AS total_successful_transaction_amount
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE transaction_status = 'success'
GROUP BY c.customer_id,c.customer_name
ORDER BY total_successful_transaction_amount DESC
LIMIT 10;       
       
-- Q8. Find the Top 10 Merchants by Successful Revenue 
  
SELECT m.merchant_id,
       m.merchant_name,
       SUM(t.transaction_amount) AS successful_revenue
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status = 'success'
GROUP BY m.merchant_id , m.merchant_name
ORDER BY successful_revenue DESC
LIMIT 10;
 
-- Q9. Find customers who have made both successful and failed transactions.

SELECT c.customer_id,
       c.customer_name
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(CASE WHEN transaction_status='success'THEN 1 ELSE 0 END)>0  
   AND SUM(CASE WHEN transaction_status='failed'THEN 1 ELSE 0 END)>0 ;

-- Q10. Find merchants with failed transactions
        
SELECT m.merchant_id,
       m.merchant_name,
       COUNT(t.transaction_id) AS failed_transaction
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status = 'failed'
GROUP BY m.merchant_id , m.merchant_name
ORDER BY failed_transaction DESC;        

-- Q11. Calculate success rate for each merchant

WITH merchant_summary AS (
    SELECT m.merchant_id,
           m.merchant_name,
           COUNT(*) AS total_transactions,
           SUM(CASE WHEN t.transaction_status = 'success' THEN 1 ELSE 0 END) AS successful_transactions
    FROM merchants m
    JOIN transactions t
    ON m.merchant_id = t.merchant_id
    GROUP BY m.merchant_id, m.merchant_name
)

SELECT *,
       ROUND((successful_transactions * 100.0) / total_transactions, 2) AS success_rate
FROM merchant_summary
ORDER BY success_rate DESC;

-- Q12. Find customers whose total successful transaction amount is greater than ₹100,000.     
       
SELECT c.customer_id,
       c.customer_name,
       SUM(t.transaction_amount) AS successful_transactions
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE transaction_status = 'success'
GROUP BY c.customer_id , c.customer_name
HAVING successful_transactions > 100000
ORDER BY successful_transactions DESC ;
      
  -- Q13. Find merchants whose total failed transaction amount is greater than ₹50,000.    

SELECT m.merchant_id,
       m.merchant_name,
       SUM(t.transaction_amount) AS failed_transaction_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status = 'failed'
GROUP BY m.merchant_id , m.merchant_name
HAVING  failed_transaction_amount > 50000
ORDER BY failed_transaction_amount DESC;       

-- Q.14 Find payment methods whose total successful transaction amount is greater than ₹100,000.

SELECT payment_method,
       SUM(transaction_amount) AS total_amount
FROM transactions
WHERE transaction_status = 'success'
GROUP BY payment_method
HAVING total_amount > 100000
ORDER BY total_amount DESC;      

-- Q.15 Find customers who have more than 5 failed transactions. 

SELECT c.customer_id,
       c.customer_name,
       COUNT(t.transaction_id) AS failed_transactions
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id  
WHERE transaction_status = 'failed'
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(t.transaction_id) > 5
ORDER BY failed_transactions DESC;     

-- Q.16 Find merchants who have processed more than 10 successful transactions.

SELECT m.merchant_id,
       m.merchant_name,
       COUNT(t.transaction_id) AS successful_transactions
FROM merchants m
JOIN transactions t
ON m.merchant_id  = t.merchant_id
WHERE t.transaction_status = 'success'       
GROUP BY m.merchant_id , m.merchant_name
HAVING COUNT(t.transaction_id) > 10
ORDER BY successful_transactions DESC;

-- Q.17 Find customers whose average successful transaction amount is greater than ₹20,000.

SELECT c.customer_id,
       c.customer_name,
       AVG(t.transaction_amount) AS avg_successful_amount
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'success'       
GROUP BY c.customer_id  , c.customer_name
HAVING AVG(t.transaction_amount) > 20000
ORDER BY avg_successful_amount DESC;

-- Q.18
-- Find merchants who have:

-- more than 20 total transactions, and
-- a success rate greater than 80%.

WITH merchant_summary AS(
SELECT m.merchant_id,
       m.merchant_name,
       COUNT(t.transaction_id) AS total_transactions,
       SUM(CASE WHEN t.transaction_status = 'success' THEN 1 ELSE 0 END ) AS successful_transactions
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id , m.merchant_name
HAVING COUNT(t.transaction_id) > 20
)       
SELECT*,
	   ROUND((successful_transactions*100.0)/total_transactions , 2)  AS success_rate
FROM merchant_summary
WHERE ROUND((successful_transactions*100.0)/total_transactions , 2) > 80.00
ORDER BY success_rate DESC;      
  
-- Q.19 

-- A fraud detection team wants to identify risky customers.

-- Find customers who satisfy all of these conditions:

-- More than 15 total transactions
-- More than 5 failed transactions
-- Total successful transaction amount greater than ₹200,000

SELECT c.customer_id,
       c.customer_name,
       COUNT(t.transaction_id) AS total_transactions,
       SUM(CASE WHEN t.transaction_status = 'failed'THEN 1 ELSE 0 END) AS failed_transaction,
       SUM(CASE WHEN t.transaction_status = 'success' THEN transaction_amount ELSE 0 END ) AS successful_amount
FROM customers c
JOIN transactions t
ON c.customer_id  = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(t.transaction_id) > 15 AND failed_transaction > 5 AND successful_amount > 200000
ORDER BY total_transactions DESC , failed_transaction DESC , successful_amount DESC;  

-- Q.20 ⭐⭐⭐⭐⭐ 

-- The Risk Management team wants to identify high-value customers.

-- Find customers who satisfy all of these conditions:
-- ✅ More than 20 total transactions
-- ✅ Average successful transaction amount greater than ₹25,000
-- ✅ Failed transaction rate less than 15%

WITH customer_summary AS (
    SELECT c.customer_id,
           c.customer_name,
           COUNT(t.transaction_id) AS total_transactions,
           SUM(CASE WHEN t.transaction_status = 'success' THEN 1 ELSE 0 END) AS successful_transactions,
           SUM(CASE WHEN t.transaction_status = 'failed' THEN 1 ELSE 0 END) AS failed_transactions,
           AVG(CASE WHEN t.transaction_status = 'success' THEN t.transaction_amount END) AS avg_successful_amount
    FROM customers c
    JOIN transactions t
    ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_transactions,
       successful_transactions,
       failed_transactions,
       ROUND(avg_successful_amount, 2) AS avg_successful_amount,
       ROUND((failed_transactions * 100.0) / total_transactions, 2) AS failed_transaction_rate
FROM customer_summary
WHERE total_transactions > 20
  AND avg_successful_amount > 25000
  AND (failed_transactions * 100.0) / total_transactions < 15
ORDER BY avg_successful_amount DESC;

-- Q.21 ⭐⭐⭐⭐⭐ 

-- The Fraud Analytics team wants to identify high-risk merchants.

-- Find merchants who satisfy all of the following conditions:

-- ✅ More than 30 total transactions
-- ✅ Failed transaction rate greater than 20%
-- ✅ Total successful transaction amount greater than ₹500,000

WITH merchant_summary AS (
SELECT m.merchant_id,
       m.merchant_name,
       COUNT(t.transaction_id) AS total_transactions,
       SUM(CASE WHEN t.transaction_status= 'success' THEN 1 ELSE 0 END ) AS successful_transactions,
       SUM(CASE WHEN t.transaction_status= 'failed' THEN 1 ELSE 0 END) AS failed_transactions,
       SUM(CASE WHEN t.transaction_status='success' THEN transaction_amount ELSE 0 END) AS successful_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id  = t.merchant_id
GROUP BY m.merchant_id , m.merchant_name       
)
SELECT merchant_id,
       merchant_name,
       total_transactions,
       successful_transactions,
       successful_amount,
       failed_transactions,
       ROUND((failed_transactions*100.0)/total_transactions,2) AS failed_rate
FROM merchant_summary
WHERE  total_transactions > 30
 AND   ROUND((failed_transactions*100.0)/total_transactions,2) > 20.0
 AND   successful_amount > 500000
ORDER BY failed_rate DESC ,successful_amount DESC ; 

-- Q.22 ⭐⭐⭐⭐⭐ 

-- The Risk team wants to find customers who may be suspicious.

-- Find customers who satisfy all of the following conditions:

-- ✅ More than 20 total transactions
-- ✅ Failed transaction rate greater than 25%
-- ✅ Total successful transaction amount greater than ₹300,000
-- ✅ At least 2 different payment methods used

WITH customer_summary AS(
SELECT c.customer_id,
       c.customer_name,
       COUNT(t.transaction_id) AS total_transactions,
       SUM(CASE WHEN t.transaction_status = 'failed' THEN 1 ELSE 0 END) AS failed_transactions,
       SUM(CASE WHEN t.transaction_status = 'success' THEN t.transaction_amount ELSE 0 END) AS successful_amount,
       COUNT(DISTINCT t.payment_method) AS total_method
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
)
SELECT customer_id,
       customer_name,
       total_transactions,
       failed_transactions,
       successful_amount,
       total_method,
       ROUND((failed_transactions*100.0)/total_transactions,2) AS failed_transaction_rate
FROM customer_summary       
WHERE total_transactions > 20
  AND ROUND((failed_transactions*100.0)/total_transactions,2) > 25.0
  AND successful_amount > 300000
  AND total_method >= 2
ORDER BY failed_transaction_rate DESC,
         successful_amount DESC;  

-- Q.23 ⭐⭐⭐⭐⭐ 

-- The Fraud Monitoring team wants to identify risky devices that may be involved in fraudulent activity.

-- Find devices that satisfy all of the following conditions:

-- ✅ More than 50 total transactions
-- ✅ Fraud transaction rate greater than 10%
-- ✅ Total successful transaction amount greater than ₹1,000,000
-- ✅ Used by at least 10 different customers

WITH devices_summary AS (  
 SELECT d.device_id,
        d.device_type,
        COUNT(t.transaction_id) AS total_transactions,
        COUNT(f.fraud_id) AS fraud_transactions,
        SUM(CASE WHEN t.transaction_status = 'success' THEN t.transaction_amount ELSE 0 END) AS successful_amount,
        COUNT(DISTINCT t.customer_id) AS total_customers
FROM devices d
JOIN transactions t
ON d.device_id = t.device_id
LEFT JOIN fraud_cases f
ON t.transaction_id = f.transaction_id
GROUP BY d.device_id , d.device_type
)
SELECT device_id,
       device_type,
       total_transactions,
       fraud_transactions,
       successful_amount,
       total_customers,
       ROUND((fraud_transactions*100.0)/total_transactions,2) AS fraud_transaction_rate
FROM devices_summary       
WHERE total_transactions > 50
  AND ROUND((fraud_transactions*100.0)/total_transactions,2) > 10.0
  AND successful_amount > 1000000
  AND total_customers >= 10
ORDER BY fraud_transaction_rate DESC,
         successful_amount DESC; 
        
-- Q.24 ⭐⭐⭐⭐⭐

-- The Risk team wants to find high-risk payment methods.

-- Find payment methods that satisfy all conditions:

-- ✅ More than 100 total transactions
-- ✅ Failed transaction rate greater than 15%
-- ✅ Fraud transaction rate greater than 5%
-- ✅ Total successful transaction amount greater than ₹2,000,000   

WITH transaction_summary AS(
SELECT t.payment_method,
       COUNT(t.transaction_id) AS total_transactions,
       SUM(CASE WHEN t.transaction_status = 'failed' THEN 1 ELSE 0 END) AS failed_transactions,
       COUNT(f.fraud_id) AS fraud_transactions,
       SUM(CASE WHEN t.transaction_status = 'success' THEN t.transaction_amount ELSE 0 END) AS successful_amount
FROM  transactions t
LEFT JOIN fraud_cases f
ON t.transaction_id = f.transaction_id
GROUP BY t.payment_method
)
SELECT payment_method,
       total_transactions,
       failed_transactions,
       fraud_transactions,
       successful_amount,
       ROUND((failed_transactions*100.0)/total_transactions,2) AS failed_transaction_rate,
       ROUND((fraud_transactions*100.0)/total_transactions,2) AS fraud_transaction_rate
FROM transaction_summary
WHERE total_transactions >100
  AND  ROUND((failed_transactions*100.0)/total_transactions,2) > 15.0
  AND  ROUND((fraud_transactions*100.0)/total_transactions,2) > 5.0
  AND  successful_amount > 2000000
ORDER BY failed_transaction_rate DESC,
         fraud_transaction_rate DESC,
         successful_amount DESC;
      
-- Q.25 — Find the top 5 customers with the highest successful transaction amount.

SELECT c.customer_id,
       c.customer_name,
       SUM(CASE WHEN t.transaction_status = 'success' THEN t.transaction_amount ELSE 0 END) AS successful_transaction_amount
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
ORDER BY successful_transaction_amount DESC
LIMIT 5;       

 -- Q.26
-- Find the top 5 merchants with the highest failed transaction amount.

SELECT m.merchant_id,
       m.merchant_name,
       SUM(t.transaction_amount) AS failed_transaction_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status = 'failed'
GROUP BY m.merchant_id , m.merchant_name
ORDER BY failed_transaction_amount DESC
LIMIT 5;       

-- Q.27
-- Find customers whose total transaction amount (success + failed) is greater than ₹500,000.

SELECT c.customer_id,
       c.customer_name,
       SUM(t.transaction_amount) AS total_amount
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING SUM(t.transaction_amount) > 500000
ORDER BY total_amount DESC;      

-- Q.28
-- Find merchants whose average successful transaction amount is greater than ₹20,000.

SELECT m.merchant_id,
       m.merchant_name,
       AVG(t.transaction_amount) AS avg_successful_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status = 'success'
GROUP BY m.merchant_id , m.merchant_name
HAVING avg_successful_amount > 20000
ORDER BY avg_successful_amount DESC;      

-- Q.29
-- Find payment methods whose total successful transaction amount is greater than ₹1,000,000. 

SELECT payment_method,
       SUM(transaction_amount) AS total_successful_amount
FROM transactions 
WHERE transaction_status = 'success'
GROUP BY payment_method
HAVING total_successful_amount > 1000000
ORDER BY total_successful_amount DESC;      
       
-- Q.30
-- Find customers who have made at least 20 successful transactions.

SELECT c.customer_id,
       c.customer_name,
       COUNT(t.transaction_id) AS successful_transactions
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE transaction_status = 'success'
GROUP BY c.customer_id , c.customer_name
HAVING successful_transactions >=20
ORDER BY successful_transactions DESC;        

-- Q.31
-- Find merchants who have processed transactions from more than 100 unique customers.

SELECT m.merchant_id,
       m.merchant_name,
       COUNT(DISTINCT t.customer_id) AS unique_customers
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id , m.merchant_name
HAVING  COUNT(DISTINCT t.customer_id) > 100
ORDER BY unique_customers DESC;      

-- Q.32
-- Find payment methods whose average successful transaction amount is between ₹10,000 and ₹30,000.

SELECT payment_method,
      AVG(transaction_amount) AS avg_successful_amount
FROM transactions
WHERE transaction_status = 'success'      
GROUP BY payment_method
HAVING avg_successful_amount BETWEEN 10000 AND 30000
ORDER BY avg_successful_amount DESC;

-- Q.33
-- Find customers who have made transactions using more than 3 different payment methods.

SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT t.payment_method) AS total_payment_method
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING  COUNT(DISTINCT t.payment_method) > 3
ORDER BY total_payment_method DESC;        

-- Q.34 — Find merchants whose average successful transaction amount is higher than the overall average successful transaction amount.

SELECT  m.merchant_id,
        m.merchant_name,
        AVG(t.transaction_amount) AS avg_successful_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE t.transaction_status = 'success'
GROUP BY m.merchant_id, m.merchant_name
HAVING AVG(t.transaction_amount) > (
       SELECT AVG(transaction_amount)
       FROM transactions
       WHERE transaction_status = 'success'
)
ORDER BY avg_successful_amount DESC;
       
-- Q.35:
-- Find customers whose total successful transaction amount is higher than the average successful transaction amount per customer.       

 WITH total_amount AS (
 SELECT c.customer_id,
        c.customer_name,
        SUM(t.transaction_amount) AS total_successful_amount
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE transaction_status = 'success'
GROUP BY c.customer_id , c.customer_name
),
 avg_amount AS (
 SELECT AVG(total_successful_amount) AS avg_successful_amount_per_customer
 FROM total_amount
),
 above_avg_amount AS (
 SELECT t.customer_id,
		t.customer_name,
        t.total_successful_amount,
        av. avg_successful_amount_per_customer
FROM total_amount t
CROSS JOIN avg_amount av
WHERE t.total_successful_amount > av. avg_successful_amount_per_customer         
)
SELECT *
FROM above_avg_amount
ORDER BY total_successful_amount DESC,
         avg_successful_amount_per_customer DESC;
 
--  Q.36
-- Find merchants whose failed transaction count is higher than the average failed transaction count per merchant.

WITH total_failed_transactions AS (
SELECT m.merchant_id,
       m.merchant_name,
       COUNT(t.transaction_id) AS failed_transactions
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
WHERE transaction_status ='failed'
GROUP BY m.merchant_id , m.merchant_name       
),
avg_failed_transactions AS (
SELECT AVG(failed_transactions) AS avg_failed_transactions
FROM total_failed_transactions
),
above_failed_transactions AS (
SELECT t.merchant_id,
       t.merchant_name,
       t.failed_transactions,
       av.avg_failed_transactions
FROM total_failed_transactions t
CROSS JOIN avg_failed_transactions av
WHERE t.failed_transactions > av.avg_failed_transactions        
)
SELECT*
FROM above_failed_transactions
ORDER BY failed_transactions DESC,
         avg_failed_transactions DESC;
         
-- Q.37
-- Find customers who have more successful transactions than failed transactions.

SELECT c.customer_id,
       c.customer_name,
       SUM(CASE WHEN t.transaction_status = 'success' THEN 1 ELSE 0 END) AS successful_transactions,
       SUM(CASE WHEN t.transaction_status = 'failed' THEN 1 ELSE 0 END) AS failed_transactions
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING successful_transactions > failed_transactions
ORDER BY successful_transactions DESC,
		 failed_transactions DESC;

-- Q.38
-- Find payment methods where the total successful transaction amount is greater than the total failed transaction amount.

SELECT payment_method,
       SUM(CASE WHEN transaction_status = 'success' THEN transaction_amount ELSE 0 END) AS successful_amount,
       SUM(CASE WHEN transaction_status = 'failed' THEN transaction_amount ELSE 0 END) AS failed_amount
FROM transactions
GROUP BY payment_method
HAVING successful_amount > failed_amount
ORDER BY successful_amount DESC,
         failed_amount DESC;       

-- Q.39
-- Find customers who have made transactions with more than one merchant.

SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT t.merchant_id) AS total_merchants
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(DISTINCT t.merchant_id) > 1
ORDER BY total_merchants DESC,
		c.customer_name;       
       
-- Q.40
-- Find merchants who have received transactions from more than 50 unique customers.

SELECT m.merchant_id,
       m.merchant_name,
       COUNT(DISTINCT customer_id) AS total_customers
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id , m.merchant_name
HAVING COUNT(DISTINCT customer_id) > 50 
ORDER BY total_customers DESC,
         m.merchant_name;
       
-- Q.41
-- Find customers who have used both UPI and Credit Card as payment methods.

SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT CASE WHEN payment_method IN('UPI','Credit card') THEN payment_method END) AS total_methods
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(DISTINCT CASE WHEN payment_method IN ( 'UPI', 'Credit card') THEN payment_method END) = 2
ORDER BY c.customer_id , c.customer_name ;      

-- Q.42
-- Find customers who have transactions in more than 3 different cities of merchants.

select c.customer_id,
       c.customer_name,
       count(distinct m.city)AS total_city ,
       count(distinct t.transaction_id) AS total_transactions  
from customers c
JOIN transactions t
on c.customer_id = t.customer_id
left join merchants m
ON m.merchant_id = t.merchant_id
group by c.customer_id , c.customer_name
having count(distinct m.city) > 3  
order by total_transactions desc,
         total_city desc;  
         
-- Q.43
-- Find merchants where successful transaction amount is at least 3 times failed transaction amount.  

select m.merchant_id,
       m.merchant_name,
       sum(case when t.transaction_status = 'success'then t.transaction_amount else 0 end) as total_successful_amount,
       sum(case when t.transaction_status = 'failed' then t.transaction_amount else 0 end) as total_failed_amount
from merchants m
join transactions t
on m.merchant_id = t.merchant_id
group by m.merchant_id , m.merchant_name
having total_successful_amount >= total_failed_amount*3
order by total_successful_amount desc,
         total_failed_amount desc;       

-- Q.44
-- Find payment methods where the number of successful transactions is greater than the number of failed transactions.

select payment_method,
       sum(case when transaction_status = 'success'then 1 else 0 end) as total_successful_transactions,
	   sum(case when transaction_status = 'failed' then 1 else 0 end) as total_failed_transactions
from transactions
group by payment_method
having total_successful_transactions > total_failed_transactions
order by total_successful_transactions desc , total_failed_transactions desc;

-- Q.45
-- Find customers who have made transactions using at least 4 different payment methods.

select c.customer_id,
       c.customer_name,
       count(distinct t.payment_method) as total_methods
from customers c
join transactions t
on c.customer_id = t.customer_id
group by c.customer_id , c.customer_name
having count(distinct t.payment_method) >= 4 
order by total_methods desc,
		 c.customer_name;       

-- Q.46 Find customers whose average successful transaction amount is greater than ₹20,000.

select c.customer_id,
       c.customer_name,
       avg(t.transaction_amount) as avg_successful_amount
from customers c
join transactions t
on c.customer_id = t.customer_id
where transaction_status = 'success'
group by c.customer_id  , c.customer_name
having avg(t.transaction_amount) > 20000
order by avg_successful_amount desc;       

-- Q.47 Find merchants who have never had a failed transaction.

select m.merchant_id,
       m.merchant_name,
       count( case when t.transaction_status = 'success'then 1 else 0 end) as total_successful_transactions
from merchants m
join transactions t
on m.merchant_id  = t.merchant_id
group by m.merchant_id , m.merchant_name
having count( case when t.transaction_status = 'success'then 1 else 0 end) = 0
order by total_successful_transactions desc;

-- Q.48
-- Find merchants whose fraud transaction count is greater than 5.

select m.merchant_id,
       m.merchant_name,
       count(f.transaction_id) as total_fraud_transactions
from merchants m
join transactions t
on m.merchant_id = t.merchant_id
left join fraud_cases f
on f.transaction_id  = t.transaction_id
group by m.merchant_id  , m.merchant_name
having count(f.transaction_id) > 5
order by total_fraud_transactions desc;     

-- Q.49 (Advanced)
-- Business Scenario

-- The Risk Team wants to identify high-risk customers.

-- Question

-- Find customers who have both:

-- More than 2 failed transactions
-- At least 1 fraud case

select c.customer_id,
       c.customer_name,
       sum(case when t.transaction_status = 'failed' then 1 else 0 end ) as total_failed_transactions,
       count(f.transaction_id) as total_fraud_cases
from customers c
join transactions t
on c.customer_id = t.customer_id
left join fraud_cases f
on f.transaction_id = t.transaction_id
group by c.customer_id, c.customer_name
having sum( case when t.transaction_status = 'failed' then 1 else 0 end )>2
   and count(f.transaction_id) >=1
order by  total_failed_transactions desc,total_fraud_cases desc;
  
-- Q.50 (

-- The Fraud Analytics team wants to identify high-risk merchants.

-- Question

-- Find merchants that satisfy all of the following:

-- Total transactions > 100
-- Fraud transaction rate > 5%
-- Failed transaction rate > 15%
-- Total successful transaction amount > ₹2,000,000
-- Output  

with merchant_summary as(
select m.merchant_id,
       m.merchant_name,
       count(t.transaction_id) as total_transactions,
       count(f.fraud_id) as fraud_transactions,
       sum(case when t.transaction_status = 'failed' then 1 else 0 end) as failed_transactions,
       sum(case when t.transaction_status = 'success' then t.transaction_amount else 0 end) as successful_transaction_amount
from merchants m
join transactions t
on m.merchant_id = t.merchant_id
left join fraud_cases f
on t.transaction_id = f.transaction_id
group by m.merchant_id , m.merchant_name
)
select*,
      round((fraud_transactions*100.0)/total_transactions,2) as fraud_transaction_rate,
      round((failed_transactions*100.0)/total_transactions,2) as failed_transaction_rate
from merchant_summary
where total_transactions >100
    and round((fraud_transactions*100.0)/total_transactions,2) > 5.0
    and round((failed_transactions*100.0)/total_transactions,2) > 15.0   
    and successful_transaction_amount > 2000000
order by  failed_transaction_rate desc,
		  fraud_transaction_rate desc;  
























       






























































         





























       
       




































































































     






       

















































  
  
  
  
  
  
  
  
  
  
  
  