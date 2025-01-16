set serveroutput on;
/
create or replace procedure check_number(num in number) is
begin
    if num=0 then 
        dbms_output.put_line('The number is zero.');
    elsif num>0 then
        dbms_output.put_line(' This is a positive number.');         
    else
          dbms_output.put_line('This is a negative number.');
       
    end if;
end;
/
/
begin
check_number(1);
end;
/

/
create or replace procedure factorial(num in number) is
    result number:=1;
    begin
   
    if num=0 then
        dbms_output.put_line('The factorial of '|| num || 'is 0');
    else
        for i in 1..num loop
            result:=result*i;
        end loop;
        dbms_output.put_line('The factorial of '|| num || ' is '|| result);
        end if;
  
        end;
/
/
begin
    factorial(3);
end;
/
        
        
        
  /      
begin
    factorial(3);
    end;
    /
    
    
/
create or replace procedure total(num in number) is
    result number:=0;
begin
    for i in 1..num loop
        result :=result+i;
    end loop;
    dbms_output.put_line('The total os ' || result);
    end;
    /
    /
    begin
    total(5);
    end;
    /

/
create or replace procedure even_number(num in number)is
begin
    dbms_output.put_line('Even numbers between 1 and '|| num || ' : ');
    for i in 1..num loop
        if mod(i,2)=0 then
            dbms_output.put_line(i);
        else
            null;
        end if;
    end loop;
end;
        /
    
   /
   begin
        even_number(10);
        end;
        /







