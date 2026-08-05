USE SalesDW;
GO

EXEC warehouse.sp_Load_DimCustomer;
GO

EXEC warehouse.sp_Load_DimDate;
GO

EXEC warehouse.sp_Load_DimProduct;
GO