SELECT
  CASE
    WHEN Salesorder.SalesPersonID IS NULL THEN 'online'
    ELSE 'offline'
END
  AS Salestype,
  Productcategory.name AS CategoryName,
  productsubcategory.name AS SubCategoryName,
  COUNT(DISTINCT salesorderdetail.SalesOrderID) AS TotalOrders,
  CAST(SUM(salesorderdetail.LineTotal) AS INT64) AS Revenue,
  CAST(SUM(product.StandardCost  salesorderdetail.OrderQty) AS INT64) AS StandardCostExpenses,
  CAST(SUM(salesorderdetail.LineTotal - (product.StandardCost  salesorderdetail.OrderQty)) AS INT64) AS Profit,
FROM `adwentureworks_db.product` AS product
LEFT JOIN   `adwentureworks_db.productsubcategory` AS productsubcategory
ON  product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
LEFT JOIN  `adwentureworks_db.productcategory` AS Productcategory
ON productsubcategory.ProductCategoryID = Productcategory.ProductCategoryID
LEFT JOIN  `adwentureworks_db.salesorderdetail` AS salesorderdetail
ON  product.ProductID = salesorderdetail.ProductID
JOIN `adwentureworks_db.salesorderheader` AS Salesorder
ON salesorderdetail.SalesOrderID=Salesorder.SalesOrderID
WHERE
  Productcategory.name IS NOT NULL
  AND salesorderdetail.LineTotal IS NOT NULL
GROUP BY
  Productcategory.name,
  productsubcategory.name,
  Salestype
ORDER BY
  Revenue DESC
