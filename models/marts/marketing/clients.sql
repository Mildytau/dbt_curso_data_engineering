{{ config(materialized='table') }}

with source as (
    select * from {{ ref('dim_customer') }}
),

source2 as (
    select * from {{ ref('fct_sales_reciepts') }}
),

renamed as (
    select
        source2.customer_id as customer_id,
        source.customer_first_name as customer_name,
        source.gender as gender,
        source.birth_year as birth_year,
        source2.quantity as quantity,
        source2.unit_price as unit_price
    from source, source2
),

calculate as (
    select
        customer_id,
        customer_name,
        gender,
        birth_year,
        unit_price,
        sum(quantity) as units_per_client,
        sum(quantity * unit_price) as total_per_client
    from renamed
    group by
        customer_id,
        customer_name,
        gender,
        birth_year,
        unit_price
)

select * from calculate
