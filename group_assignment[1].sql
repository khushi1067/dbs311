--******************************************************************
-- Group ##
-- Student1 Name: Juhi Abhay Bhandari Student1 ID: 106758238
-- Student2 Name: Khushi Abhay Bhandari Student2 ID: 106774235
-- Student3 Name: Fariha Shajjan Student3 ID: 166194233
-- Date: 2024/10/16
-- Purpose: Assignment 1 - DBS311
-- All the content other than your sql code should be put in comment block.
-- Include your output in a comment block following with your sql code.
-- Remember add ; in the end of your statement for each question.
--******************************************************************

-- Q1 solution
--Write a query to display employee ID, first name, last name, and hire date for employees
--who have been hired before the first employee hired in June 2016 but two months after
--the last employee hired in February 2016.
--Sort the result by hire date and employee ID.
--The query returns 7 row

SELECT employee_id, first_name, last_name, hire_date 
    FROM  employees
    WHERE hire_date < (SELECT MIN(hire_date) 
                       FROM employees
                       WHERE hire_date BETWEEN TO_DATE('2016/06/01','YYYY/MM/DD')
                       AND TO_DATE('2016/06/30','YYYY/MM/DD'))
    AND hire_date > (SELECT MAX(hire_date) 
                    FROM employees
                    WHERE hire_date BETWEEN TO_DATE('2016/02/01','YYYY/MM/DD')
                    AND TO_DATE('2016/02/29','YYYY/MM/DD'))
    + INTERVAL '2' MONTH
    ORDER BY employee_id;

--output
--Nathan	5	Cox	16-05-21
--Alex	16	Sanders	16-05-18
--Jackson	23	Coleman	16-05-01
--Imogen	75	Boyd	16-05-11
--Esme	79	Warren	16-05-24
--Harriet	97	Ferguson	16-04-24
--Amber	98	Rose	16-05-23


--Q2 solution
--Write a SQL query to display country ID and name for countries with more than one location,
--without using aggregate functions. Sort the result by country ID. The query returns 6 rows.
SELECT DISTINCT A.country_id, B.country_name
    FROM locations A
    JOIN locations C
    ON
    A.country_id = C.country_id
    AND
    A.location_id <> C.location_id
    JOIN countries B
    ON A.country_id = B.country_id;
/*output
IT	Italy
UK	United Kingdom
JP	Japan
CA	Canada
CH	Switzerland
US	United States of America
*/


--Q3 solution
--Use the previous query and SET Operator(s) to display country ID and country name for
--counties with only one location assigned to them. Don't use count, The query returns 8 rows.
--Sort the result by country ID 
SELECT DISTINCT A.country_id,B.country_name
    FROM locations A 
    JOIN
    countries B ON A.country_id=B.country_id

    MINUS

    SELECT DISTINCT A.country_id, B.country_name
    FROM locations A
    JOIN locations C
    ON
    A.country_id=C.country_id
    AND
    A.location_id<>C.location_id

    JOIN countries B

    ON A.country_id=B.country_id;

/*output
AU	Australia
BR	Brazil
CN	China
DE	Germany
IN	India
MX	Mexico
NL	Netherlands
SG	Singapore
*/


-- Q4 solution
-- SQL query to display customers that have been ordered multiple times in one
--month in 2017.
--Display customer ID, month name, and the number of times the customer has ordered on that month.
--Sort the result by order date and customer ID.The query returns 2 rows.
SELECT * FROM customers;
SELECT * FROM orders;

SELECT A.customer_id 
    As "Customer ID",
    to_char(A.order_date, 'Month') AS "Month", COUNT (A.order_id)AS "Number of orders"
    FROM orders A
    JOIN
    customers C ON
    A.customer_id = C.customer_id
    WHERE
    to_char(A.order_date,'YYYY') = '2017'
    GROUP BY
    A.customer_id, to_char(A.order_date,'Month'),
    to_char(A.order_date,'YYYY-MM')
    HAVING COUNT(A.order_id) > 1
    ORDER BY
    to_char(A.order_date,'YYYY-MM'), A.customer_id;

/*output-Q4
48	March    	2
5	April    	2
*/


-- Q5 solution
-- Query to display customer ID and customer name for customers who have
--purchased all these three products: Products with ID 20 and 95.
--Sort the result by customer ID.
--The query returns 2 row.

SELECT C.customer_id AS "Customer ID",
    C.NAME
    FROM customers C
    JOIN orders O ON C.customer_id = O.customer_id
    JOIN order_items oi ON O.order_id = oi.order_id
    WHERE oi.product_id IN (20, 95)
    GROUP BY C.customer_id, C.NAME
    HAVING COUNT(DISTINCT oi.product_id) = 2
    ORDER BY C.customer_id;

/*output-Q5
3	US Foods Holding
16	Aflac
*/

-- Q6 solution
-- Query to display employee ID and the number of orders for employees with the
--number of orders (sales) above average of number of orders managed by a salesperson.
--Sort the result by employee ID. returns three rows
SELECT E.employee_id As "Employee ID", 
    COUNT(O.order_id) AS "Number of Orders"
    FROM employees E
    JOIN orders O ON E.employee_id = O.salesman_id
    GROUP BY E.employee_id
    HAVING COUNT(O.order_id) > (
        SELECT AVG(order_count)
        FROM (
            SELECT COUNT(order_id) AS order_count
            FROM orders
            GROUP BY salesman_id
        ) 
    )
    ORDER BY E.employee_id;


/*output-Q6
62	13
64	12
*/


-- Q7 solution
-- Query to display the month number, month name, total number of customers with
-- orders in each month, and total sales amount for each month in 2017.
--Sort the result according to month number. Returns 10 rows.
SELECT 
    TO_NUMBER(to_char(O.order_date, 'MM')) AS "Month Number",
    to_char(O.order_date, 'Month') AS "Month",
    COUNT(DISTINCT O.customer_id) AS "Total Number of customers",
    SUM(oi.unit_price * oi.quantity) AS "Sales Amount"
    FROM 
    orders O
    JOIN 
    order_items oi ON O.order_id = oi.order_id
    WHERE 
    to_char(O.order_date, 'YYYY') = '2017'
    GROUP BY 
    to_char(O.order_date, 'MM'), to_char(O.order_date, 'Month')
    ORDER BY 
    "Month Number";

/*output-Q7
1	January  	5	2281459.09
2	February 	13	7919446.52
3	March    	3	2246625.47
4	April    	1	609150.35
5	May      	4	1367115.47
6	June     	1	926416.51
8	August   	5	2539537.86
9	September	4	1675983.52
10	October  	2	2040864.95
11	November 	1	307842.27
*/


-- Q8 solution
--Query to display month number, month name, and average sales amount for
--months with the average sales amount greater than average sales amount in 2017. Rounded
--the average amount to two decimal places. Sort the result by the month number.
--query returns 5 rows. 

SELECT 
    TO_NUMBER(to_char(O.order_date, 'MM')) AS "Month Number",
    to_char(O.order_date, 'Month') AS "Month",
    round(AVG(oi.unit_price * oi.quantity), 2) AS "Average Sales Amount"
    FROM 
    orders O
    JOIN 
    order_items oi ON O.order_id = oi.order_id
    WHERE 
    to_char(O.order_date, 'YYYY') = '2017'
    GROUP BY 
    TO_NUMBER(to_char(O.order_date, 'MM')), 
    to_char(O.order_date, 'Month')
    HAVING 
    AVG(oi.unit_price * oi.quantity) > (
        SELECT AVG(oi2.unit_price * oi2.quantity)
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE to_char(o2.order_date, 'YYYY') = '2017'
        )
    ORDER BY 
    "Month Number";
    
/*output-Q8
2	February 	93169.96
3	March    	89865.02
6	June     	132345.22
10	October  	92766.59
11	November 	153921.14
*/


-- Q9 solution
-- Query to display first names in EMPLOYEES that start with letter B but do not
--exist in CONTACTS.
--Sort the result by first name.
--Query returns 2 rows.
SELECT E.first_name
    FROM employees E
    WHERE E.first_name LIKE 'B%'
    AND E.first_name NOT IN (SELECT C.first_name
                             FROM contacts C)
    ORDER BY E.first_name;

/*output-Q9
Bella
Blake
*/


-- Q10 solution


-- Q10 solution(corrected)
-- Calculate total order amount and total number of orders for each employee

WITH emporders AS (
    SELECT 
    E.employee_id,
    SUM(oi.unit_price * oi.quantity) AS total_order_amt,  -- Assuming order amount is calculated this way
    COUNT(O.order_id) AS total_orders
    FROM 
    employees E
    LEFT JOIN 
    orders O ON E.employee_id = O.salesman_id
    LEFT JOIN 
    order_items oi ON O.order_id = oi.order_id  -- Join with order_items to calculate total amount
    GROUP BY 
    E.employee_id
    ),

-- Calculate average order amount
    avgorder AS (
    SELECT 
    AVG(total_order_amt) AS avg_order_amt
    FROM 
    emporders
    )

-- Main query to get the formatted output
SELECT 'The number of employees with total order amount over average order amount:' AS DESCRIPTION,
    (SELECT COUNT(*) FROM emporders WHERE total_order_amt > (SELECT avg_order_amt FROM avgorder)) AS RESULT
    FROM dual
    UNION ALL
    SELECT 'The number of employees with total number of orders greater than 10:' AS DESCRIPTION,
    (SELECT COUNT(*) FROM emporders WHERE total_orders > 10) AS RESULT
    FROM dual
    UNION ALL
    SELECT 'The number of employees with no orders:' AS DESCRIPTION,
    (SELECT COUNT(*) FROM emporders WHERE total_orders = 0) AS RESULT
    FROM dual
    UNION ALL
    SELECT 'The number of employees with orders:' AS DESCRIPTION,
    (SELECT COUNT(*) FROM emporders WHERE total_orders > 0) AS RESULT
    FROM dual;


/*output-Q10
The number of employees with total order amount over average order amount:	3
The number of employees with total number of orders greater than 10:	9
The number of employees with no orders:	98
The number of employees with orders:	9
*/








