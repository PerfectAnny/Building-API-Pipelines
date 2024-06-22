
  create view "NorthWind"."Staging"."Stgcategories__dbt_tmp"
    
    
  as (
    select * from categories
  );