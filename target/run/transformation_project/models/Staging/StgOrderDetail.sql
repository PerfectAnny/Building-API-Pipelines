
  create view "NorthWind"."Staging"."StgOrderDetail__dbt_tmp"
    
    
  as (
    select * from "NorthWind"."Staging"."Order_detail"
  );