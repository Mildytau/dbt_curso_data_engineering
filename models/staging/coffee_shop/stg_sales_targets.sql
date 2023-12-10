{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'sales_targets') }}
),

renamed as (
    select
        cast("sales_outlet_id" as number) as sales_outlet_id,
        cast("year_month" as varchar(4096)) as "year_month",
        cast("beans_goal" as number) as beans_goal,
        cast("beverage_goal" as number) as beverage_goal,
        cast("food_goal" as number) as food_goal,
        cast("merchandise_goal" as number) as merchandise_goal,
        cast("total_goal" as number) as total_goal
    from source
),

with_changes as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["sales_outlet_id"]) }} as varchar(4096)
        ) as sales_outlet_id,
        cast("year_month" as varchar(4096)) as year_month,
        beans_goal,
        beverage_goal,
        food_goal,
        merchandise_goal,
        total_goal
    from renamed
)

select * from with_changes
