{{ config(materialized='table') }}

with source as (
    select * from {{ source('coffee_shop','stg_sales_targets') }}
),

renamed as (
    select
        sales_outlet_id,
        year_month,
        beans_goal,
        beverage_goal,
        food_goal,
        merchandise_goal,
        total_goal
    from source
)

select * from renamed
