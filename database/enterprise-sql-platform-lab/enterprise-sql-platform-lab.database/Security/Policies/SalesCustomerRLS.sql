CREATE SECURITY POLICY [security].[SalesCustomerRLS]
ADD FILTER PREDICATE [security].[fn_SalesTerritoryPredicate]([SalesTerritory])
ON [warehouse].[DimCustomer]
WITH (STATE = ON);
GO