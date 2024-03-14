--******************************************************************
-- Group 06
-- Student1 Name: Luwam Goitom-Worre Student1 ID: 156652224
-- Student2 Name: Chidera Osondu Student2 ID: 174098210
-- Student3 Name: Brandon Davis Student3 ID: 123539223
-- Date: The date of assignment completion
-- Purpose: Assignment 1 - DBS311
-- All the content other than your sql code should be put in comment block.
-- Include your output in a comment block following with your sql code.
-- Remember add ; in the end of your statement for each question.
--******************************************************************

-- Q1 solution

SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE hire_date
BETWEEN '2016-09-01' AND '2016-10-31'
ORDER BY hire_date, employee_id;


-- EMPLOYEE_ID FIRST_NAME LAST_NAME  HIRE_DAT
-- ----------- ---------- ---------- --------
--         101 Annabelle  Dunn       16-09-17
--           2 Jude       Rivera     16-09-21
--          11 Tyler      Ramirez    16-09-28
--          27 Kai        Long       16-09-28
--          12 Elliott    James      16-09-30
--          46 Ava        Sullivan   16-10-01
--          24 Callum     Jenkins    16-10-10
--          49 Isabella   Cole       16-10-15
--          42 Amelia     Myers      16-10-17
--          39 Kian       Griffin    16-10-26
--          31 Ellis      Washington 16-10-30



-- Q2 solution

SELECT DISTINCT o1.customer_id
FROM orders o1
JOIN orders o2 
ON o1.customer_id = o2.customer_id 
AND o1.order_id <> o2.order_id
ORDER BY o1.customer_id;

-- CUSTOMER_ID
-- -----------
--           1
--           2
--           3
--           4
--           5
--           6
--           7
--           8
--           9
--          16
--          17
-- 
-- CUSTOMER_ID
-- -----------
--          18
--          44
--          45
--          46
--          47
--          48
--          49



-- Q3 solution

SELECT manager_id AS "Manager ID", first_name || ' ' || last_name AS "Full Name"
FROM employees
WHERE manager_id IS NOT NULL
AND manager_id IN (
    SELECT manager_id
    FROM employees
    GROUP BY manager_id
    HAVING COUNT(*) = 1
)
ORDER BY manager_id;

-- Manager ID Full Name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ---------- ----------------
--          3 Louie Richardson                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
--        102 Amelie Hudson                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
--        106 Summer Payne                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   



-- Q4 solution

SELECT product_id AS "Product ID", order_date AS "Order Date", COUNT(*) AS "Number of orders"
FROM order_items
JOIN orders 
ON order_items.order_id = orders.order_id
WHERE order_date 
BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY product_id, order_date
HAVING COUNT(*) != 1
ORDER BY order_date, product_id;

-- Product ID Order Date Number of orders
-- ---------- ---------- ----------------
--        163 16-06-13                  2
--         71 16-08-16                  2
--         93 16-08-16                  2
--         62 16-08-24                  2
--          1 16-11-29                  2
--         96 16-11-29                  2


-- Q5 solution

SELECT
    c.customer_id AS "CUSTOMER ID",
    c.name AS "NAME"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id IN (7, 40, 94)
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT oi.product_id) = 3
ORDER BY c.customer_id;

-- CUSTOMER ID NAME                                                                                                                                                                                                                                                           
-- ----------- -----------------------
--           6 Community Health Systems                                                                                                                                                                                                                                       




-- Q6 solution

SELECT salesman_id AS "Employee ID", COUNT(order_id) AS "Number of Orders"
FROM orders
WHERE salesman_id IS NOT NULL
GROUP BY salesman_id
HAVING COUNT(order_id) = (
    SELECT MAX(COUNT(order_id))
    FROM orders
    WHERE salesman_id IS NOT NULL
    GROUP BY salesman_id
)
ORDER BY salesman_id;

-- Employee ID Number of Orders
-- ----------- ----------------
-- 62               13

-- Q7 solution

SELECT
    TO_CHAR(order_date, 'MM') AS "Month Number",
    TO_CHAR(order_date, 'Month') AS "Month",
    TO_CHAR(order_date, 'YYYY') AS "Year",
    COUNT(DISTINCT o.order_id) AS "Total Number of Orders",
    SUM(oi.quantity * oi.unit_price) AS "Sales Amount"
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE TO_CHAR(order_date, 'YYYY') = '2017'
GROUP BY TO_CHAR(order_date, 'MM'), TO_CHAR(order_date, 'Month'),
TO_CHAR(order_date, 'YYYY')
ORDER BY TO_CHAR(order_date, 'MM');

-- Month Number   Month     Year      Total Number of Orders    Sales Amount
-- -----------    ------    ----      ----------------------    ------------
-- 01             January   2017      5                         2281459.09
-- 02             February  2017      13                        7919446.52
-- 03             March     2017      4                         2246625.47
-- 04             April     2017      2                         609150.35
-- 05             May       2017      4                         1367115.47
-- 06             June      2017      1                         926416.51
-- 08             August    2017      5                         2539537.86
-- 09             september 2017      4                         1675983.52
-- 10             October   2017      2                         2040864.95
-- 11             November  2017      1                         307842.27

-- Q8 solution

SELECT EXTRACT(MONTH FROM Order_Date) AS "Month Number",
 TO_CHAR(Order_Date, 'Month') AS "Month",
 ROUND(AVG(Sales_Amount), 2) AS "Average Sales Amount"
 FROM orders 
WHERE EXTRACT(YEAR FROM Order_Date) = 2017 
GROUP BY EXTRACT(MONTH FROM Order_Date), TO_CHAR(Order_Date, 'Month') 
HAVING ROUND(AVG(Sales_Amount), 2) > ( 
SELECT AVG(Sales_Amount)
 FROM orders WHERE EXTRACT(YEAR FROM Order_Date) = 2017 
) 
ORDER BY EXTRACT(MONTH FROM Order_Date);


-- Q9 solution

SELECT First_Name 
FROM EMPLOYEES 
WHERE First_Name LIKE 'B%' AND First_Name NOT IN ( 
    SELECT First_Name 
    FROM CONTACTS 
)
ORDER BY First_Name;

-- FIRST_NAME                                                                                                                                                                                                                                                     
-- -----------
-- Bella
-- Blake



-- Q10 solution

 -- Calculate the number of employees with total order amount over the average order amount WITH AvgOrderAmount AS ( 
SELECT AVG(Sales_Amount) AS AverageOrderAmount
 FROM orders 
) 
, EmployeeOrderTotals AS (
 SELECT e.Employee_ID, COUNT(o.Order_ID) AS TotalOrders, SUM(o.Sales_Amount) AS TotalSalesAmount 
FROM employees e 
LEFT JOIN orders o ON e.Employee_ID = o.Employee_ID 
GROUP BY e.Employee_ID
 ) 
SELECT COUNT(*) AS "The number of employees with total order amount over average order amount"
 FROM EmployeeOrderTotals eot 
JOIN AvgOrderAmount aoa ON eot.TotalSalesAmount > aoa.AverageOrderAmount;


-- Calculate the number of employees with total number of orders greater than 10 
SELECT COUNT(*) AS "The number of employees with total number of orders greater than 10" FROM EmployeeOrderTotals WHERE TotalOrders > 10;

 -- Calculate the number of employees with orders 
 SELECT COUNT(*) AS "The number of employees with orders" FROM EmployeeOrderTotals;