{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'sales_targets') }}
),

renamed as (
    select
        cast(sales_outlet_id as varchar(4096)) as sales_outlet_id,
        cast(year_month as varchar(4096)) as year_month,
        cast(beans_goal as varchar(4096)) as beans_goal,
        cast(beverage_goal as varchar(4096)) as beverage_goal,
        cast(food_goal as varchar(4096)) as food_goal,
        cast(merchandise_goal as varchar(4096)) as merchandise_goal,
        cast(total_goal as varchar(4096)) as total_goal
    from source
),

with_coalesce as (
    select
        coalesce(nullif(sales_outlet_id,''), NULL) as sales_outlet_id,
        coalesce(nullif(year_month,''), NULL) as year_month,
        coalesce(nullif(beans_goal,''), NULL) as beans_goal,
        coalesce(nullif(beverage_goal,''), NULL) as beverage_goal,
        coalesce(nullif(food_goal,''), NULL) as food_goal,
        coalesce(nullif(merchandise_goal,''), NULL) as merchandise_goal,
        coalesce(nullif(total_goal,''), NULL) as total_goal
    from renamed
),

with_re_change as (
    select
        cast(sales_outlet_id as number) as sales_outlet_id,
        year_month,
        cast(beans_goal as number) as beans_goal,
        cast(beverage_goal as number) as beverage_goal,
        cast(food_goal as number) as food_goal,
        cast(merchandise_goal as number) as merchandise_goal,
        cast(total_goal as number) as total_goal
    from with_coalesce
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["sales_outlet_id"]) }} as varchar(4096)
        ) as sales_outlet_id,
        year_month,
        beans_goal,
        beverage_goal,
        food_goal,
        merchandise_goal,
        total_goal
    from with_re_change
)

select * from with_hash
