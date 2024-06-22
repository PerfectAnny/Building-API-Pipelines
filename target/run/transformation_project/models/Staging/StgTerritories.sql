
  create view "NorthWind"."Staging"."StgTerritories__dbt_tmp"
    
    
  as (
    slelect * from Territories
  );