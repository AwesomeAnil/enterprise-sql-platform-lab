GRANT EXECUTE
ON SCHEMA::pipeline
TO role_etl;

GRANT SELECT
ON SCHEMA::staging
TO role_etl;