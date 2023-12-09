{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'number_customer') }}
),

renamed as (
    select
        cast("customer_id" as number) as customer_id,
        cast("home_store" as number) as home_store,
        cast("customer_first_name" as varchar(1024)) as customer_first_name,
        cast("customer_email" as varchar(1024)) as customer_email,
        cast("customer_since" as date) as customer_since,
        cast("loyalty_card_number" as varchar(1024)) as loyalty_card_number,
        cast("birthdate" as date) as birth_date,
        cast("gender" as varchar(1024)) as gender,
        cast("birth_year" as number) as birth_year
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as varchar(1024)
        ) as customer_id,
        home_store,
        customer_first_name,
        customer_email,
        customer_since,
        loyalty_card_number,
        birth_date,
        gender,
        birth_year
    from renamed
)

select * from with_hash
