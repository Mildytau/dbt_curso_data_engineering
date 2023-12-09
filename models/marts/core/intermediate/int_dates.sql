{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_dates') }}
),

renamed as (
    select
        date_id,
        transaction_date,
        week_id,
        week_desc,
        month_id,
        month_name,
        quarter_id,
        quarter_name,
        year_id
    from source
)

select * from renamed
