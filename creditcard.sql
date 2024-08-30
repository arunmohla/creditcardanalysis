
-- -- -- -- CRUD Operations -- -- -- -- 

-- Task 1. Create a New Customer Record
INSERT INTO customers (customer_id, customer_name, customer_email, registration_date)
VALUES
(51, 'Kenel Glu', 'kenel@treepi.com', '2024-07-25');

select * from merchants

-- Task 2. Update email address for Ikea from Merchants table
UPDATE merchants 
SET 
    merchant_email = 'services@ikea.com'
WHERE
    merchant_name = 'IKEA';
    
-- Task 3. Delete a Record from the transactions Table**
-- Objective: Delete the record where transaction_id is 20 from the transactions table.

DELETE FROM transactions 
WHERE
    transaction_id = '20';
    
-- Task 4: Retrieve All Transactions records for a specific customer**
-- Objective: Select all transactions for customer with ID = '2'.

SELECT * FROM transactions
WHERE customer_id = '2';

-- Data Analysis & Findings --

-- Task 5. What is the total, average, minimum, and maximum transaction amount for each customer?

SELECT customer_id, 
       SUM(amount) AS Total_Spent, 
       AVG(amount) AS Average_Spent, 
       MIN(amount) AS Min_Transaction, 
       MAX(amount) AS Max_Transaction
FROM transactions
GROUP BY customer_id;

-- Task 6. Count the number of transactions where the amount is greater than $100 and occurred on a weekend.

SELECT COUNT(*) AS Weekend_Transactions
FROM transactions
WHERE amount > 100 AND DAYOFWEEK(transaction_date) IN (1, 7);

-- Task 7. Question: Calculate the percentage of the total spending each customer contributed.

SELECT customer_id, 
       SUM(amount) AS Total_Spent, 
       ROUND(SUM(amount) / (SELECT SUM(amount) FROM transactions) * 100, 2) AS Percentage_Contribution
FROM transactions
GROUP BY customer_id;

-- Task 8. Retrieve all transactions where the merchant name contains 'Mart' and the transaction amount is between $50 and $500.

SELECT *
FROM transactions
WHERE merchant_name LIKE '%Mart%' AND amount BETWEEN 50 AND 500;

-- Task 9. Identify transactions from merchants located in specific categories ('Electronics', 'Grocery').

SELECT *
FROM transactions t
JOIN merchants m ON t.merchant_name = m.merchant_name
WHERE m.merchant_category IN ('Electronics', 'Grocery');

-- Task 10. List all customers who have made transactions at more than one merchant.

SELECT c.customer_id, c.customer_name, COUNT(DISTINCT t.merchant_name) AS Merchant_Count
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING Merchant_Count > 1;

-- Task 11. Find transactions where the same customer made purchases at the same merchant on consecutive days.

SELECT t1.transaction_id, t1.customer_id, t1.merchant_name, t1.transaction_date, t2.transaction_date
FROM transactions t1
JOIN transactions t2 ON t1.customer_id = t2.customer_id AND t1.merchant_name = t2.merchant_name
WHERE DATEDIFF(t1.transaction_date, t2.transaction_date) = 1;

-- Task 12. Extract the first 3 characters of the merchant names for categorization.

SELECT merchant_name, LEFT(merchant_name, 3) AS Merchant_Category
FROM merchants;

-- Task 13. Identify customers whose total spending is above the overall average spending across all customers.

SELECT customer_id, SUM(amount) AS Total_Spent
FROM transactions
GROUP BY customer_id
HAVING Total_Spent > (SELECT AVG(amount) FROM transactions);

-- Task 14. Categorize each transaction as 'Small', 'Medium', or 'Large' based on the transaction amount.

SELECT 
    transaction_id, customer_id, merchant_name, amount, transaction_date,
    CASE
        WHEN amount < 100 THEN 'Small'
        WHEN amount BETWEEN 100 AND 300 THEN 'Medium'
        ELSE 'Large'
    END AS transaction_size
FROM transactions
ORDER BY transaction_size;

-- Task 15. Question: Identify potentially fraudulent transactions where the transaction amount exceeds 2 times the average transaction amount for the customer.

SELECT t1.transaction_id, t1.customer_id, t1.merchant_name, t1.amount, t1.transaction_date
FROM transactions t1
JOIN (
    SELECT customer_id, AVG(amount) AS avg_transaction_amount
    FROM transactions
    GROUP BY customer_id
) t2 ON t1.customer_id = t2.customer_id
WHERE t1.amount >= 2 * t2.avg_transaction_amount;

-- End of Project --