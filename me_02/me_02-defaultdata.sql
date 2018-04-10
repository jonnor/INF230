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

INSERT INTO positions (positioncode, positionname, description) 
VALUES
   (1, 'President', 'Presides over minions'),
   (2, 'Manager', 'Manages minions'),
   (3, 'Professional', 'Nobody knows what they do'),
   (4, 'Accountant', 'Counts minions'),
   (5, 'Data Entry Specialist', 'The person doing all the work');

INSERT INTO locations (locationcode, locationname, address) 
VALUES
   (1, 'Headquaters', '1000 Short Street'),
   (2, 'Par-tea Shop', '123 Cake Street'),
   (3, 'Petting zoo', '1 Highlands'),
   (4, 'IKEA', 'Industrial zone 14a1');

INSERT INTO employees (eID, lname, fname, positions_positioncode, location_locationcode, departments_depnum) 
VALUES (1, 'Hendriksen', 'Ola', 2, 1, 6),
   (2, 'Beeblebrox', 'Zaphod', 1, 1, 6),
   (3, 'Anderson', 'Thomas', 5, 1, 4),
   (4, 'Reno', 'Leon', 3, 4, 5),
   (5, 'Durden', 'Tyler', 2, 1, 6),
   (6, 'Larsen', 'Hanne', 4, 1, 1);

INSERT INTO courses (courseID, coursename, description) 
VALUES
   (1, 'Artisan soap making 101', 'Wash the pain away'),
   (2, 'Advanced anger management', ''),
   (3, 'Artisan tea making', ''),
   (4, 'Spoon bending for beginners', ''),
   (5, 'Artisan soup making', ''),
   (6, 'Building better worlds', ''),
   (7, 'Alien ecology', '');


INSERT INTO events (event, date, employees_eID, courses_courseID, location_locationcode) 
VALUES
   (1, '2017-06-03', 3, 1, 2),
   (2, '2017-10-14', 5, 2, 3),
   (3, '2017-07-18', 3, 1, 2),
   (4, '2017-06-03', 4, 3, 2),
   (5, '2017-03-22', 1, 4, 4),
   (6, '2017-04-01', 1, 4, 4),
   (7, '2017-04-08', 1, 4, 4),
   (8, '2017-04-22', 1, 4, 3),
   (9, '2017-01-02', 2, 5, 3),
   (10, '2017-01-01', 6, 6, 3),
   (11, '2017-12-12', 6, 6, 3),
   (12, '2017-02-11', 4, 7, 4);
   
INSERT INTO course_attendance (events_event, employees_eID)
VALUES
	(1, 5),
    (1, 1),
    (1, 6),
    (2, 5),
    (2, 1),
    (2, 6),
    (3, 5),
    (4, 2),
    (4, 3),
    (5, 2),
    (5, 3),
    (6, 3),
    (7, 3),
    (8, 3),
    (9, 1);
    
