CREATE DATABASE IF NOT EXISTS clickhouse_assignment_3;


CREATE TABLE IF NOT EXISTS clickhouse_assignment_3.students (
    ID UInt32,
    Name LowCardinality(String),
    Age UInt8,
    DateOfBirth Date,
    Gender LowCardinality(String),
    City LowCardinality(String),
    Country LowCardinality(String),
)
ENGINE = MergeTree()
ORDER BY (ID, Name)
PRIMARY KEY ID;

CREATE TABLE IF NOT EXISTS clickhouse_assignment_3.student_scores (
    ID UInt32,
    Course LowCardinality(String),
    Score UInt8,
    Pass Enum('Pass'=1, 'Fail'=0),
    DateOfExam Date,
)
ENGINE = MergeTree()
ORDER BY (ID, Course)
PRIMARY KEY ID;

CREATE MATERIALIZED VIEW IF NOT EXISTS clickhouse_assignment_3.summed_scores 
    ENGINE = SummingMergeTree() 
    ORDER BY (ID)
    AS (
        SELECT
            ID, 
            Score as ScoreSum
        FROM clickhouse_assignment_3.student_scores
    )


INSERT INTO clickhouse_assignment_3.student_scores (ID, Course, Score, Pass, DateOfExam) VALUES
    (1,'Python',60,'Pass',toDate('2023-06-05')),
    (2,'C++',70,'Pass',toDate('2023-06-06')),
    (3,'Java',75,'Pass',toDate('2023-06-02')),
    (4,'Go',55,'Pass',toDate('2023-06-14')),
    (5,'Python',85,'Pass',toDate('2023-06-22')),
    (1,'C++',45,'Fail',toDate('2023-06-08')),
    (2,'Java',90,'Pass',toDate('2023-06-09')),
    (3,'Go',65,'Pass',toDate('2023-06-21'));


SELECT * FROM clickhouse_assignment_3.summed_scores;

CREATE TABLE IF NOT EXISTS clickhouse_assignment_3.students_unique (
    ID UInt32,
    Name LowCardinality(String),
    Age UInt8,
    DateOfBirth Date,
    Gender LowCardinality(String),
    City LowCardinality(String),
    Country LowCardinality(String),
)
ENGINE = ReplacingMergeTree()
ORDER BY ID
PRIMARY KEY ID;


INSERT INTO clickhouse_assignment_3.students_unique (Name,ID,Age,DateOfBirth,Gender,City,Country) VALUES
('A',1,25,toDate('1998-11-25'),'Male','London','UK');


INSERT INTO clickhouse_assignment_3.students_unique (Name,ID,Age,DateOfBirth,Gender,City,Country) VALUES
('A',1,25,toDate('1998-11-25'),'Male','Manchester','UK');


OPTIMIZE TABLE clickhouse_assignment_3.students_unique;


SELECT * FROM clickhouse_assignment_3.students_unique;

CREATE TABLE IF NOT EXISTS clickhouse_assignment_3.course_ratings (
    CourseID UInt32,
    Course LowCardinality(String),
    ReviewerID UInt32,
    Rating UInt8,
    Feedback String,
    ReviewVersion UInt32,
    Sign Int8,
    CONSTRAINT check_sign CHECK (Sign = 1 OR Sign = -1),
    CONSTRAINT check_rating CHECK (Rating <= 100)
)
ENGINE = VersionedCollapsingMergeTree(Sign, ReviewVersion)
ORDER BY (CourseID, ReviewerID)
PRIMARY KEY CourseID;


INSERT INTO clickhouse_assignment_3.course_ratings VALUES
    (1, 'C++', 123, 85, 'Good', 1, 1);  


INSERT INTO clickhouse_assignment_3.course_ratings VALUES
    (1, 'C++', 123, 85, 'Good', 1, -1),
    (1, 'C++', 123, 90, 'Excellent', 2, 1);


OPTIMIZE TABLE clickhouse_assignment_3.course_ratings;

SELECT * FROM clickhouse_assignment_3.course_ratings;
