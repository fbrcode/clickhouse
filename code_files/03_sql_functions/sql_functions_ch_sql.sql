SELECT toUInt8('32');

SELECT toFloat32('1.12');

SELECT toFloat32OrNull('1.12a');

SELECT toFloat32OrNull('1.12a');

SELECT toDecimal64('3.1412', 8);

SELECT toDate('2020-01-14');
SELECT toDate32(125);
SELECT toDate32(125.2);

SELECT toDateTimeOrNull('2020-01-14aaa');
SELECT toDateTime64OrNull('2020-01-14');

SELECT toDateOrZero('2020-01-14aaa');

-- datetime

- generate

SELECT now() , today(), yesterday();

- format

SELECT toDateTime('1999-11-01 11:30:45') as t,
formatDateTime(t, '%d=%m=%y');

- Convert to different time unit

SELECT toDateTime('1999-11-01 11:30:45') as t,
toYear(t),
toMonth(t),
toQuarter(t),
toWeek(t);

SELECT toDateTime('1999-11-01 11:30:45') as t,
toHour(t),
toMinute(t),
toSecond(t);

SELECT toDateTime('1999-11-01') as d,
toDayOfWeek(d),
toDayOfMonth(d),
toDayOfYear(d);

- Rounding off

SELECT toDateTime('1999-11-01 11:30:45') as t,
toStartOfYear(t),
toStartOfQuarter(t),
toStartOfMonth(t);


SELECT toDateTime('1999-11-01 11:30:45') as t,
toMonday(t),
toStartOfWeek(t);

SELECT toDateTime('1999-11-01 11:30:45') as t,
toStartOfDay(t),
toStartOfHour(t),
toStartOfMinute(t);

SELECT toDateTime('1999-11-01 11:42:45') as t,
toStartOfFiveMinute(t),
toStartOfTenMinutes(t),
toStartOfFifteenMinutes(t);

-- Date/Datetime arithmetic

SELECT toDateTime('1999-11-01 10:30:45') as t1, toDateTime('1999-11-01 11:42:45') as t2,
dateDiff('hour', t1, t2);

SELECT toDateTime('1999-11-01 10:30:45') as t,
subtractYears(t,7),
subtractMonths(t,7),
subtractWeeks(t,7),
subtractDays(t,7),
subtractHours(t,7),
subtractMinutes(t,7),
subtractSeconds(t,7);

SELECT toDateTime('1999-11-01 10:30:45') as t,
addYears(t,7),
addMonths(t,7),
addWeeks(t,7),
addDays(t,7),
addHours(t,7),
addMinutes(t,7),
addSeconds(t,7);


-- string


SELECT  toString(32.0);

- Case Conversion


SELECT lower('Hello');
SELECT upper('Hello');

- String Manipulation

SELECT repeat('a',3);

SELECT reverse('abc');

SELECT concat('a', 'b')

SELECT substring('welcome', 1, 3);
SELECT substr('welcome', 1, 3);

SELECT trimLeft(' abc '), trimRight(' abc '), trimBoth(' abc ');
SELECT trim(BOTH 'a' FROM 'aGood Morning !a');

- Search

SELECT  startsWith('apple', 'a'), endsWith('apple', 'l');

SELECT 'Good morning' as t,
position(t, 'oo');

SELECT 'Good morning' as t,
multiSearchAllPositions(t, ['o', 'n']);

SELECT 'Good morning' as t,
positionCaseInsensitive(t, 'oo');

SELECT 'Good morning' as t,
multiSearchAllPositionsCaseInsensitive(t, ['o', 'n']);

SELECT 'Good morning' as t,
multiSearchFirstIndex(t, ['mo', 'oo']);

- Match

SELECT 'Good morning sunshine' as t,
match(t, '.ne');

SELECT 'Good morning sunshine' as t,
match(t, '\d');

SELECT 'Good morning sunshine' as t,
multiMatchAny(t, ['\d', '.oo']);

SELECT 'Good morning sunshine' as t,
multiMatchAllIndices(t, ['\d', '.oo']);

SELECT 'Good morning sunshine' as t,
like(t, '%oo%'), notLike(t, '%oo%');

- Extract and replace

SELECT 'Good morning sun shine' as t,
extract(t, 'G..d');

SELECT 'Good morning sun shine' as t,
extractAll(t, 's..');

SELECT 'Good morning sun shine' as t,
replace(t, 'Good', 'GOOD');

SELECT 'Good morning sun shine' as t,
replaceAll(t, 'o', 'a');

SELECT 'Good morning sun shine' as t,
replaceRegexpOne(t, 'o.', 'OO');

SELECT 'Good morning sun shine' as t,
replaceRegexpAll(t, 'i.', 'aa');

-- Array

- Create

SELECT array(1,2,3,4,5);


SELECT arrayConcat([1,2], [3,4]);


- Retrieve

SELECT array(1,2,3,4,5) AS temp_array,
arrayElement(temp_array, 3);

- Finding and Counting elements

SELECT array(1,2,3,4,5) AS temp_array,
has(temp_array, 5),
hasAll(temp_array, [4,5,6]),
hasAny(temp_array, [5,6,7]);

SELECT array(1,2,3,4,5) AS temp_array,
indexOf(temp_array, 4),
countEqual(temp_array,2);


- Push


SELECT array(1,2,3,4,5) AS temp_array,
arrayPushFront(temp_array, 6),
arrayPushBack(temp_array, 6);

- Pop

SELECT array(1,2,3,4,5) AS temp_array,
arrayPopFront(temp_array),
arrayPopBack(temp_array);

-Slice and resize

SELECT array(1,2,3,4,5) AS temp_array,
arraySlice(temp_array,3,2),
arrayResize(temp_array,10, 2);

- Sort

SELECT array(6,8,1,2,3,4,5,7) AS temp_array,
arraySort(temp_array),
arrayReverseSort(temp_array);

- Distinct elements

SELECT array(1,1,2,2,3,3,4,4) AS temp_array,
arrayUniq(temp_array),
arrayDistinct(temp_array);

-- Json

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
isValidJSON(json_data);

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
JSONLength(json_data);

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
JSONHas(json_data, 'Key1');

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
JSONExtractKeys(json_data);

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
JSONExtractKeysAndValuesRaw(json_data);


SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
visitParamExtractInt(json_data, 'Key1');

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
visitParamExtractFloat(json_data, 'Key1');

SELECT  '{"Key1":"10", "Key2":"20"}' as json_data,
visitParamExtractString(json_data, 'Key1');


-- Aggregate Functions

SHOW DATABASES;

SHOW TABLES FROM datasets;

SELECT COUNT() FROM datasets.hits_v1;

SELECT COUNT(DISTINCT UserID) FROM datasets.hits_v1;

SELECT min(UserID) FROM datasets.hits_v1;

SELECT max(UserID) FROM datasets.hits_v1;

SELECT * FROM datasets.hits_v1;

SELECT argMin(EventTime, UserID) FROM datasets.hits_v1;

SELECT  avg(GoodEvent) FROM datasets.hits_v1;

SELECT varSamp(RequestTry) FROM datasets.hits_v1;

SELECT stddevPop(RequestTry) FROM datasets.hits_v1;

SELECT covarPop(RequestTry, HistoryLength) FROM datasets.hits_v1;

-- Combinators

SELECT  avgIf(HistoryLength, HistoryLength>0) FROM datasets.hits_v1;

SELECT array(1,2,3,4) AS arr,
avgArray(arr);

SELECT  avgForEach(a)
FROM (
SELECT [1,2,3] as a
UNION ALL
SELECT[4,5,6] as a);

SELECT * FROM numbers(1);

SELECT avgOrDefault(HistoryLength), avg(SomeUnknown) FROM datasets.hits_v1;

-- UDF

CREATE FUNCTION volume_cuboid AS (length, breadth, height) -> length*breadth*height;

SELECT volume_cuboid(100, 10, 2);

DROP FUNCTION volume_cuboid;

-- window functions
CREATE TABLE window_funct_example
(
ID UInt32,
Name String,
Department String,
Age UInt16
)
Engine = Log;

INSERT INTO window_funct_example VALUES
(1, 'a', 'd1', 22),
(2, 'b', 'd1', 42),
(3, 'c', 'd1', 32),
(4, 'd', 'd2', 34),
(5, 'e', 'd2', 28),
(6, 'f', 'd2', 48);

SELECT
  [column_list],
  [windows_function_name]([argument_list])
    OVER ([PARTITION BY [partition_column_list]]
         [ORDER BY [order_column_list]])
  AS [alias_name]
FROM [table_name];

SELECT ID, Name, Department , Age, AVG(Age)
OVER  (PARTITION BY Department ) AS avg_department_age
FROM window_funct_example;

SELECT ID, Name, Department , Age, SUM(Age)
OVER  (PARTITION BY Department ORDER BY ID) AS cumulative_department_age
FROM window_funct_example;

SELECT ID, Name, Department , Age,
ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Age) AS dep_rank
FROM window_funct_example;






