
  
    

  create  table "NorthWind"."Staging"."Top5Customers__dbt_tmp"
  
  
    as
  
  (
    SELECT
  o."contactName" AS customerName,
  COUNT(sc."orderId") AS numberofPurchases
FROM
  "NorthWind"."Staging"."Stgcustomers" o
LEFT JOIN
  "NorthWind"."Staging"."StgOrders" sc
ON
  o."customerId" = sc."customerId"
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  5
  );
  