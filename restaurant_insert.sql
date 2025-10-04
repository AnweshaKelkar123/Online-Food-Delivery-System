\c restaurants


INSERT INTO Type values (1, 'Breakfast');
INSERT INTO Type values (2, 'Lunch');
INSERT INTO Type values (3, 'Dinner');

INSERT INTO Cuisine values (1, 'Chinese', 3);
INSERT INTO Cuisine values (2, 'Continental', 1);
INSERT INTO Cuisine values(3, 'Indian', 2);

INSERT INTO VegNonVeg values (true, 3);
INSERT INTO VegNonVeg values (false, 2);
INSERT INTO VegNonVeg values (false, 1);

INSERT INTO Menu values (1, 1);
INSERT INTO Menu values (2, 2);
INSERT INTO Menu values (3, 3);

INSERT INTO MainCourse values (1, 'Burger', 2);
INSERT INTO MainCourse values (2, 'Pizza', 2);
INSERT INTO MainCourse values (3, 'Roll', 3);

INSERT INTO SideCourse values (1, 'Momo', 1);
INSERT INTO SideCourse values (2, 'Fries', 2);

INSERT INTO Appetizers values (1, 'Soup', 1);

INSERT INTO Drinks values (1, 'Coke', 2);
INSERT INTO Drinks values (2, 'Water', 1);

INSERT INTO Desserts values (1, 'Ice Cream', 1);

INSERT INTO Manager values (1, 'Rajesh Kumar', 'rajeshkumar@gmail.com');
INSERT INTO Manager values (2, 'Smita Kumar', 'smitakumar@gmail.com');

INSERT INTO Restaurants values (1, '9876543210', 'Indiranagar, Bengaluru', 'mcdonalds.com', 'McDonalds', 4, 2, 2);
INSERT INTO Restaurants values (2, '9976543210', 'Koramangala, Bengaluru', 'kfc.com', 'KFC', 5, 1, 2);

INSERT INTO Employees values ('Cook', 1, 10000, 'Hari', 2, 1);
INSERT INTO Employees values ('Cook', 2, 10000, 'Harita', 1, 2);

INSERT INTO ContactNo values (1, '9999999999');
INSERT INTO ContactNo values (2, '9898989898');

INSERT INTO Customer values (1, 'Priya', '8976543210', 'JP Nagar, Bengaluru', 'priya@gmail.com', 1, 1);

INSERT INTO Orders values (1, 1, '03:40:00', 1, 5000, 1, 1, 1, 1, 2, 1 );

INSERT INTO Rating values (1, 'Cool', 4, 1); 
