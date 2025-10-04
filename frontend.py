from os import system, name
import psycopg2 
from psycopg2 import Error

def menu():
    clear()
    print("\t\tOnline Food Ordering System")
    print("1. Select all employees")
    print("2. Select all restaurants")
    print("3. Filter restaurants by rating")
    print("4. Select the employees who work in restaurants with the least rating")
    print("5. Update rating of a restaurant")
    print("6. Select employees whose salary is more than average")
    print("7. Create trigger to accept a valid salary")
    print("8. Group restaurants and their average rating by their name")
    print("9. Update all employees salary under a given manager")
    print("0. Exit")
    c = input()
    if c == "":
        menu()

    c = int(c)
    if c==0:
        exit() 
    elif c==1:
        select_query = """select * from  employees;"""
        cursor.execute(select_query)
        rows = cursor.fetchall()
        for row in rows:
            print("Designation: ", row[0]) 
            print("Staff ID: ", row[1])
            print("Salary: ", row[2]) 
            print("Name: ", row[3]) 
            print("Manager ID: ", row[4]) 
            print("Restaurant ID: ", row[5]) 
            print("-----------------------") 
        print("Read command successfully\n")
        input()
        clear()

    elif c==2:
        select_query = """select registrationnumber,address,rating from restaurants;"""
        cursor.execute(select_query)
        rows = cursor.fetchall()
        for row in rows:
            print("Registration Number: ", row[0]) 
            print("Address: ", row[1])
            print("Rating: ", row[2]) 
            print("-----------------------") 

        print("Read command successfully\n")
        input()
        clear()

    elif c==3:
        rating=int(input("Enter valid rating: "))
        while(rating<=0 or rating>5):
        	print("Invalid number. Rating must be between 0 and 5")
        	rating=int(input("Enter valid rating: "))
        rating=str(rating)
        select_query = """SELECT contactno,website FROM restaurants WHERE
        rating="""+rating+""";"""
        cursor.execute(select_query, rating)
        rows = cursor.fetchall()
        for row in rows:
            print("Contact No.: ", row[0]) 
            print("Website: ", row[1])
            print("-----------------------") 

        input()
        clear()

    elif c==4:
        select_query = """SELECT e.name from employees e, restaurants r WHERE(e.restaurantid=r.registrationnumber and  r.rating =  (SELECT min(rating) FROM restaurants));"""
        cursor.execute(select_query)
        rows = cursor.fetchall()
        for row in rows:
            print("Name: ", row[0]) 
            print("-----------------------") 
        print("Read command successfully\n")
        input()
        clear()
        pass

    elif c==5:
        rest_id = ""
        while not (rest_id.isnumeric()):
        	rest_id = str(input("Enter the Restaurant ID : "))

        rating = ""
        while not (rating.isnumeric() and int(rating)>0 and int(rating)<=5):
        	rating = str(input("Enter a new valid rating (between 0 and 5) : "))
        select_query = """UPDATE restaurants SET rating="""+rating+"""WHERE
        registrationnumber="""+rest_id+""";"""
        cursor.execute(select_query)
        print("Updated successfully\n")
        input()
        clear()


    elif c==6:
        select_query = """SELECT name, designation FROM employees WHERE salary >
    (SELECT avg(salary) FROM employees);"""
        cursor.execute(select_query)
        rows = cursor.fetchall()
        for row in rows:
            print("Name: ", row[0]) 
            print("Designation: ", row[1])
            print("-----------------------") 
        print("Read command successfully\n")
        input()
        clear()

    elif c==7:
        func_query = """CREATE FUNCTION salary_stamp() RETURNS trigger as $salary_stamp$                   
    BEGIN                                                                                             
    IF NEW.salary<=0 THEN RAISE EXCEPTION 'Please enter a valid salary';                              
    END IF;                                                                                           
    RETURN NEW;                                                                                       
    END;                                                                                              
    $salary_stamp$ LANGUAGE plpgsql;"""


        trigger_query = """CREATE TRIGGER salary_stamp                                                         
    AFTER INSERT OR UPDATE ON employees                                                               
    FOR EACH ROW EXECUTE FUNCTION salary_stamp();"""


        cursor.execute(func_query)
        cursor.execute(trigger_query)

        print("Trigger created successfully\n")
        input()
        clear()

    elif c==8:
        select_query = """SELECT name, avg(rating) FROM restaurants group by name;"""
        cursor.execute(select_query)
        rows = cursor.fetchall()
        for row in rows:
            print("Name: ", row[0]) 
            print("Average Rating: ", row[1])

            print("-----------------------") 

        print("Read command successfully\n")
        input()
        clear()

    elif c==9:
        print("Enter the Manager ID : ")
        mgr_id = ""
        while not (mgr_id.isnumeric()):
            mgr_id = str(input())
        mgr_id=str(mgr_id)
        print("Enter the salary change (%) : ")
        sal = ""
        while not (sal.isnumeric()):
            sal = str(input())
        #sal = float(sal)
        sal = (int(sal)/100) + 1
        sal=str(sal)
        select_query = """UPDATE employees SET salary="""+sal+"""*salary WHERE
        managerid="""+mgr_id+""";"""
        cursor.execute(select_query)
        print("Updated successfully\n")
        input()
        clear()

    menu()

def clear():
    if name == 'nt':
        _ = system('cls')
    else:
        _ = system('clear')

try:
    # Connect to an existing database
    clear()
    connection = psycopg2.connect(user="postgres",
            password="postgres",
            host="127.0.0.1",
            port="5432",
            database="restaurants")
    cursor = connection.cursor()

    #Creating a user
    #select_query = """CREATE USER Aliyah WITH ENCRYPTED PASSWORD 'Aliyah123';"""
    #cursor.execute(select_query)
    print("Created user successfully\n")
    select_query = """GRANT ALL PRIVILEGES ON DATABASE restaurants TO Aliyah;"""
    cursor.execute(select_query)
    print("Granted all privileges successfully\n")
    select_query = """GRANT INSERT ON ALL TABLES IN SCHEMA PUBLIC TO Aliyah;"""
    cursor.execute(select_query)
    print("Granted insert permissions successfully\n")
    select_query = """GRANT DELETE ON ALL TABLES IN SCHEMA PUBLIC TO Aliyah;"""
    cursor.execute(select_query)
    print("Granted delete permissions successfully\n")

    #Altering the Schema
    alter_query = """ALTER SCHEMA foodordering RENAME TO Food_Ordering;"""
    cursor.execute(alter_query)
    print("Successfully altered schema name\n")
    alter_query = """ALTER SCHEMA Food_Ordering OWNER TO Aliyah;"""
    cursor.execute(alter_query)
    print("Successfully altered schema owner\n")

    #Altering constraints
    alter_query = """ALTER TABLE Drinks 
RENAME COLUMN name TO beverage;"""
    cursor.execute(alter_query)
    print("Successfully altered column name\n")

    alter_query = """ALTER TABLE Desserts 
ADD COLUMN Eggless varchar;"""
    cursor.execute(alter_query)
    print("Successfully added new column to schema \n")

    alter_query = """ALTER TABLE Desserts 
ALTER COLUMN Eggless
SET DEFAULT 'Not specified';"""
    cursor.execute(alter_query)
    print("Successfully set default value to existing column\n")


    #Trigger 1
    select_query = """CREATE FUNCTION emp_stamp() RETURNS trigger as $emp_stamp$
    BEGIN
    IF NEW.Name IS NULL THEN RAISE EXCEPTION 'Name cannot be null';
    END IF;
    RETURN NEW;
    END;
    $emp_stamp$ LANGUAGE plpgsql;"""
    trigger_query = """CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON restaurants FOR EACH ROW EXECUTE FUNCTION emp_stamp();"""
    cursor.execute(select_query)
    cursor.execute(trigger_query)
    print("Trigger 1 created successfully\n")

    #Trigger 2
    create_query = """CREATE TABLE emp_audit( operation char(1) NOT NULL, stamp timestamp NOT NULL, userid text NOT NULL, empname text NOT NULL, salary integer);"""
    func_query = """ CREATE OR REPLACE FUNCTION process_emp_audit() RETURNS TRIGGER AS $emp_audit$
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
     $emp_audit$ LANGUAGE plpgsql;"""
    trigger_query = """CREATE TRIGGER emp_audit
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW EXECUTE FUNCTION process_emp_audit();"""
    cursor.execute(create_query)
    cursor.execute(func_query)
    cursor.execute(trigger_query)
    print("Trigger 2 created successfully\n")

    #Trigger 3
    funct_query = """CREATE OR REPLACE FUNCTION snitch() RETURNS event_trigger AS $$
    BEGIN
    RAISE NOTICE 'snitch: % %',tg_event, tg_tag;
    END;
    $$ LANGUAGE plpgsql;"""
    trigger_query = """CREATE EVENT TRIGGER snitch ON ddl_command_start EXECUTE FUNCTION snitch();"""
    cursor.execute(funct_query)
    cursor.execute(trigger_query)
    print("Trigger 3 created successfully\n")

    #Cursor 1
    func_query = """CREATE OR REPLACE FUNCTION get_employees_name()
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
    language 'plpgsql';"""
    cursor.execute(func_query)
    print("Cursor function created successfully\n")

    #Cursor 2
    funct_query = """CREATE OR REPLACE FUNCTION get_restaurant_details()
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
    language 'plpgsql';"""
    cursor.execute(funct_query)
    print("Cursor function 2 created successfully\n")

    #Altering table
    alter_query= """ALTER TABLE restaurants ADD CONSTRAINT phnocheck CHECK
    (length(contactno) = 10);"""

    input()
    clear()
    menu()


except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL, error:", error)

finally:
    if connection:
        cursor.close()
        connection.close()
        print("\n\n(∗ ･‿･)ﾉ゛Bye\n\n")
