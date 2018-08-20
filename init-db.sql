-- -*- sql-product: postgres; -*-

CREATE USER user1 PASSWORD 'password';

CREATE DATABASE metrics OWNER user1;

\c metrics

-- https://bitbucket.org/mahlon/netdata-tsrelay/src

CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

-- base table
CREATE TABLE netdata (
    time timestamptz default now() not null,
    host text not null,
    metrics jsonb default '{}'::jsonb not NULL
);

GRANT SELECT, INSERT ON netdata TO user1;

-- auto partition weekly
SELECT create_hypertable( 'netdata', 'time', migrate_data => true, chunk_time_interval => '1 week'::INTERVAL );
