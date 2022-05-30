#!/bin/bash

#assign arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Check number of arguments
if [ $# -ne 5]; then
  echo "requires host, port, db name, user and password"
  exit 1
fi

#save machine statistics as variable
lscpu_out=$('lscpu')
mem_info=$(cat /proc/meminfo)
hostname=$(hostname -f)

#setting hardware specificiations as variables
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "Model:" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{print $3}' | xargs | sed 's/.$//')
total_mem=$(echo "$mem_info" | egrep "MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(date -u "+%F %T")

#constructing insert statement
insert_stmt="INSERT INTO host_info (id, hostname, cpu_num, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, "Timestamp") \
VALUES(DEFAULT, '$hostname', $cpu_number, '$cpu_architecture', $cpu_model, $cpu_mhz, $l2_cache, $total_mem, '"$timestamp"')"

#set environment variable for psql password
export PGPASSWORD=$psql_password

#insert into database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit 0
