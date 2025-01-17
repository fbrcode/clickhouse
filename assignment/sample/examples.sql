-- ClickHouse Sample SQL Queries

-- DDL

CREATE DATABASE SQL_EXAMPLES;

CREATE TABLE SQL_EXAMPLES.table1
(Column1 String)
ENGINE = Log;

INSERT INTO SQL_EXAMPLES.table1 VALUES ('a'),('b');

SELECT * FROM SQL_EXAMPLES.table1;

/*
Query id: 7375e812-a465-49b1-84a4-b603887ee846

   ┌─Column1─┐
1. │ a       │
2. │ b       │
   └─────────┘

2 rows in set. Elapsed: 0.033 sec. 
*/

RENAME TABLE SQL_EXAMPLES.table1 TO SQL_EXAMPLES. table2;

SHOW TABLES FROM SQL_EXAMPLES;

/*
Query id: e9d7c1cd-0563-43c9-a2bf-e6defb64e8b5

   ┌─name───┐
1. │ table2 │
   └────────┘

1 row in set. Elapsed: 0.053 sec. 
*/

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: c3f794e0-b63f-4f8c-b2ce-39ad8f4afe02

   ┌─Column1─┐
1. │ a       │
2. │ b       │
   └─────────┘

2 rows in set. Elapsed: 0.058 sec. 
*/

TRUNCATE TABLE SQL_EXAMPLES. table2;

DROP TABLE SQL_EXAMPLES. table2;

DROP TABLE SQL_EXAMPLES.table2

SHOW TABLES FROM SQL_EXAMPLES;

/*
Query id: 2c530589-04b8-4280-bd1e-c499d92652ce

Ok.

0 rows in set. Elapsed: 0.091 sec. 
*/

-- DQL

SELECT name, is_aggregate, case_insensitive, origin FROM system.functions LIMIT 10;

/*
Query id: 9ea5a963-37e1-4d14-8ea9-f7aa2c124ff4

    ┌─name───────────────────────────────┬─is_aggregate─┬─case_insensitive─┬─origin─┐
 1. │ h3GetIndexesFromUnidirectionalEdge │            0 │                0 │ System │
 2. │ intHash64                          │            0 │                0 │ System │
 3. │ intHash32                          │            0 │                0 │ System │
 4. │ polygonsDistanceCartesian          │            0 │                0 │ System │
 5. │ fuzzBits                           │            0 │                0 │ System │
 6. │ IPv4NumToStringClassC              │            0 │                0 │ System │
 7. │ IPv4NumToString                    │            0 │                0 │ System │
 8. │ isIPv6String                       │            0 │                0 │ System │
 9. │ IPv4CIDRToRange                    │            0 │                0 │ System │
10. │ IPv6CIDRToRange                    │            0 │                0 │ System │
    └────────────────────────────────────┴──────────────┴──────────────────┴────────┘

10 rows in set. Elapsed: 0.036 sec. Processed 1.60 thousand rows, 308.03 KB (44.32 thousand rows/s., 8.55 MB/s.)
Peak memory usage: 0.00 B.
*/

SELECT name, is_aggregate, case_insensitive, origin FROM system.functions WHERE name='sum';

/*
Query id: 784317d7-146a-462b-86b1-64067b168f9e

   ┌─name─┬─is_aggregate─┬─case_insensitive─┬─origin─┐
1. │ sum  │            1 │                1 │ System │
   └──────┴──────────────┴──────────────────┴────────┘

1 row in set. Elapsed: 0.030 sec. Processed 1.60 thousand rows, 308.03 KB (53.02 thousand rows/s., 10.23 MB/s.)
Peak memory usage: 0.00 B.
*/

SELECT COUNT(name), is_aggregate FROM system.functions WHERE origin='System' GROUP BY is_aggregate;

/*
Query id: ab792f01-c7b4-4695-b2ec-1711079598cb

   ┌─COUNT(name)─┬─is_aggregate─┐
1. │        1390 │            0 │
2. │         206 │            1 │
   └─────────────┴──────────────┘

2 rows in set. Elapsed: 0.073 sec. Processed 1.60 thousand rows, 308.03 KB (21.93 thousand rows/s., 4.23 MB/s.)
Peak memory usage: 34.27 KiB.
*/

SELECT COUNT (name), is_aggregate FROM system. functions WHERE origin='System' GROUP BY is_aggregate ORDER BY is_aggregate DESC;

/*
Query id: 54b06e04-cd42-431a-848f-1f71281730fd

   ┌─COUNT(name)─┬─is_aggregate─┐
1. │         206 │            1 │
2. │        1390 │            0 │
   └─────────────┴──────────────┘

2 rows in set. Elapsed: 0.082 sec. Processed 1.60 thousand rows, 308.03 KB (19.45 thousand rows/s., 3.75 MB/s.)
Peak memory usage: 32.93 KiB.
*/

-- DML

CREATE TABLE SQL_EXAMPLES.table2
(Column1 String, Column2 String)
ENGINE = MergeTree
ORDER BY Column1;

INSERT INTO SQL_EXAMPLES.table2 (Column1, Column2) VALUES ('a', 'a'), ('b', 'b');

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: 80e9cd1e-93ff-4e71-9f5c-0b8995241526

   ┌─Column1─┬─Column2─┐
1. │ a       │ a       │
2. │ b       │ b       │
   └─────────┴─────────┘

2 rows in set. Elapsed: 0.058 sec. 
*/

ALTER TABLE SQL_EXAMPLES.table2 UPDATE Column2 = 'apple' WHERE Column2 = 'a';

ALTER TABLE SQL_EXAMPLES.table2 DELETE WHERE Column2 = 'apple';

/* soft delete : marks hidden column "row_exists" as false */
DELETE FROM SQL_EXAMPLES.table2 WHERE Column2 = 'b';

TRUNCATE TABLE SQL_EXAMPLES.table2;

-- DDL Columns

INSERT INTO SQL_EXAMPLES.table2 (Column1, Column2) VALUES ('a', 'a'), ('b', 'b');

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: 89f5feba-a406-41ea-be53-30f88c48e957

   ┌─Column1─┬─Column2─┐
1. │ a       │ a       │
2. │ b       │ b       │
   └─────────┴─────────┘

2 rows in set. Elapsed: 0.038 sec. 
*/

ALTER TABLE SQL_EXAMPLES.table2 ADD COLUMN Column3 Nullable(String);

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: 09169499-3ca8-4067-afa8-a205cbc43333

   ┌─Column1─┬─Column2─┬─Column3─┐
1. │ a       │ a       │ ᴺᵁᴸᴸ    │
2. │ b       │ b       │ ᴺᵁᴸᴸ    │
   └─────────┴─────────┴─────────┘

2 rows in set. Elapsed: 0.033 sec
*/

INSERT INTO SQL_EXAMPLES.table2 VALUES ('c', 'c', 'cat');

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: 1f67595e-0d03-493c-87d8-96b717b51d6f

   ┌─Column1─┬─Column2─┬─Column3─┐
1. │ c       │ c       │ cat     │
   └─────────┴─────────┴─────────┘
   ┌─Column1─┬─Column2─┬─Column3─┐
2. │ a       │ a       │ ᴺᵁᴸᴸ    │
3. │ b       │ b       │ ᴺᵁᴸᴸ    │
   └─────────┴─────────┴─────────┘

3 rows in set. Elapsed: 0.020 sec. 
*/


ALTER TABLE SQL_EXAMPLES.table2 RENAME COLUMN Column3 TO Column4;

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: 8abf2b4e-63c5-47e2-8699-5f45d03f37e0

   ┌─Column1─┬─Column2─┬─Column4─┐
1. │ a       │ a       │ ᴺᵁᴸᴸ    │
2. │ b       │ b       │ ᴺᵁᴸᴸ    │
   └─────────┴─────────┴─────────┘
   ┌─Column1─┬─Column2─┬─Column4─┐
3. │ c       │ c       │ cat     │
   └─────────┴─────────┴─────────┘

3 rows in set. Elapsed: 0.027 sec. 
*/

ALTER TABLE SQL_EXAMPLES.table2 CLEAR COLUMN Column4;

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: db39b67b-a150-4ea1-a2ee-e0ac16b1d2bc

   ┌─Column1─┬─Column2─┬─Column4─┐
1. │ a       │ a       │ ᴺᵁᴸᴸ    │
2. │ b       │ b       │ ᴺᵁᴸᴸ    │
   └─────────┴─────────┴─────────┘
   ┌─Column1─┬─Column2─┬─Column4─┐
3. │ c       │ c       │ ᴺᵁᴸᴸ    │
   └─────────┴─────────┴─────────┘

3 rows in set. Elapsed: 0.033 sec. 
*/

ALTER TABLE SQL_EXAMPLES.table2 DROP COLUMN Column4;

SELECT * FROM SQL_EXAMPLES.table2;

/*
Query id: ff742024-47fe-472b-811f-73a2933a58ce

   ┌─Column1─┬─Column2─┐
1. │ c       │ c       │
   └─────────┴─────────┘
   ┌─Column1─┬─Column2─┐
2. │ a       │ a       │
3. │ b       │ b       │
   └─────────┴─────────┘

3 rows in set. Elapsed: 0.028 sec. 
*/

-- Views

/* DROP TABLE SQL_EXAMPLES.salary; */
CREATE TABLE SQL_EXAMPLES.salary
(
  salary UInt16,
  month String,
  name String
)
Engine=MergeTree()
ORDER BY name;

INSERT INTO SQL_EXAMPLES.salary (salary, month, name) VALUES (1200, 'Nov', 'a'), (1000, 'Jan', 'b'), (800, NULL, 'd');

SELECT * FROM SQL_EXAMPLES.salary;

/*
Query id: c77a1c29-dda8-4823-8a42-3531e699068f

   ┌─salary─┬─month─┬─name─┐
1. │   1200 │ Nov   │ a    │
2. │   1000 │ Jan   │ b    │
3. │    800 │       │ d    │
   └────────┴───────┴──────┘

3 rows in set. Elapsed: 0.023 sec.
*/

CREATE VIEW SQL_EXAMPLES.salary_view AS SELECT salary*2, name FROM SQL_EXAMPLES.salary;

SELECT * FROM SQL_EXAMPLES.salary_view;

/*
Query id: 222e882a-ec40-4ee2-9e7d-41984a564a78

   ┌─multiply(salary, 2)─┬─name─┐
1. │                2400 │ a    │
2. │                2000 │ b    │
3. │                1600 │ d    │
   └─────────────────────┴──────┘

3 rows in set. Elapsed: 0.031 sec. 
*/

CREATE VIEW parametrized_view AS SELECT * FROM SQL_EXAMPLES.table2 WHERE Column1={Column1:String};

SELECT * FROM parametrized_view(Column1='a');

/*
Query id: 68f46180-cba1-4780-922d-eac1d964c005

   ┌─Column1─┬─Column2─┐
1. │ a       │ a       │
   └─────────┴─────────┘

1 row in set. Elapsed: 0.074 sec. 
*/

CREATE MATERIALIZED VIEW SQL_EXAMPLES.salary_mv
ENGINE = MergeTree()
ORDER BY (name)
AS SELECT salary*2, name FROM
SQL_EXAMPLES.salary;

SELECT * FROM SQL_EXAMPLES.salary_mv;

/* 0 rows in set. Elapsed: 0.046 sec. */

INSERT INTO SQL_EXAMPLES.salary VALUES (777, 'Nov', 'z');
ALTER TABLE SQL_EXAMPLES.salary UPDATE salary=222 WHERE name='a';
ALTER TABLE SQL_EXAMPLES.salary DELETE WHERE name='z';

SELECT * FROM SQL_EXAMPLES.salary_mv;

/* Only new data is added to materialized views (not existing, updated or deleted data)

Query id: 9503c5da-fcb2-4937-8381-88becea9a657

   ┌─multiply(salary, 2)─┬─name─┐
1. │                1554 │ z    │
   └─────────────────────┴──────┘

1 row in set. Elapsed: 0.041 sec. 
*/

-- Joins

CREATE TABLE SQL_EXAMPLES.employee
(name String, city Nullable(String))
ENGINE = MergeTree()
ORDER BY name;

INSERT INTO SQL_EXAMPLES.employee VALUES ('a', 'city1'), ('b', Null), ('c', 'city3');

SELECT * FROM SQL_EXAMPLES.employee;

/*
Query id: 7b4a2ec0-87b6-433b-ab95-80228b8f87bd

   ┌─name─┬─city──┐
1. │ a    │ city1 │
2. │ b    │ ᴺᵁᴸᴸ  │
3. │ c    │ city3 │
   └──────┴───────┘

3 rows in set. Elapsed: 0.037 sec. 
*/


/* DROP TABLE SQL_EXAMPLES.salary; */
CREATE TABLE SQL_EXAMPLES.salary
(
  salary UInt16,
  month String,
  name String
)
Engine=MergeTree()
ORDER BY name;

INSERT INTO SQL_EXAMPLES.salary (salary, month, name) VALUES (1200, 'Nov', 'a'), (1000, 'Jan', 'b'), (800, NULL, 'd');

SELECT * FROM SQL_EXAMPLES.salary;

/*
Query id: 02a1e535-3a93-430d-ab39-ab46c71c2ab6

   ┌─salary─┬─month─┬─name─┐
1. │   1200 │ Nov   │ a    │
2. │   1000 │ Jan   │ b    │
3. │    800 │       │ d    │
   └────────┴───────┴──────┘

3 rows in set. Elapsed: 0.045 sec. 
*/

SELECT employee.name, employee.city, salary salary, salary.month, salary.name
FROM SQL_EXAMPLES. employee AS employee
INNER JOIN SQL_EXAMPLES. salary AS salary
ON employee.name = salary.name
ORDER BY 1;

/*
Query id: 1be0f4ac-e02b-4320-8c38-902eb964d58a

   ┌─name─┬─city──┬─salary─┬─month─┬─salary.name─┐
1. │ a    │ city1 │   1200 │ Nov   │ a           │
2. │ b    │ ᴺᵁᴸᴸ  │   1000 │ Jan   │ b           │
   └──────┴───────┴────────┴───────┴─────────────┘

*/

SELECT employee.name, employee.city, salary salary, salary.month, salary.name
FROM SQL_EXAMPLES. employee AS employee
LEFT JOIN SQL_EXAMPLES. salary AS salary
ON employee.name = salary.name
ORDER BY 1;

/*
Query id: 42ed70ca-a8b4-4f85-b70c-78196c83718d

   ┌─name─┬─city──┬─salary─┬─month─┬─salary.name─┐
1. │ a    │ city1 │   1200 │ Nov   │ a           │
2. │ b    │ ᴺᵁᴸᴸ  │   1000 │ Jan   │ b           │
3. │ c    │ city3 │      0 │       │             │
   └──────┴───────┴────────┴───────┴─────────────┘

3 rows in set. Elapsed: 0.075 sec. 
*/

SELECT employee.name, employee.city, salary salary, salary.month, salary.name
FROM SQL_EXAMPLES. employee AS employee
RIGHT JOIN SQL_EXAMPLES. salary AS salary
ON employee.name = salary.name
ORDER BY 1;

/*
Query id: 64c14ff1-60e3-4aaf-bde4-2cb3161fb2fb

   ┌─name─┬─city──┬─salary─┬─month─┬─salary.name─┐
1. │      │ ᴺᵁᴸᴸ  │    800 │       │ d           │
2. │ a    │ city1 │   1200 │ Nov   │ a           │
3. │ b    │ ᴺᵁᴸᴸ  │   1000 │ Jan   │ b           │
   └──────┴───────┴────────┴───────┴─────────────┘

3 rows in set. Elapsed: 0.152 sec. 
*/

SELECT employee.name, employee.city, salary salary, salary.month, salary.name
FROM SQL_EXAMPLES. employee AS employee
FULL JOIN SQL_EXAMPLES. salary AS salary
ON employee.name = salary.name
ORDER BY 1;

/*
Query id: eb08d7d0-2cda-4f47-8a5e-27a5b171c57c

   ┌─name─┬─city──┬─salary─┬─month─┬─salary.name─┐
1. │      │ ᴺᵁᴸᴸ  │    800 │       │ d           │
2. │ a    │ city1 │   1200 │ Nov   │ a           │
3. │ b    │ ᴺᵁᴸᴸ  │   1000 │ Jan   │ b           │
4. │ c    │ city3 │      0 │       │             │
   └──────┴───────┴────────┴───────┴─────────────┘

4 rows in set. Elapsed: 0.116 sec. 
*/

SELECT name FROM SQL_EXAMPLES.employee
UNION ALL
SELECT name FROM SQL_EXAMPLES.salary;

/*
Query id: e3be18f8-6fbf-4efb-b52b-1ae7d58644fc

   ┌─name─┐
1. │ a    │
2. │ b    │
3. │ d    │
   └──────┘
   ┌─name─┐
4. │ a    │
5. │ b    │
6. │ c    │
   └──────┘

6 rows in set. Elapsed: 0.051 sec. 
*/

SELECT name FROM SQL_EXAMPLES.employee
UNION DISTINCT
SELECT name FROM SQL_EXAMPLES.salary;

/* 
Query id: 791961d2-a4fb-41a8-a39a-2d1ca20a84a3

   ┌─name─┐
1. │ a    │
2. │ b    │
3. │ c    │
   └──────┘
   ┌─name─┐
4. │ d    │
   └──────┘

4 rows in set. Elapsed: 0.075 sec. 
*/

-- Operators

SELECT 1+2;
SELECT plus(1,2);

/*
   ┌─plus(1, 2)─┐
1. │          3 │
   └────────────┘
*/

SELECT 1==1;
SELECT equals(1,1);

/*
   ┌─equals(1, 1)─┐
1. │            1 │
   └──────────────┘
*/

SELECT 1 AND 0;
SELECT and(1,0);

/*
   ┌─and(1, 0)─┐
1. │         0 │
   └───────────┘
*/

SELECT 1 IS NULL;

/*
   ┌─isNull(1)─┐
1. │         0 │
   └───────────┘
*/

SELECT 2 IS NOT NULL;

/*
   ┌─isNotNull(2)─┐
1. │            1 │
   └──────────────┘

*/

-- Numbers

SELECT toInt16(3214.2);

/*
   ┌─toInt16(3214.2)─┐
1. │            3214 │
   └─────────────────┘
*/

SELECT toFloat32(22);

/*
   ┌─toFloat32(22)─┐
1. │            22 │
   └───────────────┘
*/

SELECT toDecimal32(3.141212, 5);

/*
   ┌─toDecimal32(3.141212, 5)─┐
1. │                  3.14121 │
   └──────────────────────────┘
*/

SELECT toDecimal32(3.14,2) + toDecimal32(2.1412,4);

/*
   ┌─plus(toDecimal32(3.14, 2), toDecimal32(2.1412, 4))─┐
1. │                                             5.2812 │
   └────────────────────────────────────────────────────┘
*/

SELECT toDecimal32(3.14, 2) / toDecimal32(2.1412, 2);

/*
   ┌─divide(toDecimal32(3.14, 2), toDecimal32(2.1412, 2))─┐
1. │                                                 1.46 │
   └──────────────────────────────────────────────────────┘
*/

SELECT -1/0, 1/0;

/*
   ┌─divide(-1, 0)─┬─divide(1, 0)─┐
1. │          -inf │          inf │
   └───────────────┴──────────────┘
*/

SELECT 0 / 0;

/*
   ┌─divide(0, 0)─┐
1. │          nan │
   └──────────────┘
*/

-- Strings

CREATE TABLE string_example
(
  col1 String,
  col2 FixedString(6)
)
Engine=Log;

INSERT INTO string_example VALUES ('a', 'apple');

SELECT * FROM string_example;

/*
Query id: f861b5b9-37fa-4238-af2d-b88ff9d688e2

   ┌─col1─┬─col2──┐
1. │ a    │ apple │
   └──────┴───────┘

1 row in set. Elapsed: 0.051 sec. 
*/

INSERT INTO string_example VALUES ('fruit', 'pineapple');

/*
Query id: 845626da-a45a-4d43-a9f5-ab1d7c3136de

Ok.
Error on processing query: 
Code: 131. 
DB::Exception: 
String too long for type FixedString(6): 
while executing 'FUNCTION if(isNull(-dummy-0) : 3, defaultValueOfTypeName('FixedString(6)') :: 2, _CAST(-dummy-0, 'FixedString(6)') :: 4) -> if(isNull(-dummy-0), defaultValueOfTypeName('FixedString(6)'), _CAST(-dummy-0, 'FixedString(6)')) FixedString(6) : 1': 
While executing ValuesBlockInputFormat: 
data for INSERT was parsed from query. 
(TOO_LARGE_STRING_SIZE) (version 24.12.2.29 (official build))
*/

-- Date / Time

CREATE TABLE date_datetime_example
(
col1 Date,
col2 Date32,
col3 DateTime( 'Australia/Sydney'),
col4 DateTime64(6, 'Australia/Sydney')
)
Engine=Log;

INSERT INTO date_datetime_example VALUES ('1970-01-01', '2299-12-31', '2105-01-01 12:05:05', '2299-01-01 12:05:05.123456');

SELECT * FROM date_datetime_example;

/*
Query id: 2c5fb9ea-276c-4897-990f-46e2d853cd1d

   ┌───────col1─┬───────col2─┬────────────────col3─┬───────────────────────col4─┐
1. │ 1970-01-01 │ 2299-12-31 │ 2105-01-01 12:05:05 │ 2299-01-01 12:05:05.123456 │
   └────────────┴────────────┴─────────────────────┴────────────────────────────┘

1 row in set. Elapsed: 0.065 sec. 
*/

-- Array & Tuple

SELECT array(1,2,3), [1,2,3];

/*
Query id: 78d629ec-59e6-4a1a-9b58-69b2c1980076

   ┌─[1, 2, 3]─┬─[1, 2, 3]─┐
1. │ [1,2,3]   │ [1,2,3]   │
   └───────────┴───────────┘

1 row in set. Elapsed: 0.056 sec. 
*/

SELECT [1,2,3, Null];

/*
Query id: c056722c-e55c-4d6f-bd24-2a20e176098f

   ┌─[1, 2, 3, NULL]─┐
1. │ [1,2,3,NULL]    │
   └─────────────────┘

1 row in set. Elapsed: 0.027 sec. 
*/

SELECT [1,2,3, 'a'];

/*
Query id: c151bc38-b5be-4f57-acfe-f937df32b395

Elapsed: 0.049 sec. 

Received exception from server (version 24.12.2):
Code: 386. DB::Exception: Received from 127.0.0.1:9000. DB::Exception: There is no supertype for types UInt8, UInt8, UInt8, String because some of them are String/FixedString/Enum and some of them are not. (NO_COMMON_TYPE)
*/

SELECT [[1,21],[3,4]];

/*
Query id: fd1d206d-bc2e-4c6b-aaa3-df15e694cb6b

   ┌─[[1, 21], [3, 4]]─┐
1. │ [[1,21],[3,4]]    │
   └───────────────────┘

1 row in set. Elapsed: 0.021 sec. 
*/

SELECT tuple(1,2, 'a', toDate('1999-01-15'));

/*
Query id: 70ad1a05-6068-4c02-ba39-f1a287e61622

   ┌─(1, 2, 'a', toDate('1999-01-15'))─┐
1. │ (1,2,'a','1999-01-15')            │
   └───────────────────────────────────┘

1 row in set. Elapsed: 0.042 sec. 
*/

-- Nested

CREATE TABLE nested_example
(
  ID Int16,
  Details Nested
  (
    Name String,
    Age UInt8,
    Height UInt8
  )
)
Engine = Log;

INSERT INTO nested_example VALUES (1, ['A', 'B'], [31, 25], [174, 168]);

SELECT ID, Details.Name, Details.Age, Details.Height FROM nested_example;

/*
Query id: bed7acc3-bab4-4130-a1da-0f34f427687e

   ┌─ID─┬─Details.Name─┬─Details.Age─┬─Details.Height─┐
1. │  1 │ ['А','В']    │ [31,25]     │ [174,168]      │
   └────┴──────────────┴─────────────┴────────────────┘

1 row in set. Elapsed: 0.071 sec. 
*/

-- Enumerated & LowCardinality

CREATE TABLE enum_example
(column1 Enum('a'=1, 'b'=2))
Engine = Log;

INSERT INTO enum_example VALUES (1), (2), ('a'), ('b');

SELECT * FROM enum_example;

/*
Query id: b296d63c-ea6e-4907-9a26-d72d5e1b8a95

   ┌─column1─┐
1. │ a       │
2. │ b       │
3. │ a       │
4. │ b       │
   └─────────┘

4 rows in set. Elapsed: 0.057 sec. 
*/

INSERT INTO enum_example VALUES (3);

SELECT * FROM enum_example;

/*

Query id: 713dadc6-785c-4390-b0cd-37277f84aaf2

   ┌─column1─┐
1. │ a       │
2. │ b       │
3. │ a       │
4. │ b       │
   └─────────┘

Error on processing query: 
Code: 691. 
DB::Exception: 
Code: 691. 
DB::Exception: 
Unexpected value 3 in enum. (UNKNOWN_ELEMENT_OF_ENUM) 
(version 24.12.2.29 (official build)). 
(UNKNOWN_ELEMENT_OF_ENUM) (version 24.12.2.29 (official build))
*/

CREATE TABLE low_cardinality
(column1 LowCardinality(String))
Engine = Log;

INSERT INTO low_cardinality VALUES ('a');

SELECT * FROM low_cardinality;

/*
Query id: 3e5b706c-5994-432f-8065-32ff7e8a3dfc

   ┌─column1─┐
1. │ a       │
   └─────────┘

1 row in set. Elapsed: 0.042 sec. 
*/

-- Geo Data Types
CREATE TABLE geo_example
(
  p Point,
  r Ring,
  poly Polygon,
  multi_poly MultiPolygon
)
Engine = Log;

INSERT INTO geo_example VALUES
((7,7),
[(0, 0), (7, 0), (7, 7), (0, 7)],
[[(0, 0), (7, 0), (7, 7), (0, 7)], [(0, 0), (4, 0), (4, 4), (0, 4)]],
[[[(0, 0), (7, 0), (7, 7), (0, 7)]], [[(0, 0), (4, 0), (4, 4),(0, 4)], [(0, 0), (2, 0), (2, 2), (0, 2)]]]);

SELECT * FROM geo_example;

/*
Query id: 9c799297-cc62-44f7-ba1f-f91af587ff15

   ┌─p─────┬─r─────────────────────────┬─poly──────────────────────────────────────────────────┬─multi_poly──────────────────────────────────────────────────────────────────────────┐
1. │ (7,7) │ [(0,0),(7,0),(7,7),(0,7)] │ [[(0,0),(7,0),(7,7),(0,7)],[(0,0),(4,0),(4,4),(0,4)]] │ [[[(0,0),(7,0),(7,7),(0,7)]],[[(0,0),(4,0),(4,4),(0,4)],[(0,0),(2,0),(2,2),(0,2)]]] │
   └───────┴───────────────────────────┴───────────────────────────────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────┘

1 row in set. Elapsed: 0.055 sec. 
*/

-- Map

CREATE TABLE map_example
(col1 Map (UInt16, String))
Engine = Log;

INSERT INTO map_example VALUES ({1:'Hello'});

SELECT col1[1] FROM map_example;

/*
Query id: 7696ac39-09ad-458f-8f60-deca8c6047a6

   ┌─arrayElement(col1, 1)─┐
1. │ Hello                 │
   └───────────────────────┘

1 row in set. Elapsed: 0.045 sec. 
*/

-- Exercise - Wearable Smart Device Metrics

/* Data 

- Device ID
- Device Model
- Owner
- Gender
- Timestamp
- Heart Rate
- Blood Pressure
- SPO2
- Distance
- Steps
- Calories Burnt
- Latitude
- Longitude
- Altitude
- Unit

*/

CREATE TABLE wearable_device_metrics
(
DeviceID String,
DeviceModel String,
Owner String,
Gender LowCardinality(String),
Timestamp DateTime,
HeartRate UInt16,
BloodPressureSystolic UInt16,
BloodPressureDiastolic UInt16,
SPO2 Float32,
Distance Float32,
Steps UInt32,
CaloriesBurnt UInt16,
Position Point,
Altitude UInt16,
Unit Enum('SI'=1, 'US'=2, 'UK'=3)
)
Engine=Log;

INSERT INTO wearable_device_metrics SELECT * FROM generateRandom() LIMIT 100;

SELECT * FROM wearable_device_metrics LIMIT 10;

/*
Query id: ab737b64-efa2-4be8-a158-0c4bbd5ae78c

    ┌─DeviceID───┬─DeviceModel─┬─Owner──────┬─Gender─────┬───────────Timestamp─┬─HeartRate─┬─BloodPressureSystolic─┬─BloodPressureDiastolic─┬─────────────────SPO2─┬──────Distance─┬──────Steps─┬─CaloriesBurnt─┬─Position───────────────────────────────────────────┬─Altitude─┬─Unit─┐
 1. │ /$wZwI+O\  │ ;>&9/Y      │ :o4@\U:Ag  │ Xg}U%      │ 2061-07-09 20:40:18 │     10163 │                 62179 │                  44315 │          4.903769e35 │ -2.2704227e24 │  214395124 │         28603 │ (-1.9647135090659726e300,-3.108972485004814e291)   │     4025 │ SI   │
 2. │ $Moa=7     │ g^$33vdAe   │ #          │            │ 1993-03-19 03:57:56 │     16041 │                 58014 │                  19072 │         -7.583369e23 │ -2.221225e-30 │  563408717 │         28127 │ (6.053369238820274e176,2.969547007753097e306)      │    36708 │ SI   │
 3. │ f=k_G6o    │ pTq*# P0\+  │ v4VLye     │ MS         │ 2088-08-09 04:45:09 │     38983 │                 14211 │                  48765 │ 11728573000000000000 │  5.879306e-22 │ 2889477508 │         11111 │ (-2.554702853451408e-291,2.429087917389802e217)    │    49736 │ US   │
 4. │ UKQ        │ Oaw         │ Y"r_N/wh   │ wi         │ 2045-02-20 11:09:08 │     14034 │                   831 │                  50023 │          -0.05406746 │ -544083080000 │ 3325328026 │         16290 │ (-3.4585316238262613e117,-2.418809556049588e77)    │    11612 │ UK   │
 5. │            │ 3+?Fk*t     │ RgJ(2      │ GJ         │ 1984-07-22 05:47:10 │     40804 │                  3885 │                  51081 │           -209.60567 │ -0.0017730586 │ 3179993885 │         33485 │ (3.6762653398758856e230,1.5819862732318817e-225)   │    19118 │ SI   │
 6. │ \          │             │ ;PS42|h    │ sR^Oq      │ 1979-12-07 10:50:48 │     50209 │                 60020 │                    616 │        -4.632164e-12 │    1.17476e27 │ 4254644015 │          3512 │ (-1.5312869899118884e118,-1.9729285145653205e-290) │    18846 │ US   │
 7. │ +jUd       │ M?!         │ Am~        │ m_`c       │ 2085-04-04 12:00:35 │     64836 │                  1186 │                  43282 │            -99.82286 │ -1.156176e-38 │  694879785 │         27404 │ (1.5161013961136805e-127,1.1565305753341713e226)   │    53822 │ SI   │
 8. │            │ h'0{:H/x4   │ 7R]R0 "8JG │            │ 2080-01-13 20:09:53 │     30748 │                 31728 │                  36686 │           -24166.799 │   3.151706e26 │ 1405986730 │         15706 │ (1.7359768298684362e-85,-3.531937984443595e-213)   │    61291 │ UK   │
 9. │ xm|RRGf07k │ A7q         │ wC4WU      │ `F^\QZZ[b  │ 1990-12-25 06:16:53 │      3183 │                 48775 │                  36341 │        3.8879364e-27 │     14814.323 │   83074828 │         51964 │ (-3.455269797549185e-177,3.836205797950279e-116)   │    43619 │ US   │
10. │ `"-woc8    │             │ OfM1>`$    │ <5z'.|r2z( │ 2027-03-08 06:08:18 │      3902 │                 19304 │                  14561 │        -1.4353625e24 │ -2.8061308e27 │   86095891 │         48300 │ (-8.529011014625584e101,1.7565831801786748e-134)   │    51216 │ SI   │
    └────────────┴─────────────┴────────────┴────────────┴─────────────────────┴───────────┴───────────────────────┴────────────────────────┴──────────────────────┴───────────────┴────────────┴───────────────┴────────────────────────────────────────────────────┴──────────┴──────┘

10 rows in set. Elapsed: 0.077 sec. 
*/

