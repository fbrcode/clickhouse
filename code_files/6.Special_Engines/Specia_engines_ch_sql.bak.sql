
-- Log
CREATE DATABASE special_engines;


-- File

CREATE TABLE special_engines.file_engine
(
ID UInt64,
Name String
)
Engine = File(CSV);

INSERT INTO special_engines.file_engine VALUES
(1, 'a'),
(2, 'b');

-- Merge


CREATE TABLE special_engines.merge_old
(
ID Int32,
Name String
)
ENGINE = Log;

INSERT INTO special_engines.merge_old VALUES
(1, 'a'),
(2, 'b');

CREATE TABLE special_engines.merge_new
(
ID Int32,
Name String
)
ENGINE = Log;

INSERT INTO special_engines.merge_new VALUES
(3, 'c'),
(4, 'd');

CREATE TABLE special_engines.merge_final
ENGINE = Merge('special_engines', '^merge');

SELECT * FROM special_engines.merge_final;

-- Set
CREATE TABLE special_engines.set_engine
(
ID Int32
)
ENGINE = Set;

INSERT INTO special_engines.set_engine VALUES
(1), (3);

SELECT * FROM special_engines.merge_final
WHERE ID IN special_engines.set_engine;

-- Memory

CREATE TABLE special_engines.memory_example
(
ID Int32,
Name String
)
Engine = Memory;

INSERT INTO special_engines.memory_example VALUES (1, 'a');

SELECT  * FROM special_engines.memory_example;

-- Buffer

CREATE TABLE special_engines.buffer_storage
(
ID Int32,
Name String
)
Engine = MergeTree
ORDER BY ID;

CREATE TABLE special_engines.buffer_example
AS special_engines.buffer_storage
ENGINE = Buffer(special_engines, buffer_storage, 2, 10, 20, 1, 10, 1024, 8192 );

INSERT INTO special_engines.buffer_example VALUES (1, 'a');

SELECT * FROM special_engines.buffer_storage;

SELECT * FROM special_engines.buffer_example;

-- GenerateRandom

CREATE TABLE special_engines.random
(ID Int8,
Name String)
ENGINE=Log;

INSERT INTO special_engines.random SELECT * FROM generateRandom() LIMIT 100;

SELECT * FROM special_engines.random;

SELECT * FROM generateRandom('ID Int8,Name String') LIMIT 100;

CREATE TABLE special_engines.generate_random
(ID Int8,
Name String)
ENGINE = GenerateRandom();

SELECT * FROM special_engines.generate_random LIMIT 100;

-- URL

CREATE TABLE special_engines.url
(Year String,
Industry_aggregation_NZSIOC String,
Industry_code_NZSIOC String,
Industry_name_NZSIOC String,
Units String,
Variable_code String,
Variable_name String,
Variable_category String,
Value String,
Industry_code_ANZSIC06 String)
ENGINE = URL('https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2021-financial-year-provisional/Download-data/annual-enterprise-survey-2021-financial-year-provisional-csv.csv', CSV);

SELECT * FROM special_engines.url;



