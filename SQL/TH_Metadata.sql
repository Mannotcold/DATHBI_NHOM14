CREATE DATABASE TH_Metadata
GO 
USE TH_Metadata
GO

CREATE TABLE data_flow (
	id int not null identity(1,1),
	table_name VARCHAR(20),
	Lset DATETIME,
	CET DATETIME
)
GO

INSERT INTO data_flow (table_name, Lset, cet) VALUES
('orders_stage', '2015-01-01 00:00:00', '2015-01-01 00:00:00'),
('products_stage', '2015-01-01 00:00:00', '2015-01-01 00:00:00');




