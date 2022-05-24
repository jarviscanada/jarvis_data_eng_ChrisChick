#!/bin/bash

mem_info=$(cat /proc/meminfo)
vmstatt=$(vmstat -t)
memory_free=$(echo "$mem_info" | egrep "MemFree:" | awk '{print $2}' | xargs)
cpu_idle=$(echo "$vmstatt" | egrep "id" -A1 | tail -n 1 | awk '{print $15}' | xargs)
cpu_kernel=$(echo "$vmstatt" | egrep "id" -A1 | tail -n 1 | awk '{print $14}' | xargs)
disk_io=$(vmstat -d | awk '{print $4}' | tail -n1 | xargs)
disk_available=$(df -BM / | awk '{print $4}' | tail -n1 | tr -d M | xargs)
timestamp=$(date -u "+%F %T")

psql -h localhost -p 5432 -U postgres -d postgres -f ResourceUsageDML.sql -v timestamp="'$timestamp'" -v host_id=$host_id \
-v memory_free=$memory_free -v cpu_idle=$cpu_idle -v cpu_kernel=$cpu_kernel -v disk_io=$disk_io -v disk_available=$disk_available