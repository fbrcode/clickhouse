CREATE DATABASE log_examples;

CREATE TABLE log_examples.tinylog
(ID UInt32,
Name String
)
Engine = TinyLog;

INSERT INTO log_examples.tinylog VALUES
(1, 'a'),
(2,'b'),
(1, 'c');

SELECT * FROM log_examples.tinylog;

CREATE TABLE log_examples.log
(ID UInt32,
Name String
)
Engine = Log;


INSERT INTO log_examples.log VALUES
(1, 'a'),
(2,'b'),
(1, 'c');

SELECT * FROM log_examples.log;

CREATE TABLE log_examples.stripelog
(ID UInt32,
Name String
)
Engine = StripeLog;


INSERT INTO log_examples.stripelog VALUES
(1, 'a'),
(2,'b'),
(1, 'c');

SELECT * FROM log_examples.stripelog;


