
  create view "NorthWind"."Staging"."Stgcustomers__dbt_tmp"
    
    
  as (
    select * from customers
  );