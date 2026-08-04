CREATE TABLE [warehouse].[DimDate]
(
    DateKey         INT             NOT NULL,
    CalendarDate    DATE            NOT NULL,

    Day             TINYINT         NOT NULL,
    DayName         VARCHAR(20)     NOT NULL,
    DayOfWeek       TINYINT         NOT NULL,
    WeekNumber      TINYINT         NOT NULL,

    MonthNumber     TINYINT         NOT NULL,
    MonthName       VARCHAR(20)     NOT NULL,
    Quarter         VARCHAR(2)      NOT NULL,
    CalendarYear    SMALLINT        NOT NULL,

    FiscalMonth     TINYINT         NOT NULL,
    FiscalQuarter   VARCHAR(2)      NOT NULL,
    FiscalYear      SMALLINT        NOT NULL,

    IsWeekend       BIT             NOT NULL,
    IsMonthEnd      BIT             NOT NULL,
    IsMonthStart    BIT             NOT NULL,
    IsQuarterEnd    BIT             NOT NULL,
    IsQuarterStart  BIT             NOT NULL,
    IsYearEnd       BIT             NOT NULL,
    IsYearStart     BIT             NOT NULL,

    LoadDate        DATETIME2       NOT NULL
        CONSTRAINT DF_DimDate_LoadDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_DimDate
        PRIMARY KEY CLUSTERED (DateKey)
);
GO