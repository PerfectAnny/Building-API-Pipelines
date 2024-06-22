
  
    

  create  table "NorthWind"."Staging"."Revenue_by_productcategory__dbt_tmp"
  
  
    as
  
  (
    SELECT 
C."categoryName" AS Productcategory,
SUM(Ordd."unitPrice" * Ordd."quantity") AS Revenue,
SUM(Ordd."discount") AS Total_discount_amount
FROM
"NorthWind"."Staging"."Stgcategories" AS C
LEFT JOIN 
"NorthWind"."Staging"."StgProduct" as P
ON 
P."categoryId" = C."categoryId"
LEFT JOIN 
"NorthWind"."Staging"."StgOrderDetail" AS Ordd
ON
Ordd."productID"= P."productId"
GROUP BY
1
ORDER BY 
5 DESC
  );
  