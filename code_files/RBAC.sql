
-- create user
CREATE USER 'test' IDENTIFIED WITH plaintext_password BY '123456';

SHOW USERS;

-- create role
CREATE ROLE ch_test;

SHOW ROLES;

-- create user with default role
CREATE USER 'test_1' IDENTIFIED WITH plaintext_password BY '123456' DEFAULT ROLE ch_test;

-- create user with expiration date
CREATE USER 'test_2' IDENTIFIED WITH plaintext_password BY '123456' VALID UNTIL '2025-01-01'

-- create user that is allowed to receive privileges from user "test"
CREATE USER 'test_3' IDENTIFIED WITH plaintext_password BY '123456' GRANTEES test

-- modify user to receive privileges from user "test_1"
ALTER USER test_3 GRANTEES test_1;

-- drop user(s)
DROP USER test, test_1, test_2, test_3;


------- Role

-- create database
CREATE DATABASE datasets;

SHOW DATABASES;

CREATE TABLE datasets.xyz (ID Int32, Name String) ENGINE = MergeTree ORDER BY ID;

SHOW TABLES FROM datasets;

DESCRIBE TABLE datasets.xyz;

INSERT INTO datasets.xyz VALUES (1, 'a'), (2, 'b'), (3, 'c');

SELECT * FROM datasets.xyz;

-- create role
CREATE ROLE 'test_role';

-- grant select privilege to role
GRANT SELECT ON datasets.* TO test_role;

-- revoke insert privilege from role
REVOKE INSERT ON datasets.* FROM test_role;

-- create user
CREATE USER 'test' IDENTIFIED WITH plaintext_password BY '123456';

-- grant role to user
GRANT test_role TO test;

-- login as user test and try to select and insert data
-- clickhouse client --user test --password 123456

-- show current user
SELECT currentUser();

SELECT * FROM datasets.xyz;

INSERT INTO datasets.xyz VALUES (4, 'd'), (5, 'e'), (6, 'f');

/*
Code: 497. 
DB::Exception: Received from localhost:9000. 
DB::Exception: test: Not enough privileges. 
To execute this query, it's necessary to have the grant INSERT(ID, Name) ON datasets.xyz. (ACCESS_DENIED)
*/

-- rename role
ALTER ROLE test_role RENAME TO test_role_new;

DROP ROLE test_role_new;

SHOW ROLES;

----- Settings profile

INSERT INTO datasets.xyz SELECT * FROM generateRandom() LIMIT 10000;

-- display current settings profiles
SHOW SETTINGS PROFILES;

-- display details of a settings profile
SHOW CREATE SETTINGS PROFILE default;

-- create a settings profile
CREATE SETTINGS PROFILE settings_profile_1 SETTINGS max_threads = 8;

-- display details of a settings profile
SHOW CREATE SETTINGS PROFILE settings_profile_1;

-- create role based on settings profile
CREATE ROLE settings_profile_1_role SETTINGS PROFILE settings_profile_1;

-- grant select privilege to role
GRANT SELECT ON datasets.* TO settings_profile_1_role;

CREATE USER test_settings IDENTIFIED WITH PLAINTEXT_PASSWORD BY '123456' DEFAULT ROLE settings_profile_1_role;

-- login as user test_settings and try to select data
SELECT * FROM datasets.xyz LIMIT 100;

DROP PROFILE settings_profile_1;

-- display role grants
SHOW GRANTS FOR settings_profile_1_role;

-- show user details
SHOW CREATE USER test_settings;

---------  Quotas

-- assign role settings_profile_1_role to user test
GRANT settings_profile_1_role TO test;

-- display current quotas
SHOW QUOTAS;

-- create quota
CREATE QUOTA example_quota FOR INTERVAL 15 minute MAX queries = 2 TO test;

/* message when user test reaches the limit

Code: 201. 
DB::Exception: Received from localhost:9000. 
DB::Exception: Quota for user `test` for 900s has been exceeded: queries = 4/2. 
Interval will end at 2025-01-17 14:45:00. Name of quota template: `example_quota`. (QUOTA_EXCEEDED)
*/

/* Quotas can be defined for the following parameters:

- queries 
- query_selects 
- query_inserts 
- errors 
- result_rows 
- result_bytes 
- read_rows 
- read_bytes 
- execution_time

*/

-- change quota limit
ALTER QUOTA IF EXISTS example_quota FOR INTERVAL 15 minute MAX queries = 20 TO test;

DROP QUOTA example_quota;

/* RBAC Example 

- Admin Users
  • Full access to the databases and Tables
  • Perform all the RBAC actions

- Data Owner
  • Full access to the Tables in the database called datasets
  • Async inserts enabled

- Dashboard User
  • Read access to the Tables in the database called datasets
  • Allow 100 queries with 10 min interval
  • Limit results to 1000 rows

*/

-- Init database
CREATE DATABASE datasets;
CREATE TABLE datasets.hits_v1 (WatchID Int32, UserAgentMajor Int32) ENGINE = MergeTree ORDER BY WatchID;
INSERT INTO datasets.hits_v1 SELECT * FROM generateRandom() LIMIT 1000000;
SELECT COUNT(*) FROM datasets.hits_v1;

-- Admin user
CREATE ROLE 'admin';
GRANT ALL ON *.* TO admin WITH GRANT OPTION;
CREATE USER admin_user identified WITH plaintext_password BY '123456';
GRANT admin TO admin_user;

-- Data owner
CREATE ROLE 'data_owner';
GRANT ALL ON datasets.* TO data_owner;
CREATE SETTINGS PROFILE async_insert_enable SETTINGS async_insert = 1 TO data_owner;
CREATE USER data_owner_user identified WITH plaintext_password BY '123456';
GRANT data_owner TO data_owner_user;

-- Read only
CREATE ROLE 'dashboard';
GRANT SELECT ON datasets.* TO dashboard;

CREATE QUOTA dashboard_quota FOR INTERVAL 10 minute MAX queries = 100, result_rows=1000 TO dashboard;

CREATE USER dashboard_user identified WITH plaintext_password BY '123456';
GRANT dashboard TO dashboard_user;

BACKUP TABLE employee TO Disk('backup_disk', 'employee_2024.zip');

RESTORE TABLE employee AS employee_restored_2024 FROM Disk('backup_disk', 'employee_2024.zip');

SELECT * FROM employee;

INSERT INTO employee VALUES ('e', 'city5');

-- Backup and Restore

BACKUP TABLE employee TO Disk('backup_disk', 'employee_2024_v2.zip')
SETTINGS base_backup = Disk('backup_disk', 'employee_2024.zip')

RESTORE TABLE employee AS employee_restored_2024_v2 FROM Disk('backup_disk', 'employee_2024_v2.zip');

BACKUP TABLE data TO S3('<S3 endpoint>/<directory>', '<Access key ID>', '<Secret access key>')

BACKUP TABLE employee TO AzureBlobStorage('<connection string>/<url>', '<container>', '<path>', '<account name>', '<account key>')


--

clickhouse-local -q "SELECT * FROM file('iris_csv.csv') LIMIT 5"

clickhouse-local -q "DESCRIBE file('iris_csv.csv')"

clickhouse-benchmark --query "SELECT COUNT(DISTINCT WatchID) FROM datasets.hits_v1 hv WHERE UserAgentMajor=24" --password 123456 --timelimit 10






