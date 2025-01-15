-- Replacing MergeTree

SHOW TABLES FROM mergetree_examples;

CREATE TABLE mergetree_examples.replacing_mergetree
(ID Int8,
Name String
)
ENGINE = ReplacingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.replacing_mergetree
VALUES
(1, 'a'),
(2, 'b'),
(3, 'c');

SELECT * FROM mergetree_examples.replacing_mergetree;

INSERT INTO mergetree_examples.replacing_mergetree
VALUES
(1, 'apple');

OPTIMIZE TABLE mergetree_examples.replacing_mergetree;

CREATE TABLE mergetree_examples.replacing_mergetree_versioned
(ID Int8,
Name String,
version UInt8
)
ENGINE = ReplacingMergeTree(version)
ORDER BY (ID);

INSERT INTO mergetree_examples.replacing_mergetree_versioned
VALUES
(1, 'a', 2),
(2, 'b', 2),
(3, 'c', 2);

SELECT * FROM mergetree_examples.replacing_mergetree_versioned;

INSERT INTO mergetree_examples.replacing_mergetree_versioned
VALUES
(1, 'apple', 1);

INSERT INTO mergetree_examples.replacing_mergetree_versioned
VALUES
(1, 'orange', 2);

OPTIMIZE TABLE mergetree_examples.replacing_mergetree_versioned ;



-- Summing mergeTree

SHOW DATABASES;

SHOW TABLES FROM mergetree_examples;

CREATE TABLE mergetree_examples.summing_mergetree
(ID Int8,
Name String,
Count UInt32
)
ENGINE = SummingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.summing_mergetree
VALUES
(1, 'a', 10),
(1, 'b', 20),
(3, 'b', 30);

SELECT * FROM mergetree_examples.summing_mergetree;

INSERT INTO mergetree_examples.summing_mergetree
VALUES
(3, 'apple', 40);

INSERT INTO mergetree_examples.summing_mergetree
VALUES
(4, 'c', 0), (4, 'd', 0);

OPTIMIZE TABLE mergetree_examples.summing_mergetree;

CREATE TABLE mergetree_examples.summing_mergetree_v2
(ID Int8,
Name String,
Count UInt32,
Quantity UInt32
)
ENGINE = SummingMergeTree(Quantity)
ORDER BY (ID);

SELECT * FROM mergetree_examples.summing_mergetree_v2;

INSERT INTO mergetree_examples.summing_mergetree_v2
VALUES
(1, 'a', 10, 10),
(1, 'b', 20, 10),
(3, 'b', 30, 5);


-- Aggregating megetree


CREATE TABLE mergetree_examples.aggregating_mergetree_source
(ID Int8,
Count UInt32
)
ENGINE = MergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.aggregating_mergetree_source
VALUES
(1, 10),
(1, 20),
(3, 30);

SELECT * FROM mergetree_examples.aggregating_mergetree_source;


CREATE TABLE mergetree_examples.aggregating_mergetree
(ID Int8,
count_average AggregateFunction(avg, Float64) ,
count_min AggregateFunction(min, Float64),
count_max AggregateFunction(max, Float64)
)
ENGINE = AggregatingMergeTree()
ORDER BY (ID);

INSERT INTO mergetree_examples.aggregating_mergetree
SELECT ID,
avgState(toFloat64(Count)) as count_average,
minState(toFloat64(Count)) as count_min,
maxState(toFloat64(Count)) as count_max
FROM mergetree_examples.aggregating_mergetree_source
GROUP BY ID;



SELECT ID, avgMerge(count_average), minMerge(count_min), maxMerge(count_max)
FROM mergetree_examples.aggregating_mergetree
GROUP BY ID;

--collapsing mergeTree

CREATE TABLE mergetree_examples.collapsing_mergetree
(
ID UInt8,
Value UInt32,
Sign Int8
)
Engine = CollapsingMergeTree(Sign)
ORDER BY ID;

INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(1, 10, 1),
(2, 20, 1),
(3, 30, 1);

SELECT * FROM mergetree_examples.collapsing_mergetree;

OPTIMIZE TABLE mergetree_examples.collapsing_mergetree;

INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(1, 10, -1);


INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(2, 10, -1),
(2, 80, 1);


ALTER TABLE mergetree_examples.collapsing_mergetree
DELETE  WHERE ID >0;

-- Equal number of stte and cancel rows

INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(1, 10, -1),
(1, 20, 1),
(1, 30, -1),
(1, 40, 1);

-- Cancel rows > state rows

INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(1, 10, -1),
(1, 20, 1),
(1, 30, -1);

-- state rows > cancel rows

INSERT INTO mergetree_examples.collapsing_mergetree
VALUES
(1, 10, 1),
(1, 20, 1),
(1, 30, -1);


-- Versionedcollapsing

CREATE TABLE mergetree_examples.versioned_collapsing_mergetree
(
ID UInt8,
Value UInt32,
Sign Int8,
Version UInt32
)
Engine = VersionedCollapsingMergeTree(Sign, Version)
ORDER BY ID;

INSERT INTO mergetree_examples.versioned_collapsing_mergetree
VALUES
(1, 20, 1, 1),
(1, 40, 1, 2);

INSERT INTO mergetree_examples.versioned_collapsing_mergetree
VALUES
(1, 30, -1, 2);

SELECT * FROM mergetree_examples.versioned_collapsing_mergetree;

OPTIMIZE TABLE mergetree_examples.versioned_collapsing_mergetree;

ALTER  TABLE mergetree_examples.versioned_collapsing_mergetree
DELETE WHERE ID>0;

