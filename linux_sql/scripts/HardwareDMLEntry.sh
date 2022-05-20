#!/bin/bash

mem_info=$(cat /proc/meminfo)
vmstatt=$(vmstat -t)
vmstatd=$(vmstat -d)
vmstatio=$(vmstat --unit M)
hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "Model:" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(echo "$mem_info" | egrep "MemTotal:" | awk '{print $2}' | xargs)

psql -h localhost -p 5432 -U postgres -d postgres -f HardwareDML.sql -v hostname='$hostname' -v cpu_number='#cpu_number' -v \
cpu_architecture='$cpu_architecture' -v cpu_model='$cpu_model' -v cpu_mhz='$cpu_mhz' -v l2_cache='$l2_cache' -v total_mem='$total_mem'
