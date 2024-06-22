
  create view "NorthWind"."Staging"."Stgregions__dbt_tmp"
    
    
  as (
    select * from regions
  );