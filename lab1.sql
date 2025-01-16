/*Write a query to display the tomorrow’s date in the following format:

    September 16th of year 2022

the result will depend on the day when you RUN/EXECUTE this query. 

Label the column Tomorrow.*/

select 
to_char(current_date+1,'Month ddth" of Year" YYYY')
as "Tomorrow"
from dual;


/*
Question 2
2
 Points
Write a query that displays the full name and job title of the manager for 
employees whose job title is "Finance Manager" in the following format:

Jude Rivera works as Administration Vice President.

The query returns 1 row.

Sort the result based on employee ID.
*/
--self
select e1.first_name ||''||e1.last_name||'works as'||e1.job_title
as
"full name and job title"
from employees e1, employees e2
where e2.job_title='Finance Manager'
and e2.manager_id=e1.employee_id;




/*

Question 3
2
 Points
For employees hired in November 2016, display the employee’s last name,
hire date and calculate the number of months between the current date 
and the date the employee was hired, considering that if an employee worked
over half of a month, it should be counted as one month.

Label the column Months Worked.

The query returns 5 rows.

Sort the result first based on the hire date column and then based on the employee's last name. */
select * from employees;
SELECT 
    last_name,
    hire_date,
   trunc(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "Months Worked"
FROM 
    employees
WHERE     
   hire_date >= TO_DATE('01/11/2016', 'DD/MM/YYYY')
    AND hire_date < TO_DATE('01/12/2016', 'DD/MM/YYYY')
order by hire_date,
last_name;



/*

Question 4
2
 Points
Display each employee’s last name, hire date, and the review date, 
which is the first Friday after five months of service.
Show the result only for those hired before January 20, 2016. 

Label the column REVIEW DATE. 
Format the dates to appear in the format like:
TUESDAY, January the Thirty-First of year 2016
You can use ddspth to have the above format for the day.
Sort first by review date and then by last name.
The query returns 6 rows.
*/
select * from employees;
SELECT 
    last_name,
    To_CHAR(hire_date,'DAY, Month "the" ddspth "of year" YYYY') AS hire_date,   
    TO_CHAR(
        NEXT_DAY(ADD_MONTHS(hire_date, 5), 'FRIDAY'), 
        'DAY, Month "the" ddspth "of year" YYYY'
    ) AS "REVIEW DATE"
FROM 
    employees
WHERE 
    hire_date < TO_DATE('20-JAN-2016', 'DD-MON-YYYY')
ORDER BY 
    "REVIEW DATE",
    last_name;


/*


Question 5
2
 Points
For all warehouses, display warehouse id, warehouse name, city, and state.
For warehouses with the null value for the state column, display “unknown”.
Sort the result based on the warehouse ID.

The query returns 9 rows.*/

select * from warehouses;
select * from locations;

select a.warehouse_id, a.warehouse_name,
b.city,b.state
from warehouses a
LEFT JOIN 
locations b
ON 
a.location_id=b.location_id;




