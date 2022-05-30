# Linux Cluster Monitoring Agent
# Introduction (150-200 words)
In this project, I designed a MVP that was able to monitor a cluster for the Jarvis Linux Cluster Administration (LCA). This product needed to record hardware specifications and resource usage of nodes the LCA managed in real time. The program was made using Linux command lines, Bash scripts, PostgreSQL, docker and crontab. The product is able to create databases and insert the hardware specifications and data usage onto the database. The code for this project was managed using git and stored on GitHub.

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
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

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
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware update 
- blah
- blah
