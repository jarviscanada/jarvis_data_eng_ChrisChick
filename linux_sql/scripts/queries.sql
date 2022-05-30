/* display cpu_num, id, total memory of machines organizing by cpu number and total memory */
SELECT
  cpu_num,
  id,
  total_mem
FROM
  host_info
ORDER BY
  cpu_num ASC,
  total_mem DESC;

/*create round 5 function to round timestamps to 5 minutes */
CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$
LANGUAGE PLPGSQL;

/* create table showing average memory used over 5 minutes as a percentage */
SELECT DISTINCT
  host_usage.host_id,
  host_info.hostname,
  round5(host_usage."timestamp") AS timestamp,
  ROUND((host_info.total_mem-AVG(memory_free) OVER ( PARTITION BY round5(host_usage."timestamp")))/total_mem*100, 0) AS Average_memory_used_percentage
FROM
  host_usage
INNER JOIN
  host_info ON host_usage.host_id = host_info.id;

/* shows if crontab has updated less than 3 times over a 5 minute interval */
SELECT
  host_id,
  round5("timestamp") AS timestamp,
  count(*) AS num_data_points
FROM
  host_usage
GROUP BY
  round5("timestamp"),
  host_id
HAVING
  COUNT("timestamp") < 3
ORDER BY
  (round5("timestamp"));
