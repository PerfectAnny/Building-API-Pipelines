
  create view "NorthWind"."Staging"."StgOrders__dbt_tmp"
    
    
  as (
    select * from orders
  );