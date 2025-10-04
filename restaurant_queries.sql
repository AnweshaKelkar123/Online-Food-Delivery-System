

SELECT * FROM employees;

SELECT registrationnumber,address,rating FROM restaurants;

SELECT contactno,website FROM restaurants WHERE rating=5;

DELETE FROM employees WHERE staff_id=1;

UPDATE restaurants SET rating=4 WHERE name='KFC';



SELECT name, designation FROM employees WHERE salary >
(SELECT avg(salary) FROM employees);

SELECT * FROM restaurants WHERE rating >  (SELECT avg(rating) FROM restaurants) GROUP BY registrationnumber;

SELECT name, avg(rating) FROM restaurants group by name;


UPDATE employees SET salary=1.15*salary WHERE managerid=2;

SELECT e.name from employees e, restaurants r WHERE(e.restaurantid=r.registrationnumber and  r.rating =  (SELECT min(rating) FROM restaurants));



CREATE USER Aliyah WITH ENCRYPTED PASSWORD 'Aliyah123';

GRANT ALL PRIVILEGES ON DATABASE restaurants TO Aliyah;

CREATE USER Anwesha WITH ENCRYPTED PASSWORD 'Anwesha123';

GRANT UPDATE ON restaurants TO Anwesha;

CREATE USER Arunav WITH ENCRYPTED PASSWORD 'Arunav123';

GRANT SELECT, INSERT, UPDATE ON employees TO Arunav;

GRANT INSERT ON ALL TABLES IN SCHEMA PUBLIC TO Aliyah;

GRANT DELETE ON ALL TABLES IN SCHEMA PUBLIC TO Aliyah;

ALTER USER Anwesha LOGIN;

ALTER USER Anwesha CREATEROLE;

ALTER USER Anwesha CREATEDB;

ALTER USER Arunav CREATEDB;

GRANT CONNECT ON DATABASE restaurants to Anwesha;

GRANT INSERT ON employees TO Arunav;

GRANT ALL PRIVILEGES ON manager to Arunav;

CREATE ROLE Disha nologin;

DROP ROLE Disha;



CREATE FUNCTION emp_stamp() RETURNS trigger as $emp_stamp$
BEGIN
IF NEW.Name IS NULL THEN RAISE EXCEPTION 'Name cannot be null';
END IF;
RETURN NEW;
END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON restaurants FOR EACH ROW EXECUTE FUNCTION emp_stamp();



CREATE TABLE emp_audit( operation char(1) NOT NULL, stamp timestamp NOT NULL, userid text NOT NULL, empname text NOT NULL, salary integer);

 CREATE OR REPLACE FUNCTION process_emp_audit() RETURNS TRIGGER AS $emp_audit$
 BEGIN                                                                                             
 IF (TG_OP= 'DELETE') THEN                                                                         
 INSERT INTO emp_audit SELECT 'D', now(), user,OLD.name, OLD.salary;                               
 ELSEIF (TG_OP='UPDATE') THEN                                                                      
 INSERT INTO emp_audit SELECT 'U',now(),user, OLD.name, OLD.salary;                                
 ELSEIF(TG_OP='INSERT')                                                                            
 THEN INSERT INTO emp_audit SELECT 'I',now(),user,NEW.name, NEW.salary;                            
 END IF;                                                                                           
 RETURN NULL;                                                                                      
 END;                                                                                              
 $emp_audit$ LANGUAGE plpgsql;

CREATE TRIGGER emp_audit
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION process_emp_audit();



CREATE FUNCTION salary_stamp() RETURNS trigger as $salary_stamp$                   
BEGIN                                                                                             
IF NEW.salary<=0 THEN RAISE EXCEPTION 'Please enter a valid salary';                              
END IF;                                                                                           
RETURN NEW;                                                                                       
END;                                                                                              
$salary_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER salary_stamp                                                         
AFTER INSERT OR UPDATE ON employees                                                               
FOR EACH ROW EXECUTE FUNCTION salary_stamp();



CREATE OR REPLACE FUNCTION snitch() RETURNS event_trigger AS $$
BEGIN
RAISE NOTICE 'snitch: % %',tg_event, tg_tag;
END;
$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER snitch ON ddl_command_start EXECUTE FUNCTION snitch();



CREATE OR REPLACE FUNCTION get_employees_name()
RETURNS text as $$
DECLARE
names text default '';
new_name record;
emp_deets cursor
FOR SELECT name
FROM employees;
BEGIN
open emp_deets;
loop
fetch emp_deets into new_name;
exit when not found;
names:=names||', '||new_name.name;
end loop;
close emp_deets;
return names;
end;
$$
language 'plpgsql';



CREATE OR REPLACE FUNCTION get_restaurant_details()
RETURNS text as $$
DECLARE
details text default '';
new_rest record;
rest_deets cursor
for select name, address
from restaurants;
begin
open rest_deets;
loop
fetch rest_deets into new_rest;
exit when not found;
details:=details||', '||new_rest.name||':'||new_rest.address;
end loop;
close rest_deets;
return details;
end;
$$
language 'plpgsql';


