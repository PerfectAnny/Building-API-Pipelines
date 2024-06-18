SELECT 
P."productName" AS Products,
SUM(ordd."quantity") AS Total_quantity_sold,
COUNT (ordd."orderID") AS Total_no_of_orders
FROM 
{{ ref('StgProduct') }} AS P
LEFT JOIN 
{{ ref('StgOrderDetail') }} AS ordd
ON
P."productId" = ordd."productID"
GROUP BY 
1
ORDER BY
2 DESC
LIMIT 10