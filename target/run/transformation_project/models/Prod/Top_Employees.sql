
  
    

  create  table "NorthWind"."Staging"."Top_Employees__dbt_tmp"
  
  
    as
  
  (
    SELECT
 CONCAT(emp."firstName", ' ', emp."lastName") AS fullName,
 COUNT(ord."orderId") AS totalOrder,
 SUM(ordd."quantity" * ordd."unitPrice") AS revenue
FROM
 "NorthWind"."Staging"."StgOrderDetail" AS ordd
LEFT JOIN
 "NorthWind"."Staging"."StgOrders" AS ord
ON
 ordd."orderID" = ord."orderId"
LEFT JOIN
 "NorthWind"."Staging"."StgEmployees" AS emp
ON
 ord."employeeId" = emp."employeeId"
GROUP BY
 1
ORDER BY
 2 DESC
  );
  