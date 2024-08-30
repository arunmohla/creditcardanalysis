# SQL Project - Credit Card Analysis 

## Project Overview

**Project Title**: Library Management System  
**Database**: `credicardanalysis`

This project involves analyzing credit card transaction data to gain insights into customer spending patterns, merchant activities, and potential fraudulent transactions. By leveraging SQL queries, we aim to uncover trends, identify high-value customers, and detect anomalies in transaction data. The project demonstrates SQL proficiency through the application of various functions and techniques to analyze and interpret complex datasets.

![Credit_Card_Analysis_Project](https://github.com/arunmohla/creditcardanalysis/blob/main/Cover_Photo.png)

## Objectives

1. **Set up the Credit Card Analysis Database**: Create and populate the database with tables for customers, Merchant and Transactions.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **Beginner and Intermediate SQL Queries**: Develop queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/arunmohla/creditcardanalysis/blob/main/ERD.jpg)

- **Database Creation**: Created a database named `creditcardanalysis`.
- **Table Creation**: Created tables for customers, transactions and merchants. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE creditcardanalysis;

-- Create table "Customers"
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    customer_email VARCHAR(100),
    registration_date DATE
);

-- Create table "Transactions"
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    merchant_name VARCHAR(50),
    amount DECIMAL(10, 2),
    transaction_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create table "Merchants"
DROP TABLE IF EXISTS merchants;
CREATE TABLE merchants (
    merchant_name VARCHAR(50) PRIMARY KEY,
    merchant_email VARCHAR(100),
    merchant_category VARCHAR(50)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `customers` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `merchants` table.
- **Delete**: Removed records from the `transaction` table as needed.

**Task 1. Create a New Merchant Record**
-- "(51, 'Kenel Glu', 'kenel@treepi.com', '2024-07-25')"

```sql
INSERT INTO customers (customer_id, customer_name, customer_email, registration_date)
VALUES
(51, 'Kenel Glu', 'kenel@example.com', '2024-07-25');
```
**Task 2: Update email address for Ikea from Merchants table**

```sql
UPDATE merchants 
SET 
    merchant_email = 'services@ikea.com'
WHERE
    merchant_name = 'IKEA';
```

**Task 3: Delete a Record from the transactions Table**
-- Objective: Delete the record where transaction_id is 20 from the transactions table.

```sql
DELETE FROM transactions 
WHERE
    transaction_id = '20';
```

**Task 4: Retrieve All Transactions records for a specific customer**
-- Objective: Select all transactions for customer with ID = '2'.

```sql
SELECT * FROM transactions
WHERE customer_id = '2';
```

### 3. Data Analysis and Findings

**Task 5: What is the total, average, minimum, and maximum transaction amount for each customer?**

```sql
SELECT customer_id, 
       SUM(amount) AS Total_Spent, 
       AVG(amount) AS Average_Spent, 
       MIN(amount) AS Min_Transaction, 
       MAX(amount) AS Max_Transaction
FROM transactions
GROUP BY customer_id;
```

**Task 6: Count the number of transactions where the amount is greater than $100 and occurred on a weekend**.

```sql
SELECT COUNT(*) AS Weekend_Transactions
FROM transactions
WHERE amount > 100 AND DAYOFWEEK(transaction_date) IN (1, 7);
```

**Task 7: Calculate the percentage of the total spending each customer contributed.**:

```sql
SELECT customer_id, 
       SUM(amount) AS Total_Spent, 
       ROUND(SUM(amount) / (SELECT SUM(amount) FROM transactions) * 100, 2) AS Percentage_Contribution
FROM transactions
GROUP BY customer_id;
```

**Task 8:  Retrieve all transactions where the merchant name contains 'Mart' and the transaction amount is between $50 and $500.**

```sql
SELECT *
FROM transactions
WHERE merchant_name LIKE '%Mart%' AND amount BETWEEN 50 AND 500;
```

**Task 9: Identify transactions from merchants located in specific categories ('Electronics', 'Grocery')**

```sql
SELECT *
FROM transactions t
JOIN merchants m ON t.merchant_name = m.merchant_name
WHERE m.merchant_category IN ('Electronics', 'Grocery');
```

**Task 10: List all customers who have made transactions at more than one merchant**:

```sql
SELECT c.customer_id, c.customer_name, COUNT(DISTINCT t.merchant_name) AS Merchant_Count
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING Merchant_Count > 1;
```

**Task 11. Find transactions where the same customer made purchases at the same merchant on consecutive days.**

```sql
SELECT t1.transaction_id, t1.customer_id, t1.merchant_name, t1.transaction_date, t2.transaction_date
FROM transactions t1
JOIN transactions t2 ON t1.customer_id = t2.customer_id AND t1.merchant_name = t2.merchant_name
WHERE DATEDIFF(t1.transaction_date, t2.transaction_date) = 1;
```

**Task 12. Extract the first 3 characters of the merchant names for categorization.**

```sql
SELECT merchant_name, LEFT(merchant_name, 3) AS Merchant_Category
FROM merchants;
```

**-- Task 13. Identify customers whose total spending is above the overall average spending across all customers.)**  

```sql
SELECT customer_id, SUM(amount) AS Total_Spent
FROM transactions
GROUP BY customer_id
HAVING Total_Spent > (SELECT AVG(amount) FROM transactions);
```


**Task 14. Categorize each transaction as 'Small', 'Medium', or 'Large' based on the transaction amount.** 

```sql
SELECT 
    transaction_id, customer_id, merchant_name, amount, transaction_date,
    CASE
        WHEN amount < 100 THEN 'Small'
        WHEN amount BETWEEN 100 AND 300 THEN 'Medium'
        ELSE 'Large'
    END AS transaction_size
FROM transactions
ORDER BY transaction_size;
```

**Task 15. Question: Identify potentially fraudulent transactions where the transaction amount exceeds 2 times the average transaction amount for the customer.**  

```sql
SELECT t1.transaction_id, t1.customer_id, t1.merchant_name, t1.amount, t1.transaction_date
FROM transactions t1
JOIN (
    SELECT customer_id, AVG(amount) AS avg_transaction_amount
    FROM transactions
    GROUP BY customer_id
) t2 ON t1.customer_id = t2.customer_id
WHERE t1.amount >= 2 * t2.avg_transaction_amount;
```

## Conclusion

This project highlights the effective application of SQL in developing and managing a robust library management system. It covers database setup, data manipulation, and advanced querying, demonstrating a strong foundation in data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone https://github.com/arunmohla/SQL_Project_Library_Management.git
   ```
2. **Set Up the Database**: Execute the SQL scripts in the `creditcardanalysis.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `creditcard.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - Arun Mohla

This project showcases SQL skills essential for credit card analysis. 
For any questions or further information about this project, feel free to contact me at:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/arun-mohla-82792111a/)
- **Instagram**: [Follow me](https://www.instagram.com/arun_mohla/)
- **Twitter**: [Follow me](https://x.com/arun_mohla)

Thank you for your interest in this project!
