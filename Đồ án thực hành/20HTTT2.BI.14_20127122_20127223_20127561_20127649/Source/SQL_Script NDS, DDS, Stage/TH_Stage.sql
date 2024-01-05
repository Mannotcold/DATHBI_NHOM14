-- CREATE DATABASE TH_Stage
-- GO
USE TH_Stage
GO

CREATE TABLE [Order_Stage] (
    [Row ID] nvarchar(50),
    [Order ID] nvarchar(255),
    [Order Date] datetime,
    [Ship Date] datetime,
    [Ship Mode] nvarchar(255),
    [Customer ID] nvarchar(255),
    [Customer Name] nvarchar(255),
    [Segment] nvarchar(255),
    [City] nvarchar(255),
    [State] nvarchar(255),
    [Country] nvarchar(255),
    [Postal Code] nvarchar(50),
    [Market] nvarchar(255),
    [Region] nvarchar(255),
    [Product ID] nvarchar(255),
    [Sales] float,
    [Quantity] float,
    [Discount] float,
    [Profit] float,
    [Shipping Cost] float,
    [Order Priority] nvarchar(255),
    [Status] int
)

CREATE TABLE [Product_Stage] (
    [Product ID] nvarchar(255),
    [Category] nvarchar(255),
    [Sub-Category] nvarchar(255),
    [Product Name] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime
)
