# ClickHouse

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
