--Write a SQL query to show the total number of customers and 
--employees in the database.

--The query returns one row.


SELECT 'Total number of customers and employees: ' || COUNT(*) AS "REPORT"
FROM (
    SELECT customer_id FROM customers
    UNION ALL
    SELECT employee_id FROM employees
);


--Write a SQL query to display number of customers with no order.

--You are not allowed to use JOINs to answer this question.


SELECT COUNT(*) AS "Number of Customers"
FROM (
    SELECT customer_id FROM customers
    MINUS
    SELECT customer_id FROM orders
);

--Write a SQL query to display the number of customers with orders 
--and the number of sales persons who have generated orders.
--Please display the numbers as the following output.
--
SELECT 
    'Number of customers with orders: ' || 
    (SELECT COUNT(DISTINCT customer_id) FROM orders) AS "REPORT"
FROM dual
UNION ALL
SELECT 
    'Number of salespersons: ' || 
    (SELECT COUNT(DISTINCT salesman_id) FROM orders) AS "REPORT"
FROM dual;

--Write a SQL query to display contacts who share the first name and 
--the first letter of the last name (case-sensitive) with an employee(s).

--You are not allowed to use JOINs in this query.

--Sort the result by first name and the first letter of last name.






SELECT first_name,
    substr(last_name, 1, 1) 
    AS "first_letter_of_last_name"
    FROM contacts
    INTERSECT
    SELECT 
    first_name, 
    substr(last_name, 1, 1) 
    AS "first_letter_of_last_name"
    FROM 
    employees
    ORDER 
    BY 
    first_name, 
    "first_letter_of_last_name";

--Write a SQL query to display location ID and warehouse ID for all locations, including locations without a warehouse.

--You are not allowed to use JOINs.

--First display locations with no warehouse and then locations with a warehouse .
--For locations with no warehouse, display NULL for the warehouse ID.

/*(SELECT location_id, NULL AS warehouse_id  
 FROM locations
 MINUS
 SELECT location_id, warehouse_id
 FROM warehouses)

UNION

(SELECT location_id, warehouse_id
 FROM locations
 WHERE location_id IN (SELECT location_id FROM warehouses))

ORDER BY warehouse_id IS NULL, location_id;
*/
SELECT 
    location_id, NULL AS "warehouse_id"
    FROM 
    (SELECT location_id FROM locations
    MINUS SELECT location_id
    FROM warehouses)
    UNION ALL
    SELECT location_id, 
    warehouse_id
    FROM warehouses;





