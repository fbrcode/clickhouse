# Assignment: ClickHouse SQL

60 minutes to complete
42 student solutions

Let us implement the things that were covered in this chapter. You are required to solve the questions here.

There can be multiple correct answers and don't worry if your answer is slightly different from the one I have posted. Good luck!

---

1. You are required to come up with SQL statements for the scenarios mentioned

2. Try the SQL statements once in your local environment before posting. You will never know if it is working unless you execute it.

3. You are encouraged to refer to the documentation

Questions for this assignment

You are tasked with creating tables in ClickHouse to store the data of students who were enrolled in an e-learning platform. The following information will be stored in the table.

- Name
- ID (Unique ID - integers)
- Age
- DateOfBirth
- Gender
- City
- Country

Create a database called clickhouse_assignment. Next, create a table called students under this database with the necessary columns and appropriate data types.

```sql
CREATE DATABASE clickhouse_assignment;
```

```sql
CREATE TABLE clickhouse_assignment.students
(
Name String,
ID String,
Age UInt8,
DateOfBirth Date,
Gender LowCardinality(String),
City String,
Country String
)
Engine=Log;

/* Suggestion

CREATE TABLE clickhouse_assignment.students
(
Name String,
ID UInt32,
Age UInt8,
DateOfBirth Date,
Gender LowCardinality(String),
City LowCardinality(String),
Country String
)
Engine = Log;

*/
```

> Note: You can use Log table engine for now

Add another table in this database called exam_scores to store the marks scored by the students in different courses with following information.

- ID
- Course
- Score
- Pass (Either Pass of Fail)
- DateOfExam

```sql
CREATE TABLE clickhouse_assignment.exam_scores
(
ID String,
Course LowCardinality(String),
Score UInt8,
Pass Enum('Fail'=0,'Pass'=1),
DateOfExam Date
)
Engine=Log;

/* Suggestion

CREATE TABLE clickhouse_assignment.exam_scores
(
ID UInt32,
Course String,
Score UInt32,
Pass Enum('Pass' = 1, 'Fail' = 0),
DateOfExam Date
)
Engine = Log;

*/
```

> Note: You can use Log table engine for now

Insert data available in the students tab of SQL_Assignment_part1.xlsx file in to the students table, by constructing an INSERT statement

```sql
INSERT INTO clickhouse_assignment.students (Name, ID, Age, DateOfBirth, Gender, City, Country) VALUES ('A', '1', 25, '1998-11-25', 'Male', 'London', 'UK');
INSERT INTO clickhouse_assignment.students (Name, ID, Age, DateOfBirth, Gender, City, Country) VALUES ('B', '2', 35, '1988-02-01', 'Female', 'New York', 'US');
INSERT INTO clickhouse_assignment.students (Name, ID, Age, DateOfBirth, Gender, City, Country) VALUES ('C', '3', 42, '1981-10-11', 'Male', 'California', 'US');
INSERT INTO clickhouse_assignment.students (Name, ID, Age, DateOfBirth, Gender, City, Country) VALUES ('D', '4', 19, '2004-05-23', 'Female', 'Manchester', 'UK');
INSERT INTO clickhouse_assignment.students (Name, ID, Age, DateOfBirth, Gender, City, Country) VALUES ('E', '5', 55, '1968-12-05', 'Female', 'London', 'UK');
```

Insert data available in the scores tab of SQL_Assignment_part1.xlsx file in to the exam_scores table, by constructing an INSERT statement

```sql
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('1', 'Python', 60, 'Pass', '2023-06-05');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('2', 'C++', 70, 'Pass', '2023-06-06');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('3', 'Java', 75, 'Pass', '2023-06-02');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('4', 'Go', 55, 'Pass', '2023-06-14');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('5', 'Python', 85, 'Pass', '2023-06-22');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('1', 'C++', 45, 'Fail', '2023-06-08');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('2', 'Java', 90, 'Pass', '2023-06-09');
INSERT INTO clickhouse_assignment.exam_scores (ID, Course, Score, Pass, DateOfExam) VALUES ('3', 'Go', 65, 'Pass', '2023-06-21');
```

Find the name and the ID of all the students who were from UK (From students table)

```sql
SELECT Name, ID FROM clickhouse_assignment.students WHERE Country = 'UK';
```

Find the ID of all the students who had attempted the exam on Python (From exam_scores table)

```sql
SELECT ID FROM clickhouse_assignment.exam_scores WHERE Course = 'Python';
```

Find the name of all the students who have attempted and passed the exam on Java

```sql
SELECT s.Name
FROM clickhouse_assignment.students s
JOIN clickhouse_assignment.exam_scores es ON s.ID = es.ID
WHERE es.Course = 'Java' AND es.Pass = 'Pass';
```

Resource files: SQL_Assignment_part1.xlsx
