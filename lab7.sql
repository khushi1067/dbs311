--Write a stored procedure to calculate the total sales amount for
--customers with more than four orders and display the results using a cursor.
S
set serveroutput on;
create or replace procedure calculate is
  cursor customer is
   SELECT 
        a.customer_id, 
        c.name,
        SUM(b.quantity * b.unit_price) AS totalsales
    FROM 
        customers c
    LEFT JOIN 
        orders a ON c.customer_id = a.customer_id
    LEFT JOIN 
        order_items b ON a.order_id = b.order_id
    GROUP BY a.customer_id, c.name
    HAVING COUNT(a.order_id) > 4
    ORDER BY a.customer_id;

  record customer %ROWTYPE;

BEGIN
  OPEN customer;

  LOOP
    FETCH customer INTO record;

    EXIT WHEN customer%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || record.customer_id);
    DBMS_OUTPUT.PUT_LINE('Customer Name : ' || record.name);
    DBMS_OUTPUT.PUT_LINE('Total Sales: ' || record.totalsales);
    DBMS_OUTPUT.PUT_LINE(' ');

  END LOOP;

  CLOSE customer;

END calculate;
/



/
begin
calculate();

end;
/

set serveroutput on;


/*

Question 2
Question 2
4
 Points
Write a stored procedure using a cursor to display the warehouse IDs and their corresponding locations (City, State, and country ID) for all warehouses.
*/
create or replace procedure display as
    cursor warehouse is
        SELECT 
        a.WAREHOUSE_ID, 
        b.CITY, 
        b.STATE, 
        b.COUNTRY_ID
        FROM 
        WAREHOUSES a
        inner JOIN
        LOCATIONS b 
        ON 
        a.LOCATION_ID = b.LOCATION_ID;

    record warehouse%ROWTYPE;
BEGIN
    open warehouse;

    LOOP
        FETCH warehouse INTO record;
        EXIT WHEN warehouse%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Warehouse ID: '||record.WAREHOUSE_ID);
        DBMS_OUTPUT.PUT_LINE('City: ' || record.CITY );
   DBMS_OUTPUT.PUT_LINE('State: ' || record.STATE );
   DBMS_OUTPUT.PUT_LINE('Country ID: ' || record.COUNTRY_ID);
   DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;

    close warehouse;
END;
/
BEGIN
    display();
END;
/

/*


Question 3
Question 3
2
 Points
Explain the purpose of the EXIT WHEN cursor_name%NOTFOUND; statement in a loop.
*/
