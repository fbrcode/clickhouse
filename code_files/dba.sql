BACKUP TABLE employee TO Disk('backup_disk', 'employee_2024.zip');

RESTORE TABLE employee AS employee_restored_2024 FROM Disk('backup_disk', 'employee_2024.zip');

SELECT * FROM employee;

INSERT INTO employee VALUES ('e', 'city5');


BACKUP TABLE employee TO Disk('backup_disk', 'employee_2024_v2.zip')
SETTINGS base_backup = Disk('backup_disk', 'employee_2024.zip')

RESTORE TABLE employee AS employee_restored_2024_v2 FROM Disk('backup_disk', 'employee_2024_v2.zip');

BACKUP TABLE data TO S3('<S3 endpoint>/<directory>', '<Access key ID>', '<Secret access key>')

BACKUP TABLE employee TO AzureBlobStorage('<connection string>/<url>', '<container>', '<path>', '<account name>', '<account key>')


--

clickhouse-local -q "SELECT * FROM file('iris_csv.csv') LIMIT 5"

clickhouse-local -q "DESCRIBE file('iris_csv.csv')"

clickhouse-benchmark --query "SELECT COUNT(DISTINCT WatchID) FROM datasets.hits_v1 hv WHERE UserAgentMajor=24" --password 123456 --timelimit 10


