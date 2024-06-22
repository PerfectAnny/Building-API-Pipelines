
  create view "NorthWind"."Staging"."StgShippers__dbt_tmp"
    
    
  as (
    select * from shippers
  );