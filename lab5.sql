/*Question 1
2
 Points
Create a store procedure that accepts a string as input and prints out
the capitalized string along with the number of characters in the string in 
a format as the following examples shows.

Input: flower

FLOWER has 6 characters.
Input: Te$t

TE$T has 4 characters.
The procedure display a proper error message if any error occurs.
*/

/
select * from customers;
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE  capitalString(input in VARCHAR) IS
    c_string VARCHAR(100);
    c_count NUMBER;
BEGIN
    c_string := UPPER(input);
    c_count := LENGTH(input);
    DBMS_OUTPUT.PUT_LINE(c_string || ' has ' || c_count || ' characters.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/

/

BEGIN
    capitalString('flower');
    capitalString('Te$t');
END;
/




/*


Question 2
Question 2
2
 Points
Write a store procedure that takes an integer number as an employee ID and prints the 
number of years that employee has been working in the company. 
Truncate the number of years to the integer part.

See the following sample output:

The employee with ID 1004 has worked 5 years.
The values in the sample output are random numbers and may not match the real 
numbers in the database. 

The procedure display a proper error message if any error occurs.
*/
select * from employees;
/
CREATE OR REPLACE PROCEDURE yearsTaken(id in NUMBER)is
    years NUMBER;
Begin
    select trunc(months_between(sysdate, hire_date)/12)
    into years
    from employees
    where employee_id=id;
        
   dbms_output.put_line('The employee with ID '|| id ||' has worked '|| years ||' years.');
     
Exception
 
  when NO_DATA_FOUND then
        dbms_output.put_line('Error database is empty.');
     when others then
        dbms_output.put_line('error');
end;
/
    
    /
    begin
        yearstaken(1);
    end;
    /


/*


Question 3
Question 3
2
 Points
Create a stored procedure named find_product.
This procedure gets an integer number as product ID 
and prints the product name, list price, category name for that product .
The procedure gets a value as the product ID of type NUMBER.
See the following sample output for product ID 132: 
Product name: Intel Core i7-5930K
List price: 554.99
Category name: CPU
The procedure display a proper error message if any error occurs.
*/
/
create or replace procedure find_product(productID in number) is
    productName varchar(100);
    listPrice number;
    categoryName varchar(100);
begin
    select p.product_name,
           p.list_price, 
           c.category_name
           into
           productName,
           listPrice,
           categoryName
           from 
           products p
           inner join 
           product_categories c
           on
           p.category_id=c.category_id
           where 
           p.product_id=productID;
           
    dbms_output.put_line('Product Name: ' || productName);
    dbms_output.put_line('List Price: ' || listprice);
    dbms_output.put_line('Catrgoey Name: ' || categoryName);

Exception

     when NO_DATA_FOUND then
        dbms_output.put_line('Error database is empty.');

    when others then
        dbms_output.put_line('An error occured' || sqlerrm);
    
end;

/

/
begin
    find_product(132);
    END;
    /
/*


Question 4
Question 4
2
 Points
NOTE: For this question, create a table exactly the same as the products table.
CREATE TABLE new_products AS
SELECT *
FROM products;
Do not include the create statement in your answer.
Use this new_products table to finish the following update on list prices.
The company applies a yearly price increase of 2% to all products in certain 
categories if it satisfy a certain amount limit. Write a stored procedure takes
an integer parameter representing the category ID, and a numerical parameter of 
type NUMBER(9,2) as amount. The stored procedure will increase the list price of 
all products in the given category by 2% only if the average list price of that 
category is lower than the provided amount (before the increasing).
The procedure has two parameters:
•  categoryID in NUMBER
•  amount in NUMBER
Name your procedure as newprice. In your procedure, if it updates the new_products 
successfully, a message of the number of the updated rows should be returned. 
The procedure display a proper error message if any error occurs. See the
following sample outputs:
Test1:
BEGIN
  newprice(2, 10000);
END;
Output1:
50 rows are updated.
Test2:
BEGIN
  newprice(1, 500);
END;
Output2 ( just a reference ):
Average of 1 is 1386.97, which is no lower than 500. We won't update the price!
*/
/
CREATE TABLE new_products AS
SELECT *
FROM products;

CREATE OR REPLACE PROCEDURE newprice(categoryID IN NUMBER, amount IN NUMBER) is
    average NUMBER;
    Rcount NUMBER;
    Tcount NUMBER;
BEGIN
    SELECT AVG(list_price)
    INTO average
    FROM new_products
    WHERE category_id = categoryID;

    IF average < amount THEN
        SELECT COUNT(*)
        INTO Rcount
        FROM new_products
        WHERE category_id = categoryID;

        UPDATE new_products
        SET list_price = list_price * 1.02
        WHERE category_id = categoryID;

        SELECT COUNT(*)
        INTO Tcount
        FROM new_products
        WHERE category_id = categoryID;

        DBMS_OUTPUT.PUT_LINE(Rcount || ' rows updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Average of category ' || categoryID || ' is ' || average || ', which is no lower than ' || amount || '. No price updates.');
    END IF;

EXCEPTION

 WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error database is empty.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ');
END;


/
BEGIN
  newprice(2, 10000);
END;
/    
/
BEGIN
  newprice(1, 500);
END;
/

select * from products;

/

BEGIN
  newprice(1, 500);
END;
/






/*

Question 5
Question 5
2
 Points
The company needs a report that shows three categories of customers based on their
credit limits: low, average, and high. 
To determine the category of customers, the minimum credit limit, maximum credit
limit, and the average credit limit of all customers must be calculated.

If the credit limit is less than (average credit limit + minimum credit limit) / 2, then the customer’s credit limit is low.
If the credit limit is greater than (maximum credit limit + average credit limit) / 2, then the customer’s credit limit is high.
If the credit limit is between (average credit limit + minimum credit limit) / 2 and (maximum credit limit + average credit limit) / 2, then the customer’s credit limit is average.
Write a procedure named creditreport to show the number of customers in each category:



See the following sample output:

The number of customers with average credit limit: 23
The number of customers with high credit limit: 55
The number of customers with low credit limit: 17 


The values in the above examples are just random values and may not match the real numbers in your result.

The procedure has no parameter. First, you need to find the average, minimum, and maximum credit limit in your database and store them into variables avgCredit, minCredit, and maxCredit.

You need more three variables to store the number of customers in each category: avg_count, high_count, low_count

Make sure you choose a proper type for each variable. You may need to define more variables based on your solution.

The procedure display a proper error message if any error occurs.



*/

CREATE OR REPLACE PROCEDURE creditReport IS
    average NUMBER;
    min NUMBER;
    max NUMBER;
    
    acount NUMBER;
    hcount NUMBER;
    lcount NUMBER;

BEGIN
    SELECT AVG(credit_limit),
           MIN(credit_limit),
           MAX(credit_limit)
    INTO average, min, max
    FROM customers;

    SELECT COUNT(*)
    INTO lcount
    FROM customers
    WHERE credit_limit < (average + min) / 2;

    SELECT COUNT(*)
    INTO hcount
    FROM customers
    WHERE credit_limit > (average + max) / 2;

    SELECT COUNT(*)
    INTO acount
    FROM customers
    WHERE credit_limit <= (average + max) / 2 
      AND credit_limit >= (average+ min) / 2;

    DBMS_OUTPUT.PUT_LINE('The number of customers with average credit limit: ' || acount);
    DBMS_OUTPUT.PUT_LINE('The number of customers with high credit limit: ' || hcount);
    DBMS_OUTPUT.PUT_LINE('The number of customers with low credit limit: ' || lcount);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The database is empty.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

    
    
    /
BEGIN
creditReport();
END;
/
    




