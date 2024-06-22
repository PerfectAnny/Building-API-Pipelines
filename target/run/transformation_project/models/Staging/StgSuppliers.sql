
  create view "NorthWind"."Staging"."StgSuppliers__dbt_tmp"
    
    
  as (
    select * from suppliers
  );