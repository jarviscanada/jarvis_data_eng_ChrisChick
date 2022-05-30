# Linux Cluster Monitoring Agent
# Introduction
For this project the Jarvis Linux Cluster Administration (LCA) requested a product that would be able to record hardware specifications and resource usage of their Linux Cluster which contains 10 nodes/servers running on CentOS 7. The servers are internally connected and able to communicate using internal IPv4 addresses through a switch. The data gathered will be stored on a RDBMS database and the information stored would be used to generate reports for future resource planning purposes.

This project was made using Linux command lines, Bash scripts, PostgreSQL, docker and crontab. This product is able to create databases and insert the hardware specifications and data usage onto the database. The code for this project was managed using git and stored on GitHub.


# Quick Start
Create psql instance using psql_docker.sh
```
./scripts/psql_docker.sh create postgres password
```
Start psql instance using psql_docker.sh
```
./scripts/psql_docker.sh start
```
Create host_info and host_usage tables using ddl.sql
```
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql
```
Use host_info.sh to insert hardware specs into database
```
./scripts/host_info.sh "localhost" 5432 "host_agent" "postgres" "password"
```
Use host_usage.sh to insert usage data into database
```
./scripts/host_usage.sh "localhost" 5432 "host_agent" "postgres" "password"
```
Set up crontab to run host_usage.sh every minute
```
bash>crontab -e
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```

# Implemenation
SQL scripts were written and run through PostgreSQL using bash scripts. Data used for insert statements into the database were taken using bash scripts and creating an insert SQL statement. The bash scripts were then run at a set interval using crontab.

## Architecture
[Architecture diagram](./assets/Architecture.drawio.png)

## Scripts
Shell script description and usage
- psql_docker.sh

Starts docker and creates, starts or stops psql instance.
```
./scripts/docker.sh start|stop|create db_username db_password
```
- ddl.sql

Creates host_info and host_usage tables
```
psql -h psql_host -p psql_port -d db_name -U psql_user -f ./scripts/sql/ddl.sql
```
- host_info.sh

Insert hardware data into host_info database
```
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
```
- host_usage.sh

Insert usage data into host_usage database
```
./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```
- crontab

Run host_usage.sh script every minute
```
bash>crontab -e
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```
- queries.sql

This file first groups the hosts by number of cpu, and then sorts them by the total memory of each host, the second output shows the average memory usage of each host over five minutes. The final output will show if crontab has failed to update more than 3 times in a five minute interval which would mean a host failure has occurred.
```
./scripts/queries.sql
```

## Database Modeling
Schema of tables
- `host_info`

|id|hostname|cpu_num|cpu_architecture|cpu_model|cpu_mhz|l2_cache|total_mem|timestamp|
|---|---|---|---|---|---|---|---|---|
|integer|varchar|integer|varchar|varchar|varchar|int|timestamp|
|primary key|---|---|---|---|---|---|---|---|

- `host_usage`

|timestamp|host_id|memory_free|cpu_idle|cpu_kernel|disk_io|disk_available|
|---|---|---|---|---|---|---|
|timestamp|integer|integer|integer|integer|integer|integer|
|primary key|primary key|---|---|---|---|---|
|---|foreign key|---|---|---|---|---|
|---|id from host_info|---|---|---|---|---|

# Test
Bash scripts were tested using the CLI and SQL queries were tested using PostgreSQL. All scripts and queries were tested on single machine. Bash scripts were tested for all functionalities manually and SQL queries were tested with test data entered into database.

# Deployment
This app was deployed through Github, docker and crontab. Docker was used to host a psql instance and crontab was used to run a bash script to update the tables every minute. Github was used for version control of the files in this project.

# Improvements
- Be able to notify if host failure has occurred
- Make script usage commands easier to use/more simple for users
- handle hardware update
