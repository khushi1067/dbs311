select * from employees;
SELECT
    last_name,
    hire_date
    FROM
    employees
    WHERE 
    hire_date<(SELECT hire_date FROM employees WHERE employee_id=101)
    AND
    hire_date >=
    '2016-07-31'
    ORDER BY hire_date,employee_id;


select  * from customers;
SELECT 
    name,
    credit_limit
    FROM customers
    WHERE 
    credit_limit =(SELECT MIN(credit_limit)FROM customers)
    ORDER BY
    customer_id;

select * from products;
SELECT 
    category_id,
    product_id,
    product_name,
    list_price 
    FROM products 
    WHERE 
    list_price=ANY((SELECT MIN(list_price)FROM products
    GROUP BY category_id))
    ORDER BY category_id,product_id;

select * from products;
SELECT
    a.category_id ,
    b.category_name
    FROM
    products a
    INNER JOIN
    product_categories b
    ON
    a.category_id=b.category_id
    WHERE 
    list_price=(SELECT MAX(list_price)FROM products);


select * from products;
SELECT
    product_name,
    list_price
    FROM 
    products
    WHERE
    category_id=2 
    AND
    list_price>ANY(SELECT MAX(list_price)
    FROM products
    GROUP BY category_id)
    ORDER BY list_price,product_id;


select * from products;
select * from product_categories;

SELECT c.category_id, MAX(p.list_price) AS

  maximum_price

  FROM product_categories c

  JOIN products p ON p.category_id = c.category_id

  WHERE p.list_price = (

  SELECT MAX(list_price)

  FROM products)

  GROUP BY c.category_id;

SELECT
    category_id,
    MAX(list_price)
    FROM
    products
    GROUP BY
    category_id
    HAVING MIN(list_price)=(SELECT MIN(list_price)
    FROM
    products);






