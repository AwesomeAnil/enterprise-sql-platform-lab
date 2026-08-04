CREATE TABLE [staging].[Customer]
(
    CustomerID INT NOT NULL,
    CustomerCode VARCHAR(20) NOT NULL,
    CustomerName VARCHAR(200) NOT NULL,
    CustomerType VARCHAR(30) NOT NULL,
    Industry VARCHAR(50) NOT NULL,
    SalesTerritory VARCHAR(20) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    StateProvince VARCHAR(100) NULL,
    City VARCHAR(100) NOT NULL,
    PostalCode VARCHAR(20) NULL,
    EmailAddress VARCHAR(255) NULL,
    PhoneNumber VARCHAR(50) NULL,
    Status VARCHAR(20) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedDate DATE NOT NULL,
    SourceSystem VARCHAR(20) NOT NULL
);
GO