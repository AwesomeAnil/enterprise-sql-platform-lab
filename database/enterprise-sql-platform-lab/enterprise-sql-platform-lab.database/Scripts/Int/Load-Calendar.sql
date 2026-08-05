TRUNCATE TABLE staging.Calendar;
GO

BULK INSERT staging.Calendar
FROM '/tmp/calendar_3653.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO