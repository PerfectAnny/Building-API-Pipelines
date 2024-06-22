
  create view "NorthWind"."Staging"."stagcustomers__dbt_tmp"
    
    
  as (
    select * from customers
  );