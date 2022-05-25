CREATE TABLE PUBLIC.host_info
    (
        id SERIAL NOT NULL,
        hostname VARCHAR NOT NULL,
        cpu_num INTEGER NOT NULL,
        cpu_architecture VARCHAR NOT NULL,
        cpu_model VARCHAR NOT NULL,
        cpu_mhz VARCHAR NOT NULL,
        L2_cache INTEGER NOT NULL,
        Total_mem INTEGER NOT NULL,
        "timestamp" TIMESTAMP NOT NULL,
        PRIMARY KEY (id)
    );