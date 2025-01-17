# get sample dataset and extract
wget https://datasets.clickhouse.com/cell_towers.csv.xz
xz -d cell_towers.csv.xz

# create database and table
clickhouse client --host 127.0.0.1 --port 9000 --user default --multiline --queries-file ddl.sql

# load data into the structure
clickhouse client --host 127.0.0.1 --port 9000 --user default --query "INSERT INTO sample_dataset.cell_towers FORMAT CSVWithNames" < cell_towers.csv

# check results
clickhouse client --host 127.0.0.1 --port 9000 --user default --query "SELECT COUNT(*) FROM sample_dataset.cell_towers"
clickhouse client --host 127.0.0.1 --port 9000 --user default --query "SELECT radio, COUNT(*) FROM sample_dataset.cell_towers GROUP BY radio"
clickhouse client --host 127.0.0.1 --port 9000 --user default --query "SELECT * FROM sample_dataset.cell_towers LIMIT 5"
