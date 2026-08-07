GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA::warehouse
TO role_developer;

GRANT EXECUTE
ON SCHEMA::pipeline
TO role_developer;