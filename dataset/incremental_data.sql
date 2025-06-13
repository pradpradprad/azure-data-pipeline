-- 2 new sales persons / 2 updated sales persons
-- 2 new country
-- 2 new products / 1 updated product
-- 4 new dates

INSERT INTO Sales.Chocolate_Sales(
	Sales_Person_ID, Sales_Person, Country,
	Product_ID, Product, Date, Amount, Boxes_Shipped
) VALUES
(50, 'New Name', 'UK', 1, 'Updated Product', '2023-07-25', '$1100', 5),
(51, 'New Name2', 'USA', 15, 'Mint Chip Choco', '2023-08-13', '5300  ', 10),
(1, 'Updated Name', 'New Country', 50, 'New Product', '2023-09-17', '  $9,000', 40),
(2, 'Updated Name2', 'New Country2', 51, 'New Product2', '2023-10-21', ' $10120', 100);