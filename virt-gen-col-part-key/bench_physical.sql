\set r random(0, 364)
\set hr random(0, 23)
\set min random(0, 59)
\set sec random(0, 59)
INSERT INTO logs_physical (event_time, event_date) VALUES ('2023-01-01 00:00:00'::timestamp + (:r || ' days')::interval + (:hr || ' hours')::interval + (:min || ' minutes')::interval + (:sec || ' seconds')::interval, ('2023-01-01'::date + (:r || ' days')::interval)::date);