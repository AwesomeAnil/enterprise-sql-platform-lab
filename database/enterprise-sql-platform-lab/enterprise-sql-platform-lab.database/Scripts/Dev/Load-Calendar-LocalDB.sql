USE SalesDW;
GO

TRUNCATE TABLE staging.Calendar;
GO

BULK INSERT staging.Calendar
FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\calendar\calendar_3653.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

SELECT COUNT(*) AS CalendarRows
FROM staging.Calendar;
GO