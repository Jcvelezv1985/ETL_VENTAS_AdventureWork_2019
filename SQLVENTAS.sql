-- INFORME VENTAS ETL ADVEBTUREWORK2019 --

/* TABLA Dim_Producto
ProductName
ProductModel
ProductNumber
Makeflag
FinishedGoodFlag
Color
Size
SizeUnitMeasure
Weight
WeightUnitMeasure
ProductLine
Class
Style
SellStartDateKey
SellEndDateKey
DiscontinueDateKey
ModifiedDateKey
ProductCategoryName
ProductSubCategoryName
*/

SELECT 
PP.Name						AS	ProductName,
PPM.Name					AS ProductModel,
PP.ProductNumber			AS ProductNumber,
PP.MakeFlag					AS Makeflag,
PP.FinishedGoodsFlag		AS FinishedGoodFlag,
PP.Color					AS Color,
PP.Size						AS Size,
PP.SizeUnitMeasureCode		AS SizeUnitMeasure,
PP.Weight					AS Weight,
PP.WeightUnitMeasureCode	AS WeightUnitMeasure,
PP.ProductLine				AS ProductLine,
PP.Class					AS Class,
PP.Style					AS Style,
PP.SellStartDate			AS SellStartDateKey,
PP.SellEndDate				AS SellEndDateKey,
PP.DiscontinuedDate			AS DiscontinueDateKey,
PP.ModifiedDate				AS ModifiedDateKey,
PPC.Name					AS ProductCategoryName,
PPS.Name					AS ProductSubCategoryName
FROM
[AdventureWorks2019].[Production].[Product] AS PP
INNER JOIN
[AdventureWorks2019].[Production].[ProductModel] AS PPM
ON
PP.ProductModelID = PPM.ProductModelID
INNER JOIN
[AdventureWorks2019].[Production].[ProductSubcategory] AS PPS
ON
PPS.ProductSubcategoryID = PP.ProductSubcategoryID
INNER JOIN
[AdventureWorks2019].[Production].[ProductCategory]		AS PPC
ON 
PPC.ProductCategoryID = PPS.ProductCategoryID;

-- ##############################################################################################################################################

/* TABLA DimPerson
FirsName
MiddleName
LastName
FullName
Territory
CountryRegionCode
TerritoryGroup
*/

SELECT 
PP.FirstName							AS FirsName,
PP.MiddleName							AS MiddleName,
PP.LastName								AS LastName,
CONCAT(PP.FirstName,' ',PP.LastName) 	AS FullName,
SST.Name								AS Territory,
SST.CountryRegionCode					AS CountryRegionCode,
SST.[Group]								AS TerritoryGroup
FROM[AdventureWorks2019].[Person].[Person]		AS PP
INNER JOIN
[AdventureWorks2019].[Sales].[SalesPerson]		AS SP
ON
PP.BusinessEntityID = SP.BusinessEntityID
INNER JOIN
[AdventureWorks2019].[Sales].[SalesTerritory]	AS SST
ON
SST.TerritoryID = SP.TerritoryID

-- ##############################################################################################################################################

/* TABLA Dim_Sales_Territory
Territiry
CountryRegionCode
TerritoryGroup
ModifiedDateKey
*/

SELECT 
ST.[Name]				AS Territiry,
ST.CountryRegionCode	AS CountryRegionCode,
ST.[Group]				AS TerritoryGroup,
ST.ModifiedDate			AS ModifiedDateKey
FROM
[AdventureWorks2019].[Sales].[SalesTerritory]	AS ST;

/* TABLA Dim_ShipMethop
ShipmentMethod
*/

select 
PS.[Name] AS ShipmentMethod
from 
[Purchasing].[ShipMethod] AS PS

-- ##############################################################################################################################################

/* TABLA Dim_Customer
StoreName
Territory
CountryRegionCode
TerritoryGroup
NombreCompleto
ModifieddateKey
*/

select 
sto.[Name]		as StoreName,
st.[Name]		as Territory,
st.CountryRegionCode,
st.[Group]  as TerriroryGroup,
concat_ws(' ',pp.FirstName,pp.LastName) as NombreCompleto,
soh.ModifiedDate
from  
[AdventureWorks2019].[Sales].[SalesPerson] sp
inner join 
[AdventureWorks2019].[Person].[Person]  pp
on 
sp.BusinessEntityID = pp.BusinessEntityID
inner join 
[AdventureWorks2019].[Sales].[SalesTerritory] st
on 
st.TerritoryID = sp.TerritoryID
inner join 
[AdventureWorks2019].[Sales].[SalesOrderHeader] soh
on 
soh.TerritoryID = st.TerritoryID
inner join 
[AdventureWorks2019].[Sales].[Store] sto
on 
soh.SalesPersonID = sto.SalesPersonID;

-- ##############################################################################################################################################
/* TABLA Dim_SpecialOffer
Description
Type
Category
StartDateKey
EndDateKey
*/

SELECT 
SS.[Description]	AS Description,
SS.Type				AS Type,
SS.Category			AS Category,
SS.StartDate		AS StartDateKey,
SS.EndDate			AS EndDateKey
FROM
[Sales].[SpecialOffer] AS SS

-- ##############################################################################################################################################

/* TABLA Dim_Andress
AddressLine1
AddressLine2
City
PostalCode
SpatialLocation
StateProvinceID
AddressType
ModifiedDateKey
*/

select 
pa.AddressLine1,
pa.AddressLine2,
pa.City,
pa.PostalCode,
pa.SpatialLocation,
pa.StateProvinceID,
atp.[Name] as AddressType,
pa.ModifiedDate
from 
[AdventureWorks2019].[Person].[Address] as pa
inner join 
[AdventureWorks2019].[Person].[BusinessEntityAddress] as ba
on 
ba.AddressID = pa.AddressID
inner join 
[AdventureWorks2019].[Person].[AddressType] as atp
on atp.AddressTypeID = ba.AddressTypeID

-- ##############################################################################################################################################

/* TABLA Fact_SalesOrderDetail
SalesOrderDetailKey					0
SalesOrderKey						
ProductKey							0
SpecialOfferKey						0
SalesOrderStatusKey					0
SalesOrderOnlineOrderFlag			0
SalesOrderAccountNumber				0
SalesCustomerKey					0
SalesPersonKey						0
TerritoryKey						0
BitToAddressKey						0
ShipToAddressKey					0
ShipMethodKey						0
SalesOrderDetailModifiedDateKey		0
SalesOrderDateKey					0
SalesOrderDueDateKey				0
SalesOrderShipDateKey				0
SalesOredrModifiedDateKey			0
Quantity							0
UnitPrice							0
UnitPriceDiscount					0
LineTotal							0
SalesOrderSubtotal					0
SalesOrderTaxAmount					0
SalesOrderFreightAmount				0
SalesOrderTotalDue
*/

SELECT 
SSO.SalesOrderDetailID		AS SalesOrderDetailKey,
SSO.SalesOrderID			AS SalesOrderKey,
SSO.ProductID				AS ProductKey,	
SSO.SpecialOfferID			AS SpecialOfferKey,	
SSH.[Status]				AS SalesOrderStatusKey,
SSH.OnlineOrderFlag			AS SalesOrderOnlineOrderFlag,
SSH.AccountNumber			AS SalesOrderAccountNumber,
SSH.CustomerID				AS SalesCustomerKey,
SSH.SalesPersonID			AS SalesPersonKey,
SSH.TerritoryID				AS TerritoryKey,
SSH.BillToAddressID			AS BitToAddressKey,
SSH.ShipToAddressID			AS ShipToAddressKey,
SSH.ShipMethodID			AS ShipMethodKey,
SSO.ModifiedDate			AS SalesOrderDetailModifiedDateKey,
SSH.OrderDate				AS SalesOrderDateKey,
SSH.DueDate					AS SalesOrderDueDateKey,
SSH.ShipDate				AS SalesOrderShipDateKey,
SSH.ModifiedDate			AS SalesOredrModifiedDateKey,
SSO.OrderQty				AS Quantity,
SSO.UnitPrice				AS UnitPrice,
SSO.UnitPriceDiscount		AS UnitPriceDiscount,
SSO.LineTotal				AS LineTotal,
SSH.SubTotal				AS SalesOrderSubtotal,
SSH.TaxAmt					AS SalesOrderTaxAmount,
SSH.Freight					AS SalesOrderFreightAmount,
SSH.TotalDue				AS SalesOrderTotalDue
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail]	AS SSO
INNER JOIN
[AdventureWorks2019].[Sales].[SalesOrderHeader]			AS SSH
ON 
SSO.SalesOrderID = SSH.SalesOrderID;

