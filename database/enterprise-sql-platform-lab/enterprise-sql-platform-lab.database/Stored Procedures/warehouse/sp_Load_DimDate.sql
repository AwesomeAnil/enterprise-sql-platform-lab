CREATE PROCEDURE [warehouse].[sp_Load_DimDate]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE [warehouse].[DimDate];

    INSERT INTO [warehouse].[DimDate]
    (
        DateKey,
        CalendarDate,
        Day,
        DayName,
        DayOfWeek,
        WeekNumber,
        MonthNumber,
        MonthName,
        Quarter,
        CalendarYear,
        FiscalMonth,
        FiscalQuarter,
        FiscalYear,
        IsWeekend,
        IsMonthEnd,
        IsMonthStart,
        IsQuarterEnd,
        IsQuarterStart,
        IsYearEnd,
        IsYearStart
    )
    SELECT
        DateKey,
        CalendarDate,
        Day,
        DayName,
        DayOfWeek,
        WeekNumber,
        MonthNumber,
        MonthName,
        Quarter,
        CalendarYear,
        FiscalMonth,
        FiscalQuarter,
        FiscalYear,
        IsWeekend,
        IsMonthEnd,
        IsMonthStart,
        IsQuarterEnd,
        IsQuarterStart,
        IsYearEnd,
        IsYearStart
    FROM staging.Calendar;
END;
GO