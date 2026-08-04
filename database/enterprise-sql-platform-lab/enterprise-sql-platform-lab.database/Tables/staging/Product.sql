CREATE TABLE [staging].[Product]
(
    ProductID      INT             NOT NULL,
    ProductCode    VARCHAR(20)     NOT NULL,
    ProductName    VARCHAR(200)    NOT NULL,
    Category       VARCHAR(50)     NOT NULL,
    SubCategory    VARCHAR(50)     NOT NULL,
    Brand          VARCHAR(50)     NOT NULL,
    UnitPrice      DECIMAL(18,2)   NOT NULL,
    StandardCost   DECIMAL(18,2)   NOT NULL,
    Status         VARCHAR(20)     NOT NULL,
    CreatedDate    DATE            NOT NULL,
    ModifiedDate   DATE            NOT NULL,
    SourceSystem   VARCHAR(20)     NOT NULL
);
GO