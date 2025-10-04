drop database restaurants;
create database restaurants;

\c restaurants

CREATE TABLE Type(TypeID int, Meals varchar(256), PRIMARY KEY (TypeID));
CREATE TABLE Cuisine(CuisineID int, name varchar(32), TypeID int, PRIMARY KEY(CuisineID), FOREIGN KEY (TypeID) REFERENCES Type(TypeID));
CREATE TABLE VegNonVeg(Vegatarain boolean, CuisineID int, FOREIGN KEY (CuisineID) REFERENCES Cuisine(CuisineID));

CREATE TABLE Menu(MenuID int, TypeID  int, PRIMARY KEY (MenuID), FOREIGN KEY (TypeID) REFERENCES Type(TypeID));
CREATE TABLE MainCourse(MainID int, name varchar(32), MenuID int, PRIMARY KEY (MainID), FOREIGN KEY(MenuID) REFERENCES Menu(MenuID));
CREATE TABLE SideCourse(SideID int, name varchar(32), MenuID int, PRIMARY KEY (SideID), FOREIGN KEY(MenuID) REFERENCES Menu(MenuID));
CREATE TABLE Appetizers(AppetizersID int, name varchar(32), MenuID int, PRIMARY KEY (AppetizersID), FOREIGN KEY(MenuID) REFERENCES Menu(MenuID));
CREATE TABLE Drinks(DrinksID int, name varchar(32), MenuID int, PRIMARY KEY (DrinksID), FOREIGN KEY(MenuID) REFERENCES Menu(MenuID));
CREATE TABLE Desserts(DessertsID int, name varchar(32), MenuID int, PRIMARY KEY (DessertsID), FOREIGN KEY(MenuID) REFERENCES Menu(MenuID));

CREATE TABLE Manager(Unique_ID int not null unique, Name varchar(32) not null, EmailAddress varchar(64), PRIMARY KEY (Unique_ID));

CREATE TABLE Restaurants(RegistrationNumber int, ContactNo varchar(10), Address varchar(64), Website varchar(64), Name varchar(32), Rating float, ManagerID int, MenuID int, PRIMARY KEY (RegistrationNumber), FOREIGN KEY (ManagerID) REFERENCES Manager(Unique_ID), FOREIGN KEY (MenuID) REFERENCES Menu(MenuID));

CREATE TABLE Employees(Designation varchar(32), Staff_ID int not null unique, Salary int, Name varchar(32), ManagerID int, RestaurantID int, PRIMARY KEY (Staff_ID), FOREIGN KEY (ManagerID) REFERENCES Manager(Unique_ID), FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RegistrationNumber));

CREATE TABLE ContactNo(Contact_ID int, Contact_Number varchar(10), FOREIGN KEY (Contact_ID) REFERENCES Manager(Unique_ID));

CREATE TABLE Customer(Customer_ID int, Name varchar(32), Contact_No varchar(10), Address varchar(64), Email varchar(64), Payment int, ManagerID int, PRIMARY KEY (Customer_ID), FOREIGN KEY (ManagerID) REFERENCES Manager(Unique_ID));

CREATE TABLE Orders(Order_ID int, Payment int, Time TIME, TrackingID int, TotalAmount int, CustomerID int, MainID int, SideID int, AppetizersID int, DrinksID int, DessertsID int, PRIMARY KEY (Order_ID), RestaurantID int, FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID), FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RegistrationNumber), FOREIGN KEY (MainID) REFERENCES MainCourse(MainID), FOREIGN KEY (SideID) REFERENCES SideCourse(SideID), FOREIGN KEY (AppetizersID) REFERENCES Appetizers(AppetizersID), FOREIGN KEY (DrinksID) REFERENCES Drinks(DrinksID), FOREIGN KEY (DessertsID) REFERENCES Desserts(DessertsID));

CREATE TABLE Rating(Order_ID int, Remarks varchar(256), Rating int default 0 check (Rating>=0 and Rating<=5), Customer_ID int, PRIMARY KEY (Order_ID, Customer_ID), FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID), FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID));
