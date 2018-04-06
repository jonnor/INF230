CREATE TABLE Student ( 
stu_id char(9) NOT NULL,
stu_fname char(20) NOT NULL,
stu_lname char(20) NOT NULL,
CONSTRAINT PRIMARY KEY StudentPK(stu_id)
);

CREATE TABLE Department ( 
dep_code char(4) NOT NULL,
dep_name char(40) NOT NULL UNIQUE,
CONSTRAINT PRIMARY KEY DepartmentPK(dep_code)
);

CREATE TABLE Instructor ( 
ins_id char(9) NOT NULL,
ins_fname char(20) NOT NULL,
ins_lname char(20) NOT NULL,
dep_code char(4) NOT NULL, 
CONSTRAINT PRIMARY KEY InstructorPK(ins_id),
CONSTRAINT FOREIGN KEY (dep_code) REFERENCES Department(dep_code)
);

CREATE TABLE Location ( 
loc_code char(5) NOT NULL,
loc_name char(40) NOT NULL,
loc_country char(2) NOT NULL,
CONSTRAINT PRIMARY KEY LocationPK(loc_code)
);

CREATE TABLE Course ( 
crs_code char(10) NOT NULL,
crs_title varchar(100) NOT NULL,
crs_credits tinyint NOT NULL,
dep_code char(4) NOT NULL,
crs_description varchar(255) NOT NULL,
CONSTRAINT PRIMARY KEY CoursePK(crs_code),
CONSTRAINT FOREIGN KEY (dep_code) REFERENCES Department(dep_code)
);

CREATE TABLE Section ( 
sec_id int NOT NULL,
sec_term char(8) NOT NULL,
sec_bldg char(6),
sec_room char(4),
sec_time char(10),
crs_code char(10) NOT NULL,
loc_code char(5) NOT NULL,
ins_id char(9) REFERENCES Instructor(ins_id),
CONSTRAINT PRIMARY KEY SectionPK(sec_id),
CONSTRAINT FOREIGN KEY (crs_code) REFERENCES Course(crs_code),
CONSTRAINT FOREIGN KEY (loc_code) REFERENCES Location(loc_code),
CONSTRAINT FOREIGN KEY (ins_id) REFERENCES Instructor(ins_id)
);

CREATE TABLE Enrollment ( 
stu_id char(9),
sec_id int,
grade_code char(2),
CONSTRAINT PRIMARY KEY EnrollmentPK(stu_id, sec_id),
CONSTRAINT FOREIGN KEY (stu_id) REFERENCES Student(stu_id),
CONSTRAINT FOREIGN KEY (sec_id) REFERENCES Section(sec_id)

);

CREATE TABLE Prerequisite ( 
crs_code char(10),
crs_requires char(10),
CONSTRAINT PRIMARY KEY PrerequisitePK(crs_code, crs_requires),
CONSTRAINT FOREIGN KEY (crs_code) REFERENCES Course(crs_code),
CONSTRAINT FOREIGN KEY (crs_requires) REFERENCES Course(crs_code)
);

CREATE TABLE Qualified (
ins_id char(9),
crs_code char(10),
CONSTRAINT PRIMARY KEY QualifiedPK(ins_id, crs_code),
CONSTRAINT FOREIGN KEY (ins_id) REFERENCES Instructor(ins_id),
CONSTRAINT FOREIGN KEY (crs_code) REFERENCES Course(crs_code)

);