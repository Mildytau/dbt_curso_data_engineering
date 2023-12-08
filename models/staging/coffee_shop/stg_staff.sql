{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'staff') }}
),

renamed as (
    select
        "staff_id",
        "first_name",
        "last_name",
        "position",
        "start_date",
        "location",
        "g",
        "h"
    from source
)

select * from renamed
