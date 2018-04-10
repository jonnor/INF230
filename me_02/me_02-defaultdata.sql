USE Yeyland_Wutani;

INSERT INTO departments (depnum, depname) 
VALUES
   (1, 'Accounting'),
   (2, 'Production'),
   (3, 'Development'),
   (4, 'Research'),
   (5, 'Education'),
   (6, 'Management'),
   (7, 'IT');

INSERT INTO positions (positioncode, positionname, description, department_depnum) 
VALUES
   (1, 'President', 'Presides over minions', 6),
   (2, 'Manager', 'Manages minions', 6),
   (3, 'Professional', 'Nobody knows what they do', 3),
   (4, 'Accountant', 'Counts minions', 1),
   (5, 'Data Entry Specialist', 'The person doing all the work', 7);

INSERT INTO locations (locationcode, locationname, address) 
VALUES
   (1, 'Headquaters', '1000 Short Street'),
   (2, 'Par-tea Shop', '123 Cake Street'),
   (3, 'Petting zoo', '1 Highlands'),
   (4, 'IKEA', 'Industrial zone 14a1');

INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode) 
VALUES (1, 'Hendriksen', 'Ola', 2, 1),
   (2, 'Beeblebrox', 'Zaphod', 1, 1),
   (3, 'Anderson', 'Thomas', 5, 1),
   (4, 'Reno', 'Leon', 3, 4),
   (5, 'Durden', 'Tyler', 2, 1),
   (6, 'Larsen', 'Hanne', 4, 1);

INSERT INTO courses (courseID, coursename, location_locationcode, description) 
VALUES
   (1, 'Artisan soap making 101', 2, 'Wash the pain away'),
   (2, 'Advanced anger management', 3, ''),
   (3, 'Artisan tea making', 2, ''),
   (4, 'Spoon bending for beginners', 4, ''),
   (5, 'Artisan soup making', 3, ''),
   (6, 'Building better worlds', 3, ''),
   (7, 'Alien ecology', 4, '');


INSERT INTO historic (event, date, lecturer, employee_eID, courses_courseID, courses_coursename) 
VALUES
   (1, 2017-06-03, 'Jon Nordby', 5, 1, 'Artisan soap making 101'),
   (2, 2017-06-03, 'Jon Nordby', 1, 1, 'Artisan soap making 101'),
   (3, 2017-06-03, 'Jon Nordby', 6, 1, 'Artisan soap making 101'),
   (4, 2017-10-14, 5, 2, 'Advanced anger management'),
   (5, 2017-10-14, 1, 2, 'Advanced anger management'),
   (6, 2017-10-14, 6, 2, 'Advanced anger management'),
   (7, 2017-07-18, 'Jon Nordby', 5, 1, 'Artisan soap making 101'),
   (8, 2017-06-03, 2, 3, 'Artisan tea making 101'),
   (9, 2017-06-03, 3, 3, 'Artisan tea making 101'),
   (10, 2017-03-22, 2, 4, 'Spoon bending for beginners'),
   (11, 2017-03-22, 3, 4, 'Spoon bending for beginners'),
   (12, 2017-04-01, 3, 4, 'Spoon bending for beginners'),
   (13, 2017-04-08, 3, 4, 'Spoon bending for beginners'),
   (14, 2017-04-22, 3, 4, 'Spoon bending for beginners'),
   (15, 2017-01-02, 1, 5, 'Artisan soup making 101');

SELECT * FROM employees;

