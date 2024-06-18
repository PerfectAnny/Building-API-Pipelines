SELECT
  o."contactName" AS customerName,
  COUNT(sc."orderId") AS numberofPurchases
FROM
  {{ ref('Stgcustomers') }} o
LEFT JOIN
  {{ ref('StgOrders') }} sc
ON
  o."customerId" = sc."customerId"
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  5
