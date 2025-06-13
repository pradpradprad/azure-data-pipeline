CREATE DATABASE Source;
GO


USE Source;
GO


CREATE SCHEMA Sales;
GO


CREATE TABLE Sales.Chocolate_Sales (
    Sales_Person_ID INT,
    Sales_Person    VARCHAR(100),
    Country         VARCHAR(100),
    Product_ID      INT,
    Product         VARCHAR(100),
    Date            DATE,
    Amount          VARCHAR(100),
    Boxes_Shipped   INT
);
GO


CREATE TABLE Sales.Watermark_Table (
    Date    DATE
);
GO


INSERT INTO Sales.Watermark_Table (Date)
VALUES ('2000-01-01');
GO


CREATE PROCEDURE Sales.Update_Watermark_Table
    @last_load_date DATE
AS
BEGIN
    UPDATE Sales.Watermark_Table
    SET Date = @last_load_date;
END;
GO


CREATE LOGIN azure_user WITH PASSWORD = '12345';
GO


CREATE USER azure_user FOR LOGIN azure_user;
GO


GRANT SELECT ON Sales.Chocolate_Sales TO azure_user;
GRANT SELECT ON Sales.Watermark_Table TO azure_user;
GRANT EXECUTE ON OBJECT::Sales.Update_Watermark_Table TO azure_user;