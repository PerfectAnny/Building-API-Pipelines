
  create view "NorthWind"."Staging"."StgEmployees__dbt_tmp"
    
    
  as (
    select * from employees
  );