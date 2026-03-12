-- bench_init.sql
DROP TABLE IF EXISTS logs_physical CASCADE;
DROP TABLE IF EXISTS logs_virtual CASCADE;

CREATE TABLE logs_physical (
    event_time TIMESTAMP,
    event_date DATE
) PARTITION BY RANGE (event_date);

CREATE TABLE logs_virtual (
    event_time TIMESTAMP,
    event_date DATE GENERATED ALWAYS AS (event_time::date) VIRTUAL
) PARTITION BY RANGE (event_date);

-- Create 12 partitions for months in 2023 for both tables
DO $$
DECLARE
    start_date DATE := '2023-01-01';
    end_date DATE;
    i INT;
BEGIN
    FOR i IN 1..12 LOOP
        end_date := start_date + INTERVAL '1 month';
        EXECUTE format('CREATE TABLE logs_physical_p%s PARTITION OF logs_physical FOR VALUES FROM (%L) TO (%L)', i, start_date, end_date);
        EXECUTE format('CREATE TABLE logs_virtual_p%s PARTITION OF logs_virtual FOR VALUES FROM (%L) TO (%L)', i, start_date, end_date);
        start_date := end_date;
    END LOOP;
END $$;