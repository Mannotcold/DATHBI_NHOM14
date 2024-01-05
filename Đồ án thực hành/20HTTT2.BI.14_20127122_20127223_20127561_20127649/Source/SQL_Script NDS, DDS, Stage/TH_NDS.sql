-- CREATE DATABASE TH_NDS
-- GO
USE TH_NDS
GO

DROP TABLE Order_NDS;
DROP TABLE Location_NDS;
DROP TABLE Customer_NDS;
DROP TABLE Product_NDS;

CREATE TABLE [Location_NDS] (
    [Location ID_SK] int not null identity primary key,
    [City] nvarchar(255),
    [State] nvarchar(255),
    [Country] nvarchar(255),
    [Postal Code] nvarchar(50),
    [Market] nvarchar(255),
    [Region] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Customer_NDS] (
    [Customer ID_SK] int not null identity primary key,
    [Customer ID] nvarchar(255),
    [Customer Name] nvarchar(255),
    [Segment] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Product_NDS] (
    [Product ID_SK] int not null identity primary key,
    [Product ID] nvarchar(255),
    [Category] nvarchar(255),
    [Sub-Category] nvarchar(255),
    [Product Name] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Order_NDS] (
    [Row ID_SK] int not null identity primary key,
    [Row ID] nvarchar(50),
    [Order ID] nvarchar(255),
    [Order Date] datetime,
    [Ship Date] datetime,
    [Ship Mode] nvarchar(255),
    [Customer ID_SK] int,
    [Location ID_SK] int,
    [Product ID_SK] int,
    [Sales] float,
    [Quantity] float,
    [Discount] float,
    [Profit] float,
    [Shipping Cost] float,
    [Order Priority] nvarchar(255),
    [Status] int,
    [SourceID] int,
	CONSTRAINT FK_C_O FOREIGN KEY ([Customer ID_SK]) REFERENCES [Customer_NDS]([Customer ID_SK]),
	CONSTRAINT FK_L_O FOREIGN KEY ([Location ID_SK]) REFERENCES [Location_NDS]([Location ID_SK]),
	CONSTRAINT FK_P_O FOREIGN KEY ([Product ID_SK]) REFERENCES [Product_NDS]([Product ID_SK])
)
