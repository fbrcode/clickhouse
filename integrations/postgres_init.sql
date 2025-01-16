CREATE DATABASE IF NOT EXISTS clickhouse;

-- switch to the clickhouse database
\c clickhouse

CREATE TABLE IF NOT EXISTS test (column1 INT, column2 FLOAT);
TRUNCATE TABLE test;
INSERT INTO test VALUES (1, 2),(3, 4);


