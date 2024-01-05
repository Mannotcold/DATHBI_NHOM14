USE TH_Metadata
GO
SELECT * FROM DATA_FLOW;
TRUNCATE TABLE DATA_FLOW;

USE TH_Stage
GO
SELECT * FROM Order_Stage;
SELECT * FROM Product_Stage;
SELECT DISTINCT COUNT(*) FROM Order_Stage;
SELECT DISTINCT COUNT(*) FROM Product_Stage;

USE TH_Stage
GO
TRUNCATE TABLE Order_Stage;
TRUNCATE TABLE Product_Stage;

SELECT DISTINCT City, State, Country, [Postal Code], Market, Region, Status FROM Order_Stage;
SELECT DISTINCT [Customer ID], [Customer Name], Segment, Status FROM Order_Stage;

USE TH_NDS
GO
SELECT * FROM Location_NDS;
SELECT * FROM Customer_NDS;
SELECT * FROM Product_NDS;
SELECT * FROM Order_NDS;

USE TH_NDS
GO
SELECT DISTINCT COUNT(*) FROM Location_NDS;
SELECT DISTINCT COUNT(*) FROM Customer_NDS;
SELECT DISTINCT COUNT(*) FROM Product_NDS;
SELECT DISTINCT COUNT(*) FROM Order_NDS;

USE TH_Stage
GO
-- Order_NDS
SELECT O.[Row ID], O.[Order ID], O.[Order Date], O.[Ship Date], O.[Ship Mode], C.[Customer ID_SK], L.[Location ID_SK], P.[Product ID_SK], O.Sales, O.Quantity, O.Discount, O.Profit, O.[Shipping Cost], O.[Order Priority], O.Status
FROM [dbo].[Orders_Stage] O
JOIN [TH_NDS].[dbo].[Customer_NDS] C ON O.[Customer ID] = C.[Customer ID] AND O.[Customer Name] = C.[Customer Name] AND O.Segment = C.Segment
JOIN [TH_NDS].[dbo].[Location_NDS] L ON O.City = L.City AND O.State = L.State AND O.Country = L.Country AND O.[Postal Code] = L.[Postal Code] AND O.Market = L.Market AND O.Region = L.Region
JOIN [TH_NDS].[dbo].[Product_NDS] P ON O.[Product ID] = P.[Product ID]


USE TH_DDS
GO
SELECT * FROM Dim_Date;
SELECT * FROM Dim_Location;
SELECT * FROM Dim_Customer;
SELECT * FROM Dim_Product;
SELECT * FROM Fact_Order;

USE TH_DDS
GO
SELECT DISTINCT COUNT(*) FROM Dim_Date;
SELECT DISTINCT COUNT(*) FROM Dim_Location;
SELECT DISTINCT COUNT(*) FROM Dim_Customer;
SELECT DISTINCT COUNT(*) FROM Dim_Product;
SELECT DISTINCT COUNT(*) FROM Fact_Order;

USE TH_NDS
GO
-- 1. Thống kê lợi nhuận theo từng quốc gia
SELECT L.Country, SUM(O.Profit) AS TongLoiNhuan
FROM Fact_Order O, Dim_Location L 
WHERE O.[Location ID_SK] = L.[Location ID_SK] AND O.Status = 1
GROUP BY L.Country;

-- 2. Thống kê số lượng đơn hàng và chi phí vận chuyển theo ngày/ tháng/ năm 

SELECT
    [Order Date],
    COUNT(*) AS TongSLDonHang,
    SUM([Shipping Cost]) AS TongChiPhiVanChuyen
FROM
    [Fact_Order] FO
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    [Order Date];


SELECT
    D.[Year],
    D.[Month],
    COUNT(*) AS TongSLDonHang,
    SUM(FO.[Shipping Cost]) AS TongChiPhiVanChuyen
FROM
    [Fact_Order] FO
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    D.[Year],
    D.[Month];


SELECT
    D.[Year],
    COUNT(*) AS TongSLDonHang,
    SUM(FO.[Shipping Cost]) AS TongChiPhiVanChuyen
FROM
    [Fact_Order] FO
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    D.[Year];


-- 3. Thống kê số lượng sản phẩm bán được theo từng danh mục (Category) và danh mục con (Sub-Category) theo từng tháng/năm
SELECT
    DP.[Category],
    DP.[Sub-Category],
    D.[Year],
    D.[Month],
    SUM(FO.[Quantity]) AS TongSLSanPham
FROM
    [Fact_Order] FO
JOIN
    [Dim_Product] DP ON FO.[Product ID_SK] = DP.[Product ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    DP.[Category],
    DP.[Sub-Category],
    D.[Year],
    D.[Month];


SELECT
    DP.[Category],
    DP.[Sub-Category],
    D.[Year],
    SUM(FO.[Quantity]) AS TongSLSanPham
FROM
    [Fact_Order] FO
JOIN
    [Dim_Product] DP ON FO.[Product ID_SK] = DP.[Product ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    DP.[Category],
    DP.[Sub-Category],
    D.[Year];


-- 4. Phân khúc khách hàng nào mang lại nhiều lợi nhuận nhất trong mỗi tháng/ năm
SELECT
    D.[Year],
    DC.[Segment],
    SUM(FO.[Profit]) AS TongLoiNhuan
FROM
    [Fact_Order] FO
JOIN
    [Dim_Customer] DC ON FO.[Customer ID_SK] = DC.[Customer ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    D.[Year],
    DC.[Segment];


SELECT
    D.[Year],
    D.[Month],
    DC.[Segment],
    SUM(FO.[Profit]) AS TongLoiNhuan
FROM
    [Fact_Order] FO
JOIN
    [Dim_Customer] DC ON FO.[Customer ID_SK] = DC.[Customer ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    D.[Year],
    D.[Month],
    DC.[Segment];


-- 5. Thống kê số lượng sản phẩm được bán theo từng quốc gia và thị trường
SELECT
    DL.[Country],
    DL.[Market],
    SUM(FO.[Quantity]) AS TongSLSanPham
FROM
    [Fact_Order] FO
JOIN
    [Dim_Location] DL ON FO.[Location ID_SK] = DL.[Location ID_SK]
GROUP BY
    DL.[Country],
    DL.[Market];


-- 6. So sánh doanh thu của từng khu vực theo từng ngày/ tháng/ năm
SELECT
    DL.[Region],
    D.[Order Date],
    SUM(FO.[Sales]) AS TongDoanhThu
FROM
    [Fact_Order] FO
JOIN
    [Dim_Location] DL ON FO.[Location ID_SK] = DL.[Location ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    DL.[Region],
    D.[Order Date];

SELECT
    DL.[Region],
    D.[Year],
    D.[Month],
    SUM(FO.[Sales]) AS TongDoanhThu
FROM
    [Fact_Order] FO
JOIN
    [Dim_Location] DL ON FO.[Location ID_SK] = DL.[Location ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    DL.[Region],
    D.[Year],
    D.[Month];


SELECT
    DL.[Region],
    D.[Year],
    SUM(FO.[Sales]) AS TongDoanhThu
FROM
    [Fact_Order] FO
JOIN
    [Dim_Location] DL ON FO.[Location ID_SK] = DL.[Location ID_SK]
JOIN
    [Dim_Date] D ON FO.[Date ID_SK] = D.[Date ID_SK]
GROUP BY
    DL.[Region],
    D.[Year];


-- STAGE
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

--NDS
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

-- DDS

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