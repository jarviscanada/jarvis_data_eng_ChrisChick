#!/bin/bash

#assign arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Check number of arguments
if [ $# -ne 5 ]; then
  echo 'Requires 5 arguments (host, port, database name, user and password)'
  exit 1
fi

#save machine statistics as variable
mem_info=$(cat /proc/meminfo)
vmstatt=$(vmstat -t)
hostname=$(hostname -f)

#setting hardware specificiations as variables
memory_free=$(echo "$mem_info" | egrep "MemFree:" | awk '{print $2}' | xargs)
cpu_idle=$(echo "$vmstatt" | egrep "id" -A1 | tail -n 1 | awk '{print $15}' | xargs)
cpu_kernel=$(echo "$vmstatt" | egrep "id" -A1 | tail -n 1 | awk '{print $14}' | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(df -BM / | awk '{print $4}' | tail -n1 | tr -d M | xargs)
timestamp=$(date -u "+%F %T")

#Subquery to find host id from matching hostname
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

#constructing insert statement
insert_stmt="INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) \
VALUES('"$timestamp"', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available)"

#set environment variable for psql password
export PGPASSWORD=$psql_password

#insert into database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit 0