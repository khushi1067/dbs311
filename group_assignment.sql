--******************************************************************
-- Group ##
-- Student1 Name: Your Name Student1 ID: #########
-- Student2 Name: Your Name Student2 ID: #########
-- Student3 Name: Your Name Student3 ID: #########
-- Date: The date of assignment completion
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

select employee_id, first_name, last_name,
hire_date from employees
where hire_date<
(select min(hire_date) from employees
where hire_date between to_date('2016/06/01','YYYY/MM/DD')
and to_date('2016/06/30','YYYY/MM/DD'))
and
hire_date>
(select max(hire_date) from employees
where hire_date between
to_date('2016/02/01','YYYY/MM/DD')
and to_date('2016/02/29','YYYY/MM/DD'))
+ interval '2' month
order by employee_id;


/*
SELECT 
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    HIRE_DATE
FROM 
    employees
WHERE 
    HIRE_DATE < (
        SELECT MIN(HIRE_DATE) 
        FROM employees 
        WHERE HIRE_DATE >= TO_DATE('01/06/2016', 'DD/MM/YYYY') 
          AND HIRE_DATE < TO_DATE('01/07/2016', 'DD/MM/YYYY')
    )
AND 
    HIRE_DATE > (
        SELECT MAX(HIRE_DATE) 
        FROM employees 
        WHERE HIRE_DATE >= TO_DATE('01/02/2016', 'DD/MM/YYYY') 
          AND HIRE_DATE < TO_DATE('01/03/2016', 'DD/MM/YYYY')
    ) + INTERVAL '2' MONTH
ORDER BY 
    HIRE_DATE, EMPLOYEE_ID;
*/
-- Q2 solution
--Write a SQL query to display country ID and country name for countries with more than
--one location. Answer this question without using the group/aggregate functions (count,
--sum, min, max, avg, …).
--Sort the result by country ID
/*
SELECT DISTINCT COUNTRY_ID, COUNTRY_NAME
FROM countries
WHERE COUNTRY_ID IN (
    SELECT COUNTRY_ID
    FROM locations
    GROUP BY COUNTRY_ID
    HAVING COUNT(LOCATION_ID) > 1
)
ORDER BY COUNTRY_ID;
*/
select * from countries;
select * from locations;



select distinct a.country_id, b.country_name
from locations a
join locations c
on
a.country_id=c.country_id
and
a.location_id<>c.location_id
join countries b
on a.country_id=b.country_id;






-- Q3 solution

select distinct a.country_id,b.country_name
from locations a 
join
countries b on a.country_id=b.country_id
minus
select distinct a.country_id, b.country_name
from locations a
join locations c
on
a.country_id=c.country_id
and
a.location_id<>c.location_id
join countries b
on a.country_id=b.country_id;


-- Q4 solution
select * from customers;
select * from orders;

select a.customer_id, 
TO_CHAR(a.order_date, 'Month') as "month_name",
count (a.order_id)as "order_count"
from orders a
join
customers c on
a.customer_id=c.customer_id
where
to_char(a.order_date,'YYYY')='2017'
group by
a.customer_id, to_char(a.order_date,'Month'),
to_char(a.order_date,'YYYY-MM')
having count(a.order_id)>1
order by
to_char(a.order_date,'YYYY-MM'), a.customer_id;


/*
select customer_id, order_date 
from orders
where
order_date between 
to_date('2017/01/01','YYYY/MM/DD')
and
to_date('2017/12/31','YYYY/MM/DD');
*/




-- Q5 solution
select * from products;
select * from orders;
select * from customers;
select * from order_items;

select customer_id, name
from customers;

SELECT c.customer_id, 
       c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id IN (20, 95)
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT oi.product_id) = 2
ORDER BY c.customer_id;


-- Q6 solution
SELECT e.employee_id, 
       COUNT(o.order_id) AS number_of_orders
FROM employees e
JOIN orders o ON e.employee_id = o.salesman_id
GROUP BY e.employee_id
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM orders
        GROUP BY salesman_id
    ) 
)
ORDER BY e.employee_id;






-- Q7 solution
SELECT 
    TO_NUMBER(TO_CHAR(o.order_date, 'MM')) AS month_number,
    TO_CHAR(o.order_date, 'Month') AS month_name,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(oi.unit_price * oi.quantity) AS total_sales_amount
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    TO_CHAR(o.order_date, 'YYYY') = '2017'
GROUP BY 
    TO_CHAR(o.order_date, 'MM'), TO_CHAR(o.order_date, 'Month')
ORDER BY 
    month_number;



-- Q8 solution

SELECT 
    TO_NUMBER(TO_CHAR(o.order_date, 'MM')) AS month_number,
    TO_CHAR(o.order_date, 'Month') AS month_name,
    ROUND(AVG(oi.unit_price * oi.quantity), 2) AS average_sales_amount
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    TO_CHAR(o.order_date, 'YYYY') = '2017'
GROUP BY 
    TO_NUMBER(TO_CHAR(o.order_date, 'MM')), 
    TO_CHAR(o.order_date, 'Month')
HAVING 
    AVG(oi.unit_price * oi.quantity) > (
        SELECT AVG(oi2.unit_price * oi2.quantity)
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE TO_CHAR(o2.order_date, 'YYYY') = '2017'
    )
ORDER BY 
    month_number;


-- Q9 solution
SELECT e.first_name
FROM employees e
WHERE e.first_name LIKE 'B%'
  AND e.first_name NOT IN (SELECT c.first_name FROM contacts c)
ORDER BY e.first_name;



-- Q10 solution


-- Calculate total order amount and total number of orders for each employee
WITH EmpOrders AS (
    SELECT 
        e.employee_id,
        SUM(oi.unit_price * oi.quantity) AS total_order_amt,  -- Assuming order amount is calculated this way
        COUNT(o.order_id) AS total_orders
    FROM 
        employees e
    LEFT JOIN 
        orders o ON e.employee_id = o.salesman_id
    LEFT JOIN 
        order_items oi ON o.order_id = oi.order_id  -- Join with order_items to calculate total amount
    GROUP BY 
        e.employee_id
),

-- Calculate average order amount
AvgOrder AS (
    SELECT 
        AVG(total_order_amt) AS avg_order_amt
    FROM 
        EmpOrders
)

SELECT 
    (SELECT COUNT(*) FROM EmpOrders WHERE total_order_amt > (SELECT avg_order_amt FROM AvgOrder)) AS emp_above_avg,
    (SELECT COUNT(*) FROM EmpOrders WHERE total_orders > 10) AS emp_above_10_orders,
    (SELECT COUNT(*) FROM EmpOrders WHERE total_orders = 0) AS emp_no_orders,
    (SELECT COUNT(*) FROM EmpOrders WHERE total_orders > 0) AS emp_with_orders
FROM 
    dual;








