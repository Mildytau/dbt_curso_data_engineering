{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'dates_april') }}
),

renamed as (
    select
        cast("Date_ID" as number) as date_id,
        cast("transaction_date" as varchar(4096)) as transaction_date,
        cast("Week_ID" as number) as week_id,
        cast("Week_Desc" as varchar(4096)) as week_desc,
        cast("Month_ID" as number) as month_id,
        cast("Month_Name" as varchar(4096)) as month_name,
        cast("Quarter_ID" as number) as quarter_id,
        cast("Quarter_Name" as varchar(4096)) as quarter_name,
        cast("Year_ID" as number) as year_id
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["date_id"]) }} as varchar(4096)
        ) as date_id,
        transaction_date,
        week_id,
        week_desc,
        month_id,
        month_name,
        quarter_id,
        quarter_name,
        year_id
    from renamed
)

select * from with_hash
