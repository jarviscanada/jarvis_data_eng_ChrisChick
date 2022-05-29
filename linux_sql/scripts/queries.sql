SELECT
  cpu_num,
  id,
  total_mem
FROM
  host_info
ORDER BY
  cpu_num ASC,
  total_mem DESC;

