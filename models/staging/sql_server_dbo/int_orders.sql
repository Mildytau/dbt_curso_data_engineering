with orders as (
    select *
    from {{ ref('stg_orders') }}
),
dates as (
    select date_id
    from {{ ref('dim_date') }}
)

select
    a.order_id,
    a.user_id,
    a.promo_id,
    a.address_id,
    b.date_id,
    a.created_at,
    a.estimated_delivery_at,
    a.delivered_at,
    a.tracking_id,
    a.status,
    a.date_load
from orders as a
inner join dates as b
    on a.date_id = b.date_id

