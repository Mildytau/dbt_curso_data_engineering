{{config(materialized='table')}}

with source as (
    select * from {{ source('seed_data', 'dates_april') }}
),
renamed as (
    select
        "transaction_date",
        "date_id",
        "week_id",
        "week_desc",
        "month_id",
        "month_name",
        "quarter_id",
        "quarter_name",
        "year_id"
    from source
)
select * from renamed