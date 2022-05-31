CREATE TABLE PUBLIC.host_usage
(
  "timestamp" TIMESTAMP NOT NULL,
  host_id SERIAL NOT NULL,
  memory_free INTEGER NOT NULL,
  cpu_idle INTEGER NOT NULL,
  cpu_kernel INTEGER NOT NULL,
  disk_io INTEGER NOT NULL,
  disk_available INTEGER NOT NULL,
  CONSTRAINT PK_host_usage PRIMARY KEY ("timestamp",host_id)
);