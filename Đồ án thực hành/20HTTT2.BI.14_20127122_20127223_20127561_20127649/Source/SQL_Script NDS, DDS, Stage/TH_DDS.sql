-- CREATE DATABASE TH_DDS
-- GO
USE TH_DDS
GO

DROP TABLE Fact_Order;
DROP TABLE Dim_Date;
DROP TABLE Dim_Location;
DROP TABLE Dim_Customer;
DROP TABLE Dim_Product;

CREATE TABLE [Dim_Date] (
    [Date ID_SK] int not null identity primary key,
    [Order Date] datetime,
    [Ship Date] datetime,
    [Year] int,
    [Month] int,
    [Day] int,
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Dim_Location] (
    [Location ID_SK] int primary key,
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

CREATE TABLE [Dim_Customer] (
    [Customer ID_SK] int primary key,
    [Customer ID] nvarchar(255),
    [Customer Name] nvarchar(255),
    [Segment] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Dim_Product] (
    [Product ID_SK] int primary key,
    [Product ID] nvarchar(255),
    [Category] nvarchar(255),
    [Sub-Category] nvarchar(255),
    [Product Name] nvarchar(255),
    [Status] int,
    [CreatedDate] datetime,
    [UpdatedDate] datetime,
    [SourceID] int
)

CREATE TABLE [Fact_Order] (
    [Row ID_SK] int primary key,
    [Row ID] nvarchar(50),
    [Order ID] nvarchar(255),
    [Date ID_SK] int,
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
    [TongLoiNhuan] float,
    [TongSLDonHang] float,
    [TongChiPhiVanChuyen] float,
    [TongSLSanPham] float,
    [TongDoanhThu] float,
	CONSTRAINT FK_C_O FOREIGN KEY ([Customer ID_SK]) REFERENCES [Dim_Customer]([Customer ID_SK]),
	CONSTRAINT FK_L_O FOREIGN KEY ([Location ID_SK]) REFERENCES [Dim_Location]([Location ID_SK]),
	CONSTRAINT FK_P_O FOREIGN KEY ([Product ID_SK]) REFERENCES [Dim_Product]([Product ID_SK]), 
	CONSTRAINT FK_D_O FOREIGN KEY ([Date ID_SK]) REFERENCES [Dim_Date]([Date ID_SK])
)