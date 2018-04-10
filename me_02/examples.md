
## Example queries

### List of all the departments

```sql
SELECT depnum,depname FROM departments;
```

```
+--------+-------------+
| depnum | depname     |
+--------+-------------+
|      1 | Accounting  |
|      2 | Production  |
|      3 | Development |
|      4 | Research    |
|      5 | Education   |
|      6 | Management  |
|      7 | IT          |
+--------+-------------+
```

### Number of departments with 1 or more employees

```sql
TODO
```

### Name and time of all courses that have been held

```sql
SELECT date,coursename FROM events JOIN courses ON courses_courseID = courseID;
```

```
+------------+-----------------------------+
| date       | coursename                  |
+------------+-----------------------------+
| 2017-06-03 | Artisan soap making 101     |
| 2017-10-14 | Advanced anger management   |
| 2017-07-18 | Artisan soap making 101     |
| 2017-06-03 | Artisan tea making          |
| 2017-03-22 | Spoon bending for beginners |
| 2017-04-01 | Spoon bending for beginners |
| 2017-04-08 | Spoon bending for beginners |
| 2017-04-22 | Spoon bending for beginners |
| 2017-01-02 | Artisan soup making         |
| 2017-01-01 | Building better worlds      |
| 2017-12-12 | Building better worlds      |
| 2017-02-11 | Alien ecology               |
+------------+-----------------------------+
```

###  List of all employees and which courses they have taken
Including employees that have not taken any

```sql
TODO
```

```

```
