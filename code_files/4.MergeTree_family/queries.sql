CREATE DATABASE mergetree_examples;

CREATE TABLE mergetree_examples.simple_mergetree (
Name String,
ID UInt8,
Price UInt32
)
Engine = MergeTree()
PRIMARY KEY (Name, ID)
SETTINGS
index_granularity =2,
min_bytes_for_wide_part = 1;

INSERT INTO mergetree_examples.simple_mergetree VALUES
('Apple', 1, 2)
('Apple', 2, 1)
('Apple', 3, 3)
('Mango', 1, 1)
('Mango', 2, 1)
('Mango', 3, 2)
('Grapes', 1, 1)
('Grapes', 2, 1);

CREATE TABLE [IF NOT EXISTS] [database_name.]table_name [ON CLUSTER
cluster_name]
(
column1 [datatype1] [DEFAULT|MATERIALIZED|ALIAS expr1] [TTL expr1],
column2 [datatype2] [DEFAULT|MATERIALIZED|ALIAS expr2] [TTL expr2],
...
...
) ENGINE = MergeTree()
[PARTITION BY expr]
[ORDER BY expr]
[PRIMARY KEY expr]
[SAMPLE BY expr]
[TTL expr]
[SETTINGS name=value, ...]


CREATE TABLE IF NOT EXISTS mergetree_examples.mergetree_partitioned (
ID String,
Name String DEFAULT ID CODEC(LZ4),
Quantity UInt32 CODEC(ZSTD),
"Date" Date,
ENGINE = MergeTree()
PARTITION BY toYYYYMMDD(Date)
PRIMARY KEY (ID)
ORDER BY (ID, Name, Date)
SETTINGS
index_granularity=1024;

INSERT INTO mergetree_testing.mergetree VALUES
('ab','a', 1, '2024-01-01'),
('cd','a', 2, '2024-01-02'),
('de','b', 1, '2024-01-03');



index_granularity: Default value is 8192. This value determines the
number of rows between marks of an index.
•
 index_granularity_bytes: Default value is 10 Mb. This value determines
the maximum size of each granule.
•
 enable_mixed_granularity_parts: If enabled, the granule size is
controlled by index_granularity_bytes, or else it is controlled by index_
granularity settings. Enabling this for tables with huge row sizes can
improve the efficiency of SELECT queries on the table.
•
 use_minimalistic_part_header_in_zookeeper: If enabled, this setting
stores headers of data part in a single znode in Zookeeper. This setting is for
replicated tables.
•
 min_merge_bytes_to_use_direct_io: Based on the storage size of data
that is merged, ClickHouse uses direct I/O.
•
 merge_with_ttl_timeout: Default value: 86400 (units – seconds, which is
equal to one day). Minimum time delay in seconds before repeating a merge
with TTL.
•
 write_final_mark: Default value is 1. Toggles writing the final index mark
at the end of the data part.
•
 merge_max_block_size: Default value is 8192. A maximum number of
rows in a block for merge operations.


---


CREATE TABLE IF NOT EXISTS mergetree_examples.mergetree_partitioned_1 (
ID String,
Name String DEFAULT ID CODEC(LZ4),
Quantity UInt32 CODEC(ZSTD),
"Date" Date)
ENGINE = MergeTree()
PARTITION BY toYYYYMMDD(Date)
PRIMARY KEY (ID)
ORDER BY (ID, Name, Date)
SETTINGS
index_granularity=1024;

ALTER TABLE mergetree_examples.mergetree_partitioned FREEZE PARTITION '20240101' WITH NAME 'test';
ALTER TABLE mergetree_examples.mergetree_partitioned UNFREEZE WITH NAME 'test';

ALTER TABLE mergetree_examples.mergetree_partitioned DETACH PARTITION '20240101';

SELECT * FROM mergetree_examples.mergetree_partitioned;

ALTER TABLE mergetree_examples.mergetree_partitioned ATTACH PARTITION '20240101';

ALTER TABLE mergetree_examples.mergetree_partitioned MOVE PARTITION  '20240101'
TO TABLE mergetree_examples.mergetree_partitioned_1;

SELECT * FROM mergetree_examples.mergetree_partitioned_1;

ALTER TABLE mergetree_examples.mergetree_partitioned_1 REPLACE PARTITION  '20240102'
FROM mergetree_examples.mergetree_partitioned;

ALTER TABLE mergetree_examples.mergetree_partitioned UPDATE Quantity  = 5 IN PARTITION  '20240102' WHERE TRUE;

ALTER TABLE mergetree_examples.mergetree_partitioned_1 DROP PARTITION  '20240102';
