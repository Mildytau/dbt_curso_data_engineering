{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'dates_april') }}
),

renamed as (
    select
        "Date_ID",
        "transaction_date",
        "Week_ID",
        "Week_Desc",
        "Month_ID",
        "Month_Name",
        "Quarter_ID",
        "Quarter_Name",
        "Year_ID"
    from source
)

select * from renamed
