/*Display the total number of products and the total order amount for each order id 
where the total number of products is less than 70. Sort the result based on the order id.

See the labels for the column labels in your result:

Order ID    Total Quantity  Total Amount
--------  ----------------- -----------------
This query returns 4 rows.
*/
select * from products;

SELECT o.order_id AS "Order ID",
    SUM(a.quantity) AS "Total Quantity",
    SUM(a.quantity * a.unit_price)AS "Total Amount"
FROM
    orders o
JOIN
    order_items a 
ON
    o.order_id=a.order_id
GROUP BY
    o.order_id
HAVING
SUM(a.quantity)<70
ORDER BY
    o.order_id;

/*


Question 2
2
 Points
For all customer, display customer number, 
customer full name, and the total number of orders issued by the customer. 

If the customer does not have any orders, the number of orders shows 0.
Display only customers whose customer name starts with 'G' and ends with 's'.
Sort the result first by the number of orders and then by customer ID.
See the column labels in the output:
CUSTOMER_ID  NAME          Number of Orders
------------ ---------  ------------------------------  
This query returns 6 rows.
*/

SELECT * from customers;
SELECT * FROM ORDERS;

SELECT 
    c.customer_id,
    c.name AS "NAME",
COUNT(o.order_id) as "Number of Orders"
FROM customers c
LEFT join
orders o
ON c.customer_id = o.customer_id
WHERE
c.name LIKE'G%s'
GROUP BY 
    c.customer_id, 
    c.name
    order by 
    count(o.order_id),
    c.customer_id;
    
/*
SELECT 
    c.customer_id AS "Customer Number",
    c.name,
    COUNT(o.order_id) AS "Number of Orders"
FROM 
    customers c
LEFT JOIN 
    orders o 
    ON
c.customer_id = o.customer_id
WHERE 
    c.name LIKE 'G%s'
GROUP BY 
    c.customer_id, 
    c.name
ORDER BY 
    COUNT(o.order_id) ASC, c.customer_id ASC;







/*


Question 3
2
 Points
Write a SQL statement to display Category ID, Category Name, the average
list_price, and the number of products for all categories in the product_categories table.

For categories in product_categories that do not have any matching rows 
in products, the average price and the number of products are shown as 0.
Round the average price to one decimal places.
Sort the result by category ID.
See the output labels:

CATEGORY_ID     CATEGORY_NAME    Average Price   Number of Products
------------ ---------------- ---------------- ------------------------
 
This query returns 5 rows.
*/
SELECT
    c.category_id,
    c.category_name,
    TRUNC(AVG(p.list_price), 1) AS "Average Price",
    COUNT(p.product_id) AS "Number of Products"
FROM
    product_categories c
LEFT JOIN
    products p 
ON
    c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    c.category_id;
/*


Question 4
2
 Points
Write a SQL statement to display the number of different products a
nd the total quantity of all products for each warehouse.

Sort the result according to the quantity of all products.

See the output column labels:

WAREHOUSE_ID  Number of Different Products   Quantity of all products
------------  ----------------------------  -------------------------------
This query returns 9 rows.
*/
SELECT
    w.WAREHOUSE_ID,
    COUNT(DISTINCT oi.PRODUCT_ID) AS "Number of Different Products",
    SUM(oi.QUANTITY) AS "Quantity of all products"
FROM
   inventories oi
JOIN
    WAREHOUSES w
ON
    oi.warehouse_id=w.warehouse_id
GROUP BY
    w.WAREHOUSE_ID
ORDER BY
    SUM(oi.QUANTITY) DESC;
/*
Question 5
2
 Points
Write a SQL statement to display the number of warehouses for each region.

Display the region id, the region name and the number of warehouses in your result.
Sort the result by the region id.


See the labels of output columns:

REGION_ID         Region Name      Number of Warehouses
---------- -------------------  -------------------------------
select * from orders;
*/
SELECT
    r.region_id,
    r.region_name as "Region Name",
    COUNT(w.warehouse_id) AS "Number of Warehouses"
FROM
    regions r
LEFT JOIN
    warehouses w 
ON 
    r.region_id = w.location_id
GROUP BY
    r.region_id,
    r.region_name
ORDER BY
    r.region_id;


