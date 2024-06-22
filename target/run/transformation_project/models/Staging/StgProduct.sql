
  create view "NorthWind"."Staging"."StgProduct__dbt_tmp"
    
    
  as (
    select * from products
  );