# ClickHouse

## Table of Contents

- [ClickHouse](#clickhouse)
  - [Table of Contents](#table-of-contents)
  - [About ClickHouse](#about-clickhouse)
  - [Install \& Run](#install--run)
  - [Web Interface](#web-interface)
  - [MacOS ClickHouse Client](#macos-clickhouse-client)
  - [Kubernetes ClickHouse Operator](#kubernetes-clickhouse-operator)
  - [SQL Structures](#sql-structures)
    - [DDL](#ddl)
    - [DQL](#dql)
    - [DML](#dml)
    - [Views](#views)
  - [SQL Execution](#sql-execution)
    - [Joins](#joins)
    - [Operators](#operators)
    - [Integer](#integer)
    - [Float](#float)
    - [Decimal](#decimal)
    - [String](#string)
    - [Fixed String](#fixed-string)
    - [Date](#date)
    - [Date32](#date32)
    - [DateTime](#datetime)
    - [DateTime64](#datetime64)
    - [Array](#array)
    - [Tuple](#tuple)
    - [Nested](#nested)
    - [Enumerated \& LowCardinality](#enumerated--lowcardinality)
    - [Geo Data Types](#geo-data-types)
    - [Maр](#maр)
  - [Storage Engines](#storage-engines)
    - [MergeTree](#mergetree)
      - [MergeTree CREATE TABLE statement - Syntax](#mergetree-create-table-statement---syntax)
      - [MergeTree - Settings](#mergetree---settings)
    - [Operations on Partitions](#operations-on-partitions)
    - [MergeTree Family of Table Engines](#mergetree-family-of-table-engines)
      - [ReplacingMergeTree](#replacingmergetree)
      - [SummingMergeTree](#summingmergetree)
      - [AggregatingMergeTree](#aggregatingmergetree)
      - [CollapsingMergeTree](#collapsingmergetree)
      - [VersionedCollapsingMergeTree](#versionedcollapsingmergetree)
      - [Data Skipping Index](#data-skipping-index)
      - [Choosing the right MergeTree Engine](#choosing-the-right-mergetree-engine)
    - [Special and Log Table Engines](#special-and-log-table-engines)
      - [File Table Engine](#file-table-engine)
      - [Merge Table Engine](#merge-table-engine)
      - [Set Table Engine](#set-table-engine)
      - [Memory Table Engine](#memory-table-engine)
      - [Buffer Table Engine](#buffer-table-engine)
      - [GenerateRandom Table Engine](#generaterandom-table-engine)
      - [URL Table Engine](#url-table-engine)
      - [Dictionaries](#dictionaries)
      - [Log Engines](#log-engines)
        - [TinyLog Engine](#tinylog-engine)
        - [Log Engine](#log-engine)
        - [StripeLog Engine](#stripelog-engine)
  - [Clustering, Replication and Sharding](#clustering-replication-and-sharding)
    - [Replication](#replication)
    - [Sharding](#sharding)
    - [Replication and Sharding](#replication-and-sharding)
  - [External Data sources](#external-data-sources)
    - [MySQL](#mysql)
    - [PostgreSQL](#postgresql)
    - [MongoDB](#mongodb)
    - [Apache Kafka](#apache-kafka)

## About ClickHouse

ClickHouse is a fast, open-source column-oriented database management system (DBMS) designed for online analytical processing (OLAP) of large datasets. It allows users to generate analytical reports using SQL queries in real-time, with the ability to process and analyze petabytes of data.

Key features of ClickHouse include:

1. **High performance**: ClickHouse can return processed results in real-time, often in fractions of a second.

2. **Column-oriented storage**: Data is stored in columns, enabling efficient compression and faster queries on large datasets.

3. **Scalability**: ClickHouse supports distributed query processing across multiple servers and can handle petabytes of data.

4. **SQL support**: It uses an SQL-like query language, making it accessible to those familiar with SQL.

5. **Data compression**: ClickHouse employs various compression techniques to optimize storage and processing.

6. **Vector computation engine**: Operations are performed on arrays of items rather than individual values, enhancing performance.

ClickHouse was initially developed at Yandex, Russia's largest technology company, starting in 2009. It was first launched in production in 2012 to power Yandex Metrica, and was later released as open-source software in June 2016. Since then, it has gained popularity and has been adopted by major companies such as Uber, Comcast, eBay, and Cisco.

In 2021, ClickHouse incorporated as a company, receiving significant funding and establishing its headquarters in the San Francisco Bay Area. The company continues to develop the open-source project while also working on cloud technology.

**Optimal usage**:

- More writes than reads
- Data is rarely modified (updated/deleted)
- Tables have a large number of columns
- Data is filtered or aggregated while querying
- No Transactions

**Not supported**:

- Stored Procedures
- Full fledged triggers
- Joins are slow
- Eventually consistent
- Can handle up to few hundreds of queries per second

## Install & Run

Let's use docker compose to install and run ClickHouse.

```sh
docker compose up -d
```

To connect to the ClickHouse server, you can use the following command:

```sh
docker compose exec clickhouse clickhouse-client
```

Run `show databases;` to see the list of databases and `\q` to exit the ClickHouse client.

To enter the ClickHouse server container, you can use the following command:

```sh
docker compose exec clickhouse bash
```

## Web Interface

ClickHouse comes with a web interface called `Tabix`.

You can access it by visiting `http://localhost:8123/play` in your web browser.

## MacOS ClickHouse Client

To install the ClickHouse client on MacOS, you can use Homebrew:

```sh
brew install --cask clickhouse
```

Then, you can connect to the ClickHouse server using the following command:

```sh
clickhouse client --host 127.0.0.1 --port 9000 --user default
# or run query directly
clickhouse client --host 127.0.0.1 --port 9000 --user default --query "show tables from information_schema"
```

## Kubernetes ClickHouse Operator

ClickHouse Operator is a Kubernetes operator that simplifies the deployment and management of ClickHouse clusters on Kubernetes.

Github Source: [Altinity / clickhouse-operator](https://github.com/Altinity/clickhouse-operator)

Install bundle with:

```sh
# wget https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-bundle.yaml
kubectl apply -f ./conf/clickhouse-operator-install-bundle.yaml
```

Create a namespace for ClickHouse:

```sh
kubectl create namespace clickhouse
```

Create a ClickHouse cluster:

```sh
kubectl apply -f ./conf/CH-Cluster1.yaml -n clickhouse
```

Check the status of the ClickHouse cluster:

```sh
kubectl get all -n clickhouse
```

Check the status of the ClickHouse installation:

```sh
kubectl get ClickHouseInstallation -n clickhouse
```

Connect to the ClickHouse server:

```sh
kubectl exec -n clickhouse -it chi-ch1-ch1-0-0-0 -- clickhouse-client
```

To access the ClickHouse server from your local machine, you can use port forwarding:

```sh
kubectl -n clickhouse port-forward chi-ch1-ch1-0-0-0 11000:8123 &
```

You can now access the ClickHouse web interface by visiting `http://localhost:11000/play` in your web browser.

## SQL Structures

### DDL

- **CREATE**: Create a database, table, users and views
- **RENAME**: Rename a table, database or dictionary
- **TRUNCATE**: Removes all the records from a table
- **DROP**: Drop a database, table, user, view, dictionary et

**DDL For Columns**:

- **ADD** - Add a new column
- **DROP** - Drop a column
- **RENAME** - Rename a column
- **CLEAR** - Clear the column data

### DQL

- SELECT statement: SELECT column_name(s) FROM table_name;
- Reads the data from tables
- Supports clauses such as LIMIT, DISTINCT, WHERE, GROUP BY, ORDER BY etc.

### DML

- Insert
- Mutations via ALTER statement
- Update (ALTER TABLE... Update)
- Delete (ALTER TABLE... Delete)
- Soft Delete (Delete...)

### Views

- Normal View
- Parametrized View
- Materialized View

## SQL Execution

### Joins

- Inner Join
- Left Join
- Right Join
- Full Join
- Cross Join
- Union (ALL or DISTINCT)

### Operators

- Mathematical operators
  - plus(a,b)
  - minus(a,b)
  - multiply(a,b)
  - divide(a,b)
  - modulo(a,b)
- Comparison Operators
  - equals(a, b)
  - notEquals(a, b)
  - greater(a, b)
  - less(a, b)
  - greaterOrEquals(a, b)
  - lessOrEquals(a, b)
  - like(a, b)
  - notLike(a, b)
  - a >= b AND a <= c
  - a < b OR a > c
- Logical Operators
  - not(a)
  - and(a, b)
  - or(a, b)
- Null
  - is null - where column is null
  - is not null - where column is not null

### Integer

- SIGNED
  - Int8, Int16, Int32, Int64, Int128, Int256
- UNSIGNED
  - UInt8, UInt16, UInt32, UInt64, UInt128, UInt256

### Float

- Float32
- Float64

### Decimal

- Decimal32: Precision 1 to 9, Scale O to 9
- Decimal64: Precision 10 to 18, Scale 0 to 18
- Decimal128: Precision 19 to 38, Scale 0 to 38
- Decimal256: Precision 39 to 75, Scale 0 to 75

### String

- Stored as bytes
- No fixed length

### Fixed String

- Fixed length
- Null characters are appended in case the length is less than max length

### Date

- Based on Unix Epoch (1970-01-01)
- Max date - 2149-06-06
- Stored in two bytes

### Date32

- 1900-01-01 to 2299-12-31
- Stored as Int32

### DateTime

- 1970-01-01 00:00:00 to 2106-02-07 06:28:15
- Supports IANA timezones

### DateTime64

- 1900-01-01 00:00:00 to 2299-12-31 23:59:59.99999999
- Sub-second precision is supported

### Array

- Collection of items with compatible data types
- Multi-dimensional arrays are supported and the maximum size is one million elements

### Tuple

- Similar to array but can hold incompatible data types

### Nested

- Table inside a cell
- Has column names and data types predefined
- The table inside a cell can hold any number of rows

### Enumerated & LowCardinality

- Useful in low-cardinal columns
- Provides speedup in data retrieval while querying
- Supports String, Date/ DateTime and Numeric types (Excluding Decimal)

### Geo Data Types

- Point
- Ring
- Polygon
- Multi Polygon

### Maр

- Store (Key,Value) pairs
- Key - String, Integer, LowCardinality, FixedString, UUID, Date, DateTime, Date32 and Enum
- Value - Arbitrary type

## Storage Engines

Storage engines which are also known as table engines in ClickHouse, are the software modules in a database management system that determine the way the data is organized in the disk and are responsible for the features inherent to the engine.

MergeTree family of engines is the commonly used engine type in ClickHouse, that is recommended for high load tasks. These are feature-rich engines that form the backbone of ClickHouse and are responsible for the high-speed data retrieval in ClickHouse.

### MergeTree

Example:

```sql
CREATE DATABASE IF NOT EXISTS merge_tree_example;

CREATE TABLE merge_tree_example.test (
  ID Int32,
  Name String,
  Age UInt8
)
Engine=MergeTree
PRIMARY KEY (ID)
SETTINGS index_granularity = 4;

INSERT INTO merge_tree_example.test VALUES (1, 'Alice', 25);
INSERT INTO merge_tree_example.test VALUES (2, 'Bob', 30);
INSERT INTO merge_tree_example.test VALUES (3, 'Charlie', 35);
INSERT INTO merge_tree_example.test VALUES (4, 'David', 40);
INSERT INTO merge_tree_example.test VALUES (5, 'Eve', 45);
INSERT INTO merge_tree_example.test VALUES (6, 'Frank', 50);
INSERT INTO merge_tree_example.test VALUES (7, 'Grace', 55);
INSERT INTO merge_tree_example.test VALUES (8, 'Helen', 60);
INSERT INTO merge_tree_example.test VALUES (9, 'Ivy', 65);
INSERT INTO merge_tree_example.test VALUES (10, 'Jack', 70);

SELECT * FROM merge_tree_example.test;

/*
    ┌─ID─┬─Name────┬─Age─┐
 1. │  1 │ Alice   │  25 │
 2. │  2 │ Bob     │  30 │
 3. │  3 │ Charlie │  35 │
 4. │  4 │ David   │  40 │
 5. │  5 │ Eve     │  45 │
 6. │  6 │ Frank   │  50 │
 7. │  7 │ Grace   │  55 │
 8. │  8 │ Helen   │  60 │
 9. │  9 │ Ivy     │  65 │
10. │ 10 │ Jack    │  70 │
    └────┴─────────┴─────┘
*/
```

#### MergeTree CREATE TABLE statement - Syntax

```sql
CREATE TABLE [IF NOT EXISTS] [database_name.]table_name [ON CLUSTER cluster_name]
(
column1 [datatype1] [DEFAULT|MATERIALIZED|ALIAS expr1] [TTL expr1],
column2 [datatype2] [DEFAULT|MATERIALIZED|ALIAS expr2] [TTL expr2],
...
)
ENGINE = MergeTree()
[PARTITION BY expr]
[ORDER BY expr]
[PRIMARY KEY expr]
[SAMPLE BY expr]
[TTL expr]
[SETTINGS name=value, ...]
```

#### MergeTree - Settings

- index_granularity: The number of rows in a block of the index. The default value is 8192.
- index_granularity_bytes: The size of the block of the index in bytes. The default value is 1024,000.
- min_index_granularity_bytes: The minimum size of the block of the index in bytes. The default value is 1024.
- merge_with_ttl_timeout: The maximum time in seconds that the merge operation can take. The default value is 14400.
- write_final_mark: The flag that indicates whether to write the final mark. The default value is 1.
- merge_max_block_size: The maximum size of the block in bytes. The default value is 8192.
- min_bytes_for_wide_part: The minimum size of the part in bytes. The default value is 1,024,000.
- max_compress_block_size: The maximum size of the block in bytes. The default value is 1,048,576.
- min_compress_block_size: The minimum size of the block in bytes. The default value is 65,536.
- max_partitions_to_read: The maximum number of partitions to read. The default value is -1.
- max_suspicious_broken_parts: The maximum number of suspicious broken parts. The default value is 100.
- parts_to_throw_insert: The number of parts to throw on insert. The default value is 3000.
- parts_to_delay_insert: The number of parts to delay on insert. The default value is 1000.
- max_delay_to_insert: The maximum delay in seconds to insert. The default value is 1.
- max_parts_in_total: The maximum number of parts in total. The default value is 1000000.
- max_suspicious_broken_parts_bytes: The maximum number of bytes of suspicious broken parts. The default value is 1,073,741,824.
- max_files_to_modify_in_alter_columns: The maximum number of files to modify in alter columns. The default value is 75.
- max_files_to_remove_in_alter_columns: The maximum number of files to remove in alter columns. The default value is 50.
- old_parts_lifetime: The lifetime of old parts. The default value is 480.
- clean_deleted_rows: The flag that indicates whether to clean deleted rows. The default value is 'Never'.
- max_part_loading_threads: The maximum number of part loading threads. The default value is 'CPU Cores'.

Example:

```sql
CREATE DATABASE IF NOT EXISTS mergetree_examples;

CREATE TABLE IF NOT EXISTS mergetree_examples.mergetree_partitioned
(
  ID String,
  Name String DEFAULT ID CODEC(LZ4) ,
  Quantity UInt32 CODEC(ZSTD),
  Date Date
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(Date)
PRIMARY KEY ID
ORDER BY (ID, Name, Date)
SETTINGS min_bytes_for_wide_part = 1;

INSERT INTO mergetree_examples.mergetree_partitioned VALUES
('ab', 'a', 1, '2024-01-01'),
('cd', 'a', 2, '2024-01-02'),
('de', 'b', 1, '2024-01-03');

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ ab │ a    │        1 │ 2024-01-01 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
3. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
*/
```

### Operations on Partitions

- Freeze and Unfreeze
- Attach and Detach
- Move to table
- Replace
- Update
- Delete
- Drop

Example:

```sql
CREATE TABLE IF NOT EXISTS mergetree_examples.mergetree_partitioned_1
(
  ID String,
  Name String DEFAULT ID CODEC(LZ4) ,
  Quantity UInt32 CODEC(ZSTD),
  Date Date
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(Date)
PRIMARY KEY ID
ORDER BY (ID, Name, Date)
SETTINGS min_bytes_for_wide_part = 1;

SHOW TABLES FROM merge_tree_example;

/*
   ┌─name────────────────────┐
1. │ mergetree_partitioned   │
2. │ mergetree_partitioned_1 │
   └─────────────────────────┘
*/

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ ab │ a    │        1 │ 2024-01-01 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
3. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
*/

/* Freeze command creates a backup of the partition */
ALTER TABLE mergetree_examples.mergetree_partitioned FREEZE PARTITION '20240101' WITH NAME 'freeze_example';

/* Unfreeze command to remove the backup */
ALTER TABLE mergetree_examples.mergetree_partitioned UNFREEZE WITH NAME 'freeze_example';

/* Detach partition from query */
ALTER TABLE mergetree_examples.mergetree_partitioned DETACH PARTITION '20240101';

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
*/

/* Attach partition to the table */
ALTER TABLE mergetree_examples.mergetree_partitioned ATTACH PARTITION '20240101';

/* Move partition to another table */
ALTER TABLE mergetree_examples.mergetree_partitioned MOVE PARTITION '20240101' TO TABLE mergetree_examples.mergetree_partitioned_1;

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
*/

SELECT * FROM mergetree_examples.mergetree_partitioned_1;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ ab │ a    │        1 │ 2024-01-01 │
   └────┴──────┴──────────┴────────────┘
*/

/* Replace the partition on target table from another table, in this case it works like a copy partition */
ALTER TABLE mergetree_examples.mergetree_partitioned_1 REPLACE PARTITION '20240102' FROM mergetree_examples.mergetree_partitioned;

SELECT * FROM mergetree_examples.mergetree_partitioned_1;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ ab │ a    │        1 │ 2024-01-01 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
*/

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ cd │ a    │        2 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
*/

/* Update value in a single partition */
ALTER TABLE mergetree_examples.mergetree_partitioned UPDATE Quantity = 5 IN PARTITION '20240102' WHERE TRUE;

SELECT * FROM mergetree_examples.mergetree_partitioned;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ de │ b    │        1 │ 2024-01-03 │
   └────┴──────┴──────────┴────────────┘
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
2. │ cd │ a    │        5 │ 2024-01-02 │
   └────┴──────┴──────────┴────────────┘
*/

/* Delete single partition */
ALTER TABLE mergetree_examples.mergetree_partitioned_1 DROP PARTITION '20240102';

SELECT * FROM mergetree_examples.mergetree_partitioned_1;

/*
   ┌─ID─┬─Name─┬─Quantity─┬───────Date─┐
1. │ ab │ a    │        1 │ 2024-01-01 │
   └────┴──────┴──────────┴────────────┘
*/
```

### MergeTree Family of Table Engines

Different variants of MergeTree table engine, that are available in ClickHouse.

#### ReplacingMergeTree

- Removes duplicate rows within the table with the same sorting key value (ORDER BY keys, not PRIMARY KEY)
- Data deduplication occurs when the data parts are merged in the background
- Does not guarantee the absence of duplicates in the table
- Use the FINAL keyword to get accurate results
- Data can be updated via Upserts
- Deleted rows are handled via the 'is_deleted' column

Example:

```sql
CREATE TABLE mergetree_examples.replacing_mergetree
(ID Int8, Name String)
ENGINE = ReplacingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.replacing_mergetree VALUES (1, 'a'),(2, 'b'),(3, 'c');

SELECT * FROM mergetree_examples.replacing_mergetree;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  3 │ c    │
   └────┴──────┘
*/

INSERT INTO mergetree_examples.replacing_mergetree VALUES (1, 'apple');

/*
   ┌─ID─┬─Name──┐
1. │  1 │ apple │
   └────┴───────┘
   ┌─ID─┬─Name─┐
2. │  1 │ a    │
3. │  2 │ b    │
4. │  3 │ c    │
   └────┴──────┘
*/

SELECT * FROM mergetree_examples.replacing_mergetree FINAL;

/*
   ┌─ID─┬─Name──┐
1. │  1 │ apple │
   └────┴───────┘
   ┌─ID─┬─Name─┐
2. │  2 │ b    │
3. │  3 │ c    │
   └────┴──────┘
*/
```

**ReplacingMergeTree Versioned Option**:

```sql
CREATE TABLE mergetree_examples.replacing_mergetree_versioned
(ID Int8, Name String, version UInt32)
ENGINE = ReplacingMergeTree(version)
ORDER BY (ID);

INSERT INTO mergetree_examples.replacing_mergetree_versioned VALUES (1, 'a', 2),(2, 'b', 2),(3, 'c', 2);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned FINAL;

/*
   ┌─ID─┬─Name─┬─version─┐
1. │  1 │ a    │       2 │
2. │  2 │ b    │       2 │
3. │  3 │ c    │       2 │
   └────┴──────┴─────────┘
*/

INSERT INTO mergetree_examples.replacing_mergetree_versioned VALUES (1, 'apple', 1);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned FINAL;

/*
   ┌─ID─┬─Name─┬─version─┐
1. │  2 │ b    │       2 │
2. │  3 │ c    │       2 │
   └────┴──────┴─────────┘
   ┌─ID─┬─Name─┬─version─┐
3. │  1 │ a    │       2 │
   └────┴──────┴─────────┘
*/

INSERT INTO mergetree_examples.replacing_mergetree_versioned VALUES (1, 'orange', 2);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned FINAL;

/*
   ┌─ID─┬─Name─┬─version─┐
1. │  2 │ b    │       2 │
2. │  3 │ c    │       2 │
   └────┴──────┴─────────┘
   ┌─ID─┬─Name───┬─version─┐
3. │  1 │ orange │       2 │
   └────┴────────┴─────────┘
*/
```

**ReplacingMergeTree Versioned with Delete Column**:

```sql
CREATE TABLE mergetree_examples.replacing_mergetree_versioned_deletecol
(ID Int8, Name String, version UInt32, is_deleted UInt8)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY (ID);

INSERT INTO mergetree_examples.replacing_mergetree_versioned_deletecol VALUES (1, 'a', 1, 0),(2, 'b', 1, 0);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned_deletecol FINAL;

/*
   ┌─ID─┬─Name─┬─version─┬─is_deleted─┐
1. │  1 │ a    │       1 │          0 │
2. │  2 │ b    │       1 │          0 │
   └────┴──────┴─────────┴────────────┘
*/

INSERT INTO mergetree_examples.replacing_mergetree_versioned_deletecol VALUES (1, 'a', 1, 1);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned_deletecol FINAL;

/*
   ┌─ID─┬─Name─┬─version─┬─is_deleted─┐
1. │  2 │ b    │       1 │          0 │
   └────┴──────┴─────────┴────────────┘
*/
```

#### SummingMergeTree

- Summarizes values of the columns with the numeric data type for the rows with the same sorting key value
- The values are not summarized for columns in the primary key
- If a column is neither part of the sorting key, nor a numeric column, then an arbitrary value is selected from the existing ones for rows with the same sorting key
- Can handle nested data types too

```sql
CREATE TABLE mergetree_examples.summing_mergetree
(ID Int8, Name String, Count UInt32)
ENGINE = SummingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.summing_mergetree VALUES (1, 'a', 10),(1, 'b', 20),(3, 'b', 30);

SELECT * FROM mergetree_examples.summing_mergetree;

/*
   ┌─ID─┬─Name─┬─Count─┐
1. │  1 │ a    │    30 │
2. │  3 │ b    │    30 │
   └────┴──────┴───────┘

Note that an arbitrary value is selected for the Name column for the ID = 1.
*/

CREATE TABLE mergetree_examples.summing_mergetree_v2
(ID Int8, Name String, Count UInt32, Quantity UInt32)
ENGINE = SummingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.summing_mergetree_v2 VALUES (1, 'a', 10, 10),(1, 'b', 20, 10),(3, 'b', 30, 5);

SELECT * FROM mergetree_examples.summing_mergetree_v2;

/*
   ┌─ID─┬─Name─┬─Count─┬─Quantity─┐
1. │  1 │ a    │    30 │       20 │
2. │  3 │ b    │    30 │        5 │
   └────┴──────┴───────┴──────────┘
*/
```

#### AggregatingMergeTree

- The table columns are either part of the sorting key or of the AggregateFunction/SimpleAggregateFunction type
- Rows with the same sorting key are replaced with a single row that contains the combination of states of aggregate functions
- Insert the data using the State combinator of the appropriate aggregate function
- Read the data using the Merge combinator of the appropriate aggregate function

```sql
CREATE TABLE mergetree_examples.aggregating_mergetree_source
(ID Int8, Count UInt32)
ENGINE = MergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.aggregating_mergetree_source VALUES (1, 10),(1, 20),(3, 30);

SELECT * FROM mergetree_examples.aggregating_mergetree_source;

/*
   ┌─ID─┬─Count─┐
1. │  1 │    10 │
2. │  1 │    20 │
3. │  3 │    30 │
   └────┴───────┘
*/

CREATE TABLE mergetree_examples.aggregating_mergetree
(
  ID Int8,
  count_average AggregateFunction(avg, Float64),
  count_min AggregateFunction(min, Float64),
  count_max AggregateFunction(max, Float64)
)
ENGINE = AggregatingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.aggregating_mergetree
SELECT ID,
avgState(toFloat64(Count)),
minState(toFloat64(Count)),
maxState(toFloat64(Count))
FROM mergetree_examples.aggregating_mergetree_source
GROUP BY ID;

SELECT ID, avgMerge(count_average), minMerge(count_min), maxMerge(count_max)
FROM mergetree_examples.aggregating_mergetree
GROUP BY ID;

/*
   ┌─ID─┬─avgMerge(count_average)─┬─minMerge(count_min)─┬─maxMerge(count_max)─┐
1. │  1 │                      15 │                  10 │                  20 │
2. │  3 │                      30 │                  30 │                  30 │
   └────┴─────────────────────────┴─────────────────────┴─────────────────────┘
*/

/* mergetree aggregation engine needs aggregation functions to show results properly */

SELECT * FROM mergetree_examples.aggregating_mergetree;

/*
   ┌─ID─┬─count_average─┬─count_min─┬─count_max─┐
1. │  1 │ >@            │ $@        │ 4@        │
2. │  3 │ >@            │ >@        │ >@        │
   └────┴───────────────┴───────────┴───────────┘
*/
```

#### CollapsingMergeTree

- Requires a mandatory **sign** column that can store either -1 or 1
- Rows with **+1 in the sign column** are the **state** rows
- Rows with **-1 in the sign column** are the **cancel** rows
- A pair of rows with the same sorting key but different sign values is deleted and the rows without a pair are kept
- There could be other scenarios and ClickHouse handles them based on pre-set rules

**Usage**: Perform mutations on tables, since updates and deletes are resource-intensive operations.

Initial values:

| ID  | Count | Sign |
| --- | ----- | ---- |
| 1   | 10    | 1    |
| 2   | 15    | 1    |

Additional value:

| ID  | Count | Sign |
| --- | ----- | ---- |
| 1   | 10    | -1   |

Result:

| ID  | Count | Sign |
| --- | ----- | ---- |
| 2   | 15    | 1    |

Example:

```sql
CREATE TABLE mergetree_examples.collapsing_mergetree
(ID UInt8, Value UInt32, Sign Int8)
Engine = CollapsingMergeTree(Sign)
ORDER BY ID;

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (1, 10, 1),(2, 20, 1),(3, 30, 1);

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    10 │    1 │
2. │  2 │    20 │    1 │
3. │  3 │    30 │    1 │
   └────┴───────┴──────┘
*/

/* DELETE Example */

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (1, 10, -1);

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  2 │    20 │    1 │
2. │  3 │    30 │    1 │
   └────┴───────┴──────┘
*/


/* UPDATE Example */

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (2, 10, -1),(2, 80, 1);

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  2 │    80 │    1 │
2. │  3 │    30 │    1 │
   └────┴───────┴──────┘
*/

TRUNCATE TABLE mergetree_examples.collapsing_mergetree;

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (1, 10, -1),(1, 20, 1),(1, 30, -1),(1, 40, 1);

SELECT * FROM mergetree_examples.collapsing_mergetree;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    10 │   -1 │
2. │  1 │    40 │    1 │
   └────┴───────┴──────┘
*/

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    40 │    1 │
   └────┴───────┴──────┘
*/

TRUNCATE TABLE mergetree_examples.collapsing_mergetree;

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (1, 10, -1),(1, 20, 1),(1, 30, -1);

SELECT * FROM mergetree_examples.collapsing_mergetree;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    10 │   -1 │
   └────┴───────┴──────┘
*/

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/* 0 rows in set. */

TRUNCATE TABLE mergetree_examples.collapsing_mergetree;

INSERT INTO mergetree_examples.collapsing_mergetree VALUES (1, 10, 1),(1, 20, 1),(1, 30, -1);

SELECT * FROM mergetree_examples.collapsing_mergetree;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    20 │    1 │
   └────┴───────┴──────┘
*/

SELECT * FROM mergetree_examples.collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┐
1. │  1 │    20 │    1 │
   └────┴───────┴──────┘
*/
```

#### VersionedCollapsingMergeTree

- Similar to CollapsingMergeTree but requires an additional version column along with a sign column to collapse the rows
- Uses a different collapsing algorithm
- Row pair with the same primary key and version and different Sign are collapsed
- If the version column is not part of the primary key, ClickHouse will automatically suffix the the primary key with the version column

Example:

```sql
CREATE TABLE mergetree_examples.versioned_collapsing_mergetree
(ID UInt8, Value UInt32, Sign Int8, Version UInt32)
Engine = VersionedCollapsingMergeTree(Sign, Version)
ORDER BY ID;

INSERT INTO mergetree_examples.versioned_collapsing_mergetree VALUES (1, 20, 1, 1),(1, 40, 1, 2);

SELECT * FROM mergetree_examples.versioned_collapsing_mergetree;

/*
   ┌─ID─┬─Value─┬─Sign─┬─Version─┐
1. │  1 │    20 │    1 │       1 │
2. │  1 │    40 │    1 │       2 │
   └────┴───────┴──────┴─────────┘
*/

SELECT * FROM mergetree_examples.versioned_collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┬─Version─┐
1. │  1 │    20 │    1 │       1 │
2. │  1 │    40 │    1 │       2 │
   └────┴───────┴──────┴─────────┘
*/

INSERT INTO mergetree_examples.versioned_collapsing_mergetree VALUES (1, 30, -1, 2);

SELECT * FROM mergetree_examples.versioned_collapsing_mergetree;

/*
   ┌─ID─┬─Value─┬─Sign─┬─Version─┐
1. │  1 │    30 │   -1 │       2 │
   └────┴───────┴──────┴─────────┘
   ┌─ID─┬─Value─┬─Sign─┬─Version─┐
2. │  1 │    20 │    1 │       1 │
3. │  1 │    40 │    1 │       2 │
   └────┴───────┴──────┴─────────┘
*/

SELECT * FROM mergetree_examples.versioned_collapsing_mergetree FINAL;

/*
   ┌─ID─┬─Value─┬─Sign─┬─Version─┐
1. │  1 │    20 │    1 │       1 │
   └────┴───────┴──────┴─────────┘
*/
```

#### Data Skipping Index

- An alternative for secondary index
- Can be created post table creation
- Input parameters
  - Index name
  - Index Expression
  - Type of index
  - Granularity

Example:

```sql

CREATE DATABASE datasets;

CREATE TABLE datasets.hits_v1
(
WatchID UInt64,
JavaEnable UInt8,
Title String,
GoodEvent Int16,
EventTime DateTime,
EventDate Date,
CounterID UInt32,
ClientIP UInt32,
ClientIP6 FixedString(16),
RegionID UInt32,
UserID UInt64,
CounterClass Int8,
UserAgent UInt8,
URL String,
Referrer String,
URLDomain String,
ReferrerDomain String,
Refresh UInt8,
IsRobot UInt8
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID)
SETTINGS index_granularity = 8192;

/*
SHOW TABLE datasets.hits_v1;
INSERT INTO datasets.hits_v1 SELECT * FROM generateRandom() LIMIT 100000;
*/

SELECT CounterID, ClientIP FROM datasets.hits_v1 WHERE ClientIP > 1896608200;

/*
3967199 rows in set. Elapsed: 0.021 sec. Processed 8.87 million rows, 70.99 MB (414.54 million rows/s., 3.32 GB/s.)
*/

/* Add Data Skipping Index */
ALTER TABLE datasets.hits_v1 ADD INDEX client_ip_index ClientIP TYPE bloom_filter(0.01) GRANULARITY 2;

/* Materialize the index in order to index existing data */
ALTER TABLE datasets.hits_v1 MATERIALIZE INDEX client_ip_index;


SELECT CounterID, ClientIP FROM datasets.hits_v1 WHERE ClientIP > 1896608200;

/*
1952 rows in set. Elapsed: 0.012 sec. Processed 630.11 thousand rows, 3.30 MB (51.34 mullion rows/s., 269.04 MB/S.)
*/
```

#### Choosing the right MergeTree Engine

**Append Only Data**:

- Time series data
- Events data
- Logs
- CDC

Example:

| Date       | Measure     | Value |
| ---------- | ----------- | ----- |
| 01-01-2024 | Temperature | 37.3  |
| 02-01-2024 | Temperature | 36.2  |
| 03-01-2024 | Temperature | 34.6  |

**Best Choice**: MergeTree

**Data with Mutations (Updates and Deletes)**:

- User data
- Inventory of items
- Dimension tables

Example:

| Employee ID | Salary | Designation              | Age |
| ----------- | ------ | ------------------------ | --- |
| 1           | 100000 | Software Engineer        | 25  |
| 2           | 120000 | Senior Software Engineer | 30  |
| 3           | 150000 | Tech Lead                | 35  |
| 4           | 200000 | Engineering Manager      | 40  |

**Best Choice**: ReplacingMergeTree Engine

If needed to remember the status of rows:

**Best Choice**: CollapsingMergeTree VersionedCollapsingMergeTree Engines

**Data that needs to be Aggregated**:

- Live sales data
- Realtime KPIs

Example:

| Item | Revenue | Date       |
| ---- | ------- | ---------- |
| A    | 125     | 01-01-2024 |
| B    | 214     | 01-01-2024 |
| C    | 365     | 01-01-2024 |
| A    | 174     | 02-01-2024 |
| B    | 52      | 02-01-2024 |

Aggregated as:

| Item | Revenue |
| ---- | ------- |
| A    | 299     |
| B    | 266     |
| C    | 365     |

**Best Choice**: SummingMergeTree or AggregatingMergeTree Engines

### Special and Log Table Engines

Special Table Engines are designed for a specific use case and can save a lot of time for the end users. We can store the data in RAM, buffer, or work directly with files on disk or URL using the appropriate special table engine.

#### File Table Engine

- Used to work with files on disk
- Can be used to read data from files on disk

Example:

```sql
CREATE DATABASE special_engines;

CREATE TABLE special_engines.file_engine
(
  ID UInt64,
  Name String
)
ENGINE = File('CSV');

INSERT INTO special_engines.file_engine VALUES (1, 'a'),(2, 'b'),(3, 'c');

SELECT * FROM special_engines.file_engine;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  3 │ c    │
   └────┴──────┘
*/
```

In the docker filesystem:

```bash
docker compose exec clickhouse bash
cat /var/lib/clickhouse/data/special_engines/file_engine
```

Output:

```csv
1,"a"
2,"b"
3,"c"
```

```sql
CREATE TABLE special_engines.file_engine_parquet
(
  ID UInt64,
  Name String
)
ENGINE = File('Parquet');

INSERT INTO special_engines.file_engine_parquet VALUES (1, 'a'),(2, 'b'),(3, 'c');

SELECT * FROM special_engines.file_engine_parquet;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  3 │ c    │
   └────┴──────┘
*/
```

#### Merge Table Engine

The **Merge Table Engine** and the **MergeTree Engine** are quite different.

The **MergeTree Engine** is designed for heavy weight tasks.

The **MergeTree Engine** allow us to read data from multiple tables at the same time (parallel reading).

Example:

```sql
CREATE TABLE special_engines.merge_old
(
  ID Int32,
  Name String
)
ENGINE = Log;

INSERT INTO special_engines.merge_old VALUES (1, 'old'),(2, 'old');

CREATE TABLE special_engines.merge_new
(
  ID Int32,
  Name String
)
ENGINE = Log;

INSERT INTO special_engines.merge_new VALUES (3, 'new'),(4, 'new');

SELECT * FROM special_engines.merge_old;
SELECT * FROM special_engines.merge_new;

CREATE TABLE special_engines.merge_final
ENGINE = Merge('special_engines', '^merge');

SELECT *, _table FROM special_engines.merge_final;

/*
   ┌─ID─┬─Name─┬─_table────┐
1. │  1 │ old  │ merge_old │
2. │  2 │ old  │ merge_old │
   └────┴──────┴───────────┘
   ┌─ID─┬─Name─┬─_table────┐
3. │  3 │ new  │ merge_new │
4. │  4 │ new  │ merge_new │
   └────┴──────┴───────────┘
*/

```

#### Set Table Engine

This table engine stores data in RAM and optionally on disk.
While this table supports inset statements, retrieving the data is not supported.

```sql
/* persistent = 1 writes data to disk */
CREATE TABLE special_engines.set_engine
(ID Int32)
ENGINE = Set
SETTINGS persistent = 1;

INSERT INTO special_engines.set_engine VALUES (1),(3);

SELECT * FROM special_engines.set_engine;

/*
Received exception from server (version 24.12.2):
Code: 48. DB::Exception: Received from 127.0.0.1:9000.
DB::Exception: Method read is not supported by storage Set. (NOT_IMPLEMENTED)
*/

SELECT *, _table FROM special_engines.merge_final WHERE ID IN (special_engines.set_engine);

/*
   ┌─ID─┬─Name─┬─_table────┐
1. │  1 │ old  │ merge_old │
   └────┴──────┴───────────┘
   ┌─ID─┬─Name─┬─_table────┐
2. │  3 │ new  │ merge_new │
   └────┴──────┴───────────┘
*/
```

#### Memory Table Engine

As the name suggests, this table engine stores data in RAM (volatile).
Used for testing purposes as we can end up losing the data or running out of memory.
Special settings can be used to control the memory usage.

```sql
CREATE TABLE special_engines.memory_example
(
  ID Int32,
  Name String
)
ENGINE = Memory
SETTINGS min_bytes_to_keep=20480, max_bytes_to_keep=204800, min_rows_to_keep=2, max_rows_to_keep=1024;

INSERT INTO special_engines.memory_example VALUES (1, 'a');

SELECT * FROM special_engines.memory_example;
```

#### Buffer Table Engine

This table engine is used to store data in RAM and then write it to disk.
The buffer table is volatile, so sever restarts will result in data loss.
The buffer table is useful for storing data temporarily before writing it to disk.

```sql
CREATE TABLE special_engines.buffer_storage
(
  ID Int32,
  Name String
)
Engine = MergeTree()
ORDER BY ID;

CREATE TABLE special_engines.buffer_example
AS special_engines.buffer_storage
ENGINE = Buffer(
  special_engines, -- database
  buffer_storage, -- target table
  2,    -- parallelism degree
  10,   -- minimum time in seconds to flush data to disk
  20,   -- maximum time in seconds to flush data to disk
  1,    -- minimum rows to flush data to disk
  10,   -- maximum rows to flush data to disk
  1024, -- minimum bytes to flush data to disk
  8192  -- maximum bytes to flush data to disk
);

INSERT INTO special_engines.buffer_example VALUES (1, 'a');

SELECT * FROM special_engines.buffer_example;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
   └────┴──────┘
*/

SELECT * FROM special_engines.buffer_storage;

/* Immediate query shows no data as the data is not flushed to disk yet

0 rows in set. Elapsed: 0.007 sec.

*/

SELECT * FROM special_engines.buffer_storage;

/* After 10 seconds, the data is flushed to disk

   ┌─ID─┬─Name─┐
1. │  1 │ a    │
   └────┴──────┘
*/
```

#### GenerateRandom Table Engine

This table engine is used to generate random data, only used for testing purposes.

> `Enum` and `LowCardinality` are not supported in the GenerateRandom table engine.

```sql
CREATE TABLE special_engines.generate_random
(
  ID Int8,
  Name String
)
ENGINE = GenerateRandom();

SELECT * FROM special_engines.generate_random LIMIT 10;

/*
    ┌───ID─┬─Name───────┐
 1. │  -96 │            │
 2. │   98 │ 7          │
 3. │    3 │ NX]OW|     │
 4. │  -59 │ P!         │
 5. │  118 │ #F;Zg*Im\  │
 6. │   30 │ D&U[Z<     │
 7. │  -46 │ (O)        │
 8. │  -98 │ 7          │
 9. │ -116 │ ~          │
10. │    6 │ $=BK       │
    └──────┴────────────┘
*/

CREATE TABLE special_engines.random
(
  ID Int8,
  Name String
)
ENGINE = Log;

INSERT INTO special_engines.random SELECT * FROM generateRandom() LIMIT 100;

SELECT * FROM special_engines.random LIMIT 10;

/*
    ┌───ID─┬─Name─────┐
 1. │  -84 │          │
 2. │  127 │ %o       │
 3. │  -36 │ OH@      │
 4. │   21 │          │
 5. │   36 │          │
 6. │   70 │ $5\pO@qz │
 7. │ -124 │ R\o      │
 8. │   31 │ {)H%Oc   │
 9. │   14 │ w        │
10. │  123 │          │
    └──────┴──────────┘
*/

```

#### URL Table Engine

This table engine is used to read data from an HTTP or HTTPS server directly into ClickHouse.

Supports `SELECT` and `INSERT` operations:

- **`SELECT`**: translated into an HTTP GET request
- **`INSERT`**: translated into an HTTP POST request

We have to specify the URL where the data is located.

We can also provide the file type and the compression method as optional parameters. If not provided, ClickHouse will try to determine the file type and compression method.

```sql
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
ENGINE = URL('https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2021-financial-year-provisional/Download-data/annual-enterprise-survey-2021-financial-year-provisional-csv.csv','CSV');

SELECT * FROM special_engines.url LIMIT 10;

/*
Query id: 110c657a-96a8-454b-9f73-e2a3cc0afd86

   ┌─Year─┬─Industry_aggregation_NZSIOC─┬─Industry_code_NZSIOC─┬─Industry_name_NZSIOC─┬─Units──────────────┬─Variable_code─┬─Variable_name───────────────────────────────────┬─Variable_category─────┬─Value───┬─Industry_code_ANZSIC06───────────────────────────────────────────────────────────────────────────────────────────┐
1. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H01           │ Total income                                    │ Financial performance │ 757,504 │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
2. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H04           │ Sales, government funding, grants and subsidies │ Financial performance │ 674,890 │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
3. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H05           │ Interest, dividends and donations               │ Financial performance │ 49,593  │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
4. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H07           │ Non-operating income                            │ Financial performance │ 33,020  │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
5. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H08           │ Total expenditure                               │ Financial performance │ 654,404 │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
6. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H09           │ Interest and donations                          │ Financial performance │ 26,138  │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
7. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H10           │ Indirect taxes                                  │ Financial performance │ 6,991   │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
8. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H11           │ Depreciation                                    │ Financial performance │ 27,801  │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
9. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H12           │ Salaries and wages paid                         │ Financial performance │ 123,620 │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
   └──────┴─────────────────────────────┴──────────────────────┴──────────────────────┴────────────────────┴───────────────┴─────────────────────────────────────────────────┴───────────────────────┴─────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
    ┌─Year─┬─Industry_aggregation_NZSIOC─┬─Industry_code_NZSIOC─┬─Industry_name_NZSIOC─┬─Units──────────────┬─Variable_code─┬─Variable_name────────────┬─Variable_category─────┬─Value─┬─Industry_code_ANZSIC06───────────────────────────────────────────────────────────────────────────────────────────┐
10. │ 2021 │ Level 1                     │ 99999                │ All industries       │ Dollars (millions) │ H13           │ Redundancy and severance │ Financial performance │ 275   │ ANZSIC06 divisions A-S (excluding classes K6330, L6711, O7552, O760, O771, O772, S9540, S9601, S9602, and S9603) │
    └──────┴─────────────────────────────┴──────────────────────┴──────────────────────┴────────────────────┴───────────────┴──────────────────────────┴───────────────────────┴───────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

10 rows in set. Elapsed: 1.274 sec.
*/
```

#### Dictionaries

Dictionaries are in-memory key-value pairs data structures.
Often used to replace joins in SQL. This is helpful because ClickHouse joins are not as fast as the one available in relational databases.
Dictionaries can be loaded from external data sources, like a table in another database, a file, or a Web service.
ClickHouse can automatically refresh the dictionaries at a specified interval.
Since data is stored in RAM, we can optimize joins and lookups.

```sql
CREATE TABLE special_engines.dict_src
(
ID UInt16,
Name String,
Height UInt8,
Weight UInt8
)
Engine = MergeTree
ORDER BY ID;

INSERT INTO special_engines.dict_src SELECT * FROM generateRandom() LIMIT 10000000;

SELECT * FROM special_engines.dict_src LIMIT 5;

/*
   ┌─ID─┬─Name──┬─Height─┬─Weight─┐
1. │  0 │ TGp   │    144 │      6 │
2. │  0 │ )H)   │     50 │    175 │
3. │  0 │       │      7 │     73 │
4. │  0 │       │    182 │    225 │
5. │  0 │ u+'Q/ │     34 │    156 │
   └────┴───────┴────────┴────────┘
*/

/* DROP DICTIONARY special_engines.dict_clickhouse; */

CREATE DICTIONARY special_engines.dict_clickhouse
(
  ID UInt16,
  Name String,
  Height UInt8,
  Weight UInt8
)
PRIMARY KEY ID
SOURCE (CLICKHOUSE (
  host 'localhost'
  port 9000
  user 'default'
  -- password '123456'
  db 'special_engines'
  table 'dict_src'
))
LAYOUT (FLAT)
LIFETIME(60);

SELECT COUNT(*) FROM special_engines.dict_clickhouse;

/*
   ┌─COUNT()─┐
1. │   65536 │
   └─────────┘
*/

CREATE TABLE special_engines.dict_join
(
  ID UInt16,
  Name String,
  Height UInt8,
  Weight UInt8
)
ENGINE = MergeTree
ORDER BY ID;

INSERT INTO special_engines.dict_join SELECT * FROM generateRandom() LIMIT 10000000;

SELECT COUNT(DISTINCT ID) AS id_count
FROM special_engines.dict_join AS n
INNER JOIN special_engines.dict_src AS s ON n.ID == s.ID;

/*
Query id: b7a83a9c-4972-4078-842c-819aee9333d4

   ┌─id_count─┐
1. │    65536 │
   └──────────┘

1 row in set.
Elapsed: 0.519 sec.
Processed 20.00 million rows, 40.00 MB (38.54 million rows/s., 77.08 MB/s.)
Peak memory usage: 324.64 MiB.
*/

SELECT COUNT(DISTINCT ID) as id_count_dict
FROM special_engines.dict_join
WHERE ID IN (SELECT ID FROM special_engines.dict_clickhouse);

/*
Query id: 85a3b477-7fae-4c94-a7ee-ac4b26157256

   ┌─id_count_dict─┐
1. │         65536 │
   └───────────────┘

1 row in set.
Elapsed: 0.079 sec.
Processed 10.07 million rows, 20.52 MB (127.05 million rows/s., 259.06 MB/s.)
Peak memory usage: 6.46 MiB.
*/
```

#### Log Engines

Log engines are used for light weight tasks and are commonly used for writing smaller tables.
Data is only appended and not updated or deleted (not supported).
Table is locked while inserting the data and it is not written atomically, meaning that data loss is possible in case of errors.

Options are:

- **TinyLog**:
- **Log**: Used for medium-sized tables
- **StripeLog**: Used for large tables

##### TinyLog Engine

Used for small tables for data that is written once and read many times.
Parallel read is not possible with this engine.

```sql
CREATE DATABASE log_examples;

CREATE TABLE log_examples.tiny_log
(
  ID UInt32,
  Name String
)
ENGINE = TinyLog;

INSERT INTO log_examples.tiny_log VALUES (1, 'a'),(2, 'b'),(1, 'c');

SELECT * FROM log_examples.tiny_log;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  1 │ c    │
   └────┴──────┘
*/

INSERT INTO log_examples.tiny_log VALUES (1, 'a'),(2, 'b'),(1, 'c');

SELECT * FROM log_examples.tiny_log;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  1 │ c    │
4. │  1 │ a    │
5. │  2 │ b    │
6. │  1 │ c    │
   └────┴──────┘
*/
```

##### Log Engine

Used for medium-sized tables.
The difference between the Log and TinyLog engines is that the Log engine supports parallel reading.

```sql
CREATE TABLE log_examples.log
(
  ID UInt32,
  Name String
)
ENGINE = Log;

INSERT INTO log_examples.log VALUES (1, 'a'),(2, 'b'),(1, 'c');

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  1 │ c    │
   └────┴──────┘
*/
```

##### StripeLog Engine

Used for large tables.
The difference between the Log and StripeLog engines is that the StripeLog engine supports parallel reading.

```sql
CREATE TABLE log_examples.stripe_log
(
  ID UInt32,
  Name String
)
ENGINE = StripeLog;

INSERT INTO log_examples.stripe_log VALUES (1, 'a'),(2, 'b'),(1, 'c');

SELECT * FROM log_examples.stripe_log;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
3. │  1 │ c    │
   └────┴──────┘
*/
```

## Clustering, Replication and Sharding

In a production environment, the organization may require a cluster of ClickHouse nodes to replicate the data and shard the huge dataset which could otherwise be too huge to fit in a single server.

Lets dive into:

- Data replication using Apache Zookeeper and ReplicatedMergeTree table engines
- Distributed table engine used for processing sharded data
- Replicate the shards

A ClickHouse cluster is a set of ClickHouse servers that work together to process queries and store data.

- Standalone or Cluster Mode
- Store a lot of data and replicate the data across multiple nodes
- Replication - Have redundant copies of data using the ReplicatedMergeTree family of engines
- Sharding - Partition the data horizontally across the nodes via a distributed table engine
- Requires Apache Zookeeper or ClickHouse Keeper

### Replication

Replication is the process of storing the data in more than one place in order to improve the reliability and accessibility.

For example, if one of the database server fails, we can always fall back to the other server in which the data is replicated.

ClickHouse supports table level replication via replicated Merge Tree family of engines. For every Merge Tree engine there is an equivalent replicated engine available.

For example, Summing Merge Tree as well as Replicated Summing Merge Tree Table Engine which is the replicated equivalent of the Summing Merge Tree Table Engine.

ClickHouse requires Apache Zookeeper or the ClickHouse Keeper for its replicated table engines.

We will focus on the Zookeeper based replication since Zookeeper based replication is supported in ClickHouse even before the ClickHouse Keeper was introduced.

Apache Zookeeper is a distributed coordination service to manage large set of hosts. Managing a service in a distributed environment is a complicated process.

ZooKeeper solves the distributed consistency problem in ClickHouse. ZooKeeper has an atomic broadcast protocol at its core.

A ZooKeeper cluster consists of a leader node and one or more follower nodes. ClickHouse cluster can communicate with ZooKeeper when we add the necessary configurations in the config file.

For a ClickHouse replicated table, ZooKeeper follower handles the rate requests but delegates the write requests to the leader.

In ZooKeeper, the ClickHouse-related information is stored in ZNodes. A ZNode in a ZooKeeper is a path-on-tree-like structure that represents a piece of data stored in ZooKeeper.

The ZNode stores the ClickHouse information such as the pending and completed on-cluster DDL commands, table information, schema information, replicas, leader elections used to control mergers and mutations, log of table operations such as insert, merge, deletion etc., information on data paths contained in each replica, the recently inserted data blocks, and the data to ensure quorum on rights.

Don't worry if you are not familiar with Zookeeper or its terminologies. Just remember that the Zookeeper is used in ClickHouse data replication and Zookeeper ensures consistency across the replicas.

So roughly when we insert some data into the Replicator table, the inserted data along with the metadata is transmitted to Zookeeper and the Zookeeper node transmits the data to the other ClickHouse nodes and ensures consistency.

Let us look at a simple example with a two node ClickHouse server and a single node ZooKeeper cluster to keep the things simple.

Example:

```bash
# docker startup and shutdown
cd replication/
docker compose up -d
docker compose logs -f
docker compose exec clickhouse1 bash
docker compose exec clickhouse2 bash
docker compose down --volumes --remove-orphans

# clickhouse client connection
clickhouse client --host 127.0.0.1 --port 8002 --user default
clickhouse client --host 127.0.0.1 --port 8003 --user default
```

```sql
-- Create and Drop must be performed on all the nodes
CREATE TABLE replicated_example
(ID UInt32, Name String)
ENGINE = ReplicatedMergeTree(
  '/clickhouse/tables/replicated_example', -- Zookeeper path where the ClickHouse stores the metadata of the replicated table
  '{replica}' -- unique identifier for the replica
)
ORDER BY (ID);

-- /clickhouse/tables/replicated_example is the Zookeeper path where the ClickHouse stores the metadata of the replicated table
-- {replica} is the replica name which is the unique identifier for the replica (replaced by the macros section in the XML config files)

INSERT INTO replicated_example VALUES (1, 'a'), ('2', 'b');

SELECT * FROM replicated_example;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
   └────┴──────┘
*/

TRUNCATE TABLE replicated_example;
```

### Sharding

Sharding is also known as horizontal partitioning used to distribute the data across multiple servers to improve the performance and scalability. It is a database design technique to break up a very large database into smaller, more manageable parts called shards.

Each shard is stored on a separate database server instance to spread the load and improve the performance.

We can partition the data on a MergeTree table. A partition is a logical combination of records in a MergeTree table and this logical combination is based on a user-defined criteria. Each partition is stored separately within a single ClickHouse node. But in case of sharding, the data is split and stored across multiple nodes in a cluster.

So why do we need sharding? Sharding can be used to store data that are too big to be stored in a single server. Since ClickHouse supports parallel query processing, sharding can help in increasing the parallelism while processing the data. Some of the benefits are faster query time and enables us to store super huge datasets.

Sharding can also result in increased write bandwidth since data is written in multiple servers and it is very easy to scale out a sharded cluster. Some of the drawbacks of sharding are it adds complexity by increasing the number of nodes in a cluster and there is also a possibility of unbalanced data in a shard. Which means the amount of data distributed across the nodes can be uneven and in some cases the magnitude of the difference can be very huge.

ClickHouse supports sharding with help of distributed table engine. Distributed table engine cannot store data on its own but it can access data from multiple nodes in a cluster.

So, we need a storage table in every node which would be based on any MergeTree family of engine and the distributed engine sits on top of this storage engine to perform distributed query processing.

How the data is split into shards? ClickHouse can either choose a random shard to write the data if a setting called "InsertDistributedOneRandomShard" is set to true.

Otherwise we can also have a key-based or hash-based sharding. In this technique, we will have to specify a sharding key or enclose the sharding key inside a hash function as a parameter to the distributed table. Sharding key is nothing but a column in the sharded table.

So, while configuring the shards in `config.xml` file, we can specify the shard weights for each shard. And if this is not specified, the default value for the shard weights is 1. Based on the sharding key and the shard weights, the inserted rows are stored automatically in the available shards of the cluster.

Whenever we insert the data into a distributed table, the values corresponding to the sharding key column will pass through a hash function and convert it to an integer number if the sharding key column is not of integer data type. If the sharding key column is of integer data type, then hashing the values is optional.

In this example, the shard1 has weight 2 and shard2 has weight 1. The sum of these weights is 3. After we hash the sharding key values, The remainder is taken from dividing the integer number by the total weight of all the shards.

Let us say that we have inserted 4 rows of data and the values of the sharding key column are first passed through a hash function and converted to integers.

Next we will find the modulus of the hashed values by 3 which is the total weight of all the shards. The possible remainder values are 0, 1 and 2. Since the shard1 has weight 2, it will store the rows where the modulus is 0 and 1. And shard2 will store the rows where the modulus value is 2. So based on the hash value, the data is moved to either shard1 or shard2. So, the first, third and the fourth rows will end up in shard1 and the second row will end up in shard2.

Let us look at another example. Let us say that we have a sharded table and there are two shards in the cluster with equal weights. This table has two columns, id and name and the sharding key is the id column. Let us say that we insert four rows of data. So, the values in the id column is processed and based on the weights and the hashed values, the rows are returned to either the first or the second shard.

Example:

```bash
# docker startup and shutdown
cd sharding/
docker compose up -d
docker compose logs -f
docker compose exec clickhouse1 bash
docker compose exec clickhouse2 bash
docker compose down --volumes --remove-orphans

# clickhouse client connection
clickhouse client --host 127.0.0.1 --port 8002 --user default
clickhouse client --host 127.0.0.1 --port 8003 --user default
```

```sql
-- create table in both nodes
CREATE TABLE distributed_storage
(ID UInt32, Name String)
ENGINE = MergeTree()
ORDER BY (ID);

-- create table in both nodes
CREATE TABLE distributed_example
(ID UInt32, Name String)
ENGINE = Distributed(
  'sharded_cluster', -- name of the cluster tag defined in config.xml for sharding
  'default', -- database
  distributed_storage, -- table
  intHash64(ID) -- hash the ID column for selection of the shard
  -- rand() -- random selection of shards
);

INSERT INTO distributed_example VALUES (1, 'a'), (2, 'b'), (3, 'c');

-- select in node clickhouse1
SELECT *, _shard_num FROM distributed_example;

/*
   ┌─ID─┬─Name─┬─_shard_num─┐
1. │  1 │ a    │          1 │
2. │  3 │ c    │          1 │
   └────┴──────┴────────────┘
   ┌─ID─┬─Name─┬─_shard_num─┐
3. │  2 │ b    │          2 │
   └────┴──────┴────────────┘
*/

-- select in node clickhouse2
SELECT *, _shard_num FROM distributed_example;

/*
   ┌─ID─┬─Name─┬─_shard_num─┐
1. │  2 │ b    │          2 │
   └────┴──────┴────────────┘
   ┌─ID─┬─Name─┬─_shard_num─┐
2. │  1 │ a    │          1 │
3. │  3 │ c    │          1 │
   └────┴──────┴────────────┘
*/
```

### Replication and Sharding

In a production environment, the organization may require a cluster of ClickHouse nodes to replicate the data and shard the huge dataset which could otherwise be too huge to fit in a single server.

Let us look at an example where we have a 4 node ClickHouse server and a single node ZooKeeper cluster to keep the things simple.
We will also have a sharded cluster with 2 shards and each shard will have two nodes.

Example:

```bash
# docker startup and shutdown
cd both_replication_and_sharding/
docker compose up -d
docker compose logs -f
docker compose exec clickhouse1 bash
docker compose exec clickhouse2 bash
docker compose exec clickhouse3 bash
docker compose exec clickhouse4 bash
docker compose down --volumes --remove-orphans

# clickhouse client connection
clickhouse client --host 127.0.0.1 --port 8002 --user default
clickhouse client --host 127.0.0.1 --port 8003 --user default
clickhouse client --host 127.0.0.1 --port 8004 --user default
clickhouse client --host 127.0.0.1 --port 8005 --user default
```

```sql
-- Create and Drop must be performed on all the nodes
CREATE TABLE distributed_replicated_storage
(ID UInt32, Name String)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/sharded_replicated/{shard}', '{replica}')
ORDER BY (ID);

-- '/clickhouse/tables/sharded_replicated/{shard}' --> Zookeeper path where the ClickHouse stores the metadata of the replicated table with sharding
-- '{replica}' --< unique identifier for the replica

CREATE TABLE distributed_replicated_example
(ID UInt32, Name String)
ENGINE = Distributed(
  'sharded_cluster', -- name of the cluster tag defined in config.xml for sharding
  'default', -- database
  distributed_replicated_storage, -- table
  rand() -- random selection of shards
);

-- insert in node clickhouse1
INSERT INTO distributed_replicated_example VALUES (1, 'a'), (2, 'b'), (3, 'с');

-- query in any node
SELECT *,_shard_num FROM distributed_replicated_example;

/*
   ┌─ID─┬─Name─┬─_shard_num─┐
1. │  3 │ с    │          1 │
   └────┴──────┴────────────┘
   ┌─ID─┬─Name─┬─_shard_num─┐
2. │  1 │ a    │          2 │
3. │  2 │ b    │          2 │
   └────┴──────┴────────────┘
*/

-- insert in node clickhouse3
INSERT INTO distributed_replicated_example
VALUES (4, 'd'), (5, 'e'), (6, 'f'), (7, 'g'), (8, 'h'), (9, 'i'), (10, 'j'), (11, 'k'), (12, 'l');

SELECT *,_shard_num FROM distributed_replicated_example;

/*
   ┌─ID─┬─Name─┬─_shard_num─┐
1. │  3 │ с    │          1 │
   └────┴──────┴────────────┘
   ┌─ID─┬─Name─┬─_shard_num─┐
2. │  4 │ d    │          1 │
3. │  9 │ i    │          1 │
4. │ 10 │ j    │          1 │
   └────┴──────┴────────────┘
    ┌─ID─┬─Name─┬─_shard_num─┐
 5. │  5 │ e    │          2 │
 6. │  6 │ f    │          2 │
 7. │  7 │ g    │          2 │
 8. │  8 │ h    │          2 │
 9. │ 11 │ k    │          2 │
10. │ 12 │ l    │          2 │
    └────┴──────┴────────────┘
    ┌─ID─┬─Name─┬─_shard_num─┐
11. │  1 │ a    │          2 │
12. │  2 │ b    │          2 │
    └────┴──────┴────────────┘
*/
```

## External Data sources

More often in real world usage, the data ingested in to the ClickHouse is from external data store.

ClickHouse has in built support for connecting to external data sources and ingestion.

Lets integrate ClickHouse with:

- MySQL
- PostgreSQL
- MongoDB
- Apache Kafka

### MySQL

- Commonly used transactional database management system
- Dedicated engine in ClickHouse for MySQL
- Perform INSERT and SELECT

Example:

```bash
cd integrations

# start mysql database container
docker compose up -d

# install client in macos (optional)
brew install mysql-client
echo 'export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# for troubleshooting, connect to mysql instance (optional)
docker compose exec --user root mysql bash

# connect to mysql database
source .env-mysql
mysql -v < mysql_init.sql
mysql -v -e "SELECT * FROM clickhouse.test;"
```

Output:

```txt
--------------
SELECT * FROM clickhouse.test
--------------

+---------+---------+
| column1 | column2 |
+---------+---------+
|       1 |       2 |
|       3 |       4 |
+---------+---------+
```

In ClickHouse, run this for the integration:

```bash
clickhouse client --host 127.0.0.1 --port 9000 --user default
```

```sql
-- DROP TABLE mysql_table;
CREATE TABLE mysql_table (column1 Int16, column2 Float32)
ENGINE = MySQL (
  'mysql', -- host
  'clickhouse', -- database
  'test', -- table
  'root', -- user
  'root' -- password
);

SELECT * FROM mysql_table;

/*
   ┌─column1─┬─column2─┐
1. │       1 │       2 │
2. │       3 │       4 │
   └─────────┴─────────┘
*/

INSERT INTO mysql_table VALUES (3,3.3);

SELECT * FROM mysql_table;

/*
   ┌─column1─┬─column2─┐
1. │       1 │       2 │
2. │       3 │       4 │
3. │       3 │     3.3 │
   └─────────┴─────────┘
*/
```

### PostgreSQL

- Another popular transactional database management system
- Dedicated engine in ClickHouse for PostgreSQL
- Perform INSERT and SELECT

Example:

```bash
cd integrations

# start mysql database container
docker compose up -d

# for troubleshooting, connect to mysql instance (optional)
docker compose exec --user root postgres bash

# connect to mysql database
source .env-postgres
psql --echo-all -f postgres_init.sql
psql --echo-all -d clickhouse -c "SELECT * FROM test;"
```

Output:

```txt
SELECT * FROM test;
 column1 | column2
---------+---------
       1 |       2
       3 |       4
(2 rows)
```

In ClickHouse, run this for the integration:

```bash
clickhouse client --host 127.0.0.1 --port 9000 --user default
```

```sql
-- DROP TABLE postgres_table;
CREATE TABLE postgres_table (column1 Int16, column2 Float32)
ENGINE = PostgreSQL (
  'postgres:5432', -- host:port
  'clickhouse', -- database
  'test', -- table
  'postgres', -- user
  'postgres' -- password
);

SELECT * FROM postgres_table;

/*
   ┌─column1─┬─column2─┐
1. │       1 │       2 │
2. │       3 │       4 │
   └─────────┴─────────┘
*/

INSERT INTO postgres_table VALUES (3,3.3);

SELECT * FROM mysql_table;

/*
   ┌─column1─┬─column2─┐
1. │       1 │       2 │
2. │       3 │       4 │
3. │       3 │     3.3 │
   └─────────┴─────────┘
*/

```

### MongoDB

- Document oriented NoSQL database system
- ClickHouse has MongoDB table engine (only for non nested data types)
- Can perform SELECT operation

Example:

```bash
cd integrations

# start mongodb database container
docker compose up -d

# for troubleshooting, connect to mongodb instance (optional)
docker compose exec --user root mongodb

# install client in macos (optional)
brew update
brew tap mongodb/brew
brew install mongodb-database-tools
brew install mongosh

# connect to mongodb database
source .env-mongo
mongosh
```

Create mongodb objects:

```javascript
// add data
use admin;
db.createCollection("test");
db.test.insertMany([{ID: 1, Name: "a"}, {ID: 2, Name: "b"}]);

// query data
db.test.find();
```

In ClickHouse, run this for the integration:

```bash
clickhouse client --host 127.0.0.1 --port 9000 --user default
```

```sql
-- DROP TABLE mongo_table;
CREATE TABLE mongo_table
(ID Int32, Name String)
ENGINE = MongoDB(
  'mongodb:27017', -- host:port
  'admin', -- database
  'test', -- collection
  'root', -- user
  'root' -- password
);

SELECT * FROM mongo_table;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
2. │  2 │ b    │
   └────┴──────┘
*/
```

### Apache Kafka

- An open source, distributed event streaming platform
- ClickHouse has a Kafka table engine, that can produce and consume messages/data
- We use materialized views to track the data and push/pull from Kafka table engine

```bash
cd integrations

# start kafka container
docker compose up -d

# for troubleshooting, connect to kafka instance (optional)
docker compose exec --user root kafka bash

# install client in macos (optional)
brew install kafka

# create topic
docker compose exec -ti kafka /opt/bitnami/kafka/bin/kafka-topics.sh --create --topic demo --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# list topics
docker compose exec -ti kafka /opt/bitnami/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# publish message (ctrl+c to exit)
docker compose exec -ti kafka /opt/bitnami/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic demo

# consume message (ctrl+c to exit)
docker compose exec -ti kafka /opt/bitnami/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic demo --from-beginning

# create topic
kafka-topics --create --topic test --bootstrap-server localhost:9094 --partitions 1 --replication-factor 1

# list topics
kafka-topics --list --bootstrap-server localhost:9094

# publish message
echo "Hello Kafka" | kafka-console-producer --bootstrap-server localhost:9094 --topic test

# consume message
kafka-console-consumer --bootstrap-server localhost:9094 --topic test --from-beginning -max-messages 1
```

Example:

The click house and Kafka are already running as docker containers.

We have already seen that we can either push or pull the messages from a Kafka topic using click house Kafka table engine.

To illustrate this I am going to use set of tables which will be used to push and pull the messages from a topic within a single click house server.

From the push side I will be using a push storage table which is nothing but a basic merge tree table engine and I will create a push kafka table which will push the messages to the kafka topic.

The data inserted in the push storage table will be captured by a materialized view and the data will be inserted to the push kafka table.

This kafka table will push the data as messages to a kafka topic.

In the pull side we have pull kafka table, pull storage table and a pull materialized view.

So the message that was published to Kafka topic will be read by the pull Kafka table and the materialized view will keep track of changes in the pull Kafka table and if there are any new messages in the pull Kafka table it will read the message and write the data to the pull storage table.

So when we insert a row of data in the push storage table it goes to the push Kafka table via the push materialized view and from the push Kafka table it is published to a Kafka topic and from that particular kafka topic the messages are read from the pull kafka table and whenever there are new messages in the pull kafka table the pull materialized view will read the message and write the data to the pull storage table let us look at an example for this

```sql
-- push steps
CREATE TABLE kafka_mt_push
(ID UInt64, Name String)
ENGINE = MergeTree()
ORDER BY ID;

CREATE TABLE kafka_push
(ID UInt64, Name String)
ENGINE = Kafka(
  'kafka:9092', -- list of brokers (CSV)
  'kafka_push_1', -- list of topics (CSV)
  'cgroup_1', -- consumer group
  'JSONEachRow' -- format of the message published or read (JSONEachRow, JSONCompactEachRow, etc.)
);

CREATE MATERIALIZED VIEW kafka_mv_push TO kafka_push AS SELECT ID, Name FROM kafka_mt_push;

-- pull steps
CREATE TABLE kafka_mt_pull
(ID UInt64, Name String)
ENGINE = MergeTree()
ORDER BY ID;

CREATE TABLE kafka_pull
(ID UInt64, Name String)
ENGINE = Kafka(
  'kafka:9092', -- list of brokers (CSV)
  'kafka_push_1', -- list of topics (CSV)
  'cgroup_1', -- consumer group
  'JSONEachRow' -- format of the message published or read (JSONEachRow, JSONCompactEachRow, etc.)
);

CREATE MATERIALIZED VIEW kafka_mv_pull TO kafka_mt_pull AS SELECT ID, Name FROM kafka_pull;

-- run
INSERT INTO kafka_mt_push VALUES (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e');

SELECT * FROM kafka_mt_pull;

/*
   ┌─ID─┬─Name─┐
1. │  1 │ a    │
   └────┴──────┘
*/
```
