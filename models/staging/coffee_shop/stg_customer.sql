{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'customer') }}
),

renamed as (
    select
        cast(customer_id as varchar(4096)) as customer_id,
        cast(home_store as varchar(4096)) as home_store,
        cast(customer_first_name as varchar(4096)) as customer_first_name,
        cast(customer_email as varchar(4096)) as customer_email,
        cast(customer_since as varchar(4096)) as customer_since,
        cast(loyalty_card_number as varchar(4096)) as loyalty_card_number,
        cast(birthdate as varchar(4096)) as birth_date,
        cast(gender as varchar(4096)) as gender,
        cast(birth_year as varchar(4096)) as birth_year
    from source
),

with_coalesce as (
    select
        coalesce(nullif(customer_id,''), NULL) as customer_id,
        coalesce(nullif(home_store,''), NULL) as home_store,
        coalesce(nullif(customer_first_name,''), NULL) as customer_first_name,
        coalesce(nullif(customer_email,''), NULL) as customer_email,
        coalesce(nullif(customer_since,''), NULL) as customer_since,
        coalesce(nullif(loyalty_card_number,''), NULL) as loyalty_card_number,
        coalesce(nullif(birth_date,''), NULL) as birth_date,
        coalesce(nullif(gender,''), NULL) as gender,
        coalesce(nullif(birth_year,''), NULL) as birth_year,
    from renamed
),

with_re_change as (
    select
        cast(customer_id as number) as customer_id,
        cast(home_store as number) as home_store,
        customer_first_name,
        customer_email,
        cast(customer_since as date) as customer_since,
        loyalty_card_number,
        cast(birthdate as date) as birth_date,
        gender,
        cast(birth_year as number) as birth_year
    from with_coalesce
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as varchar(4096)
        ) as customer_id,
        home_store,
        customer_first_name,
        customer_email,
        customer_since,
        loyalty_card_number,
        birth_date,
        gender,
        birth_year
    from with_re_number
)

select * from with_hash
