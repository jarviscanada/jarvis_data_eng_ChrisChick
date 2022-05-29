# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the GitFlow, the final work will be merged to the main branch after Team Code Team
#Introduction (150-200 words)
In this project, I designed a MVP that was able to monitor a cluster for the Jarvis Linux Cluster Administration (LCA). This product needed to record hardware specifications and resource usage of nodes the LCA managed in real time. The program was made using Linux command lines, Bash scripts, PostgreSQL, docker and crontab. The product is able to create databases and insert the hardware specifications and data usage onto the database. The code for this project was managed using git and stored on GitHub.

#Quick Start
Create psql instance using psql_docker.sh
`./scripts/psql_docker.sh create db_username db_password`
Start psql instance using psql_docker.sh
`./scripts/psql_docker.sh start`
Create host_info and host_usage tables using ddl.sql
`psql -h host -U user -d host -f sql/ddl.sql`
Use host_info.sh to insert hardware specs into database
`./scripts/host_info.sh "host" port "database" "db_username" "db_password"`
Use host_usage.sh to insert usage data into database
`./scripts/host_usage.sh "host" port "database" "db_username" "db_password"`
Set up crontab to run host_usage.sh every minute
```
crontab -e
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```

# Implemenation
Discuss how you implement the project.
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
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

# Test
How did you test your bash scripts and SQL queries? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware update 
- blah
- blah
