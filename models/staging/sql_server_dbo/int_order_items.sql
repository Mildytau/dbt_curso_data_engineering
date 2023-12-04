with order_items as (
    select *
    from {{ ref('stg_order_items') }}
),
orders as (
    select *
    from {{ ref('stg_orders') }}
)
products as (
    select *
    from {{ ref('stg_products') }}
)

temporal as (

    select
        order_id,
        product_id,
        name,
        inventory,
        shipping_service,
        shipping_cost,
        quantity,
        price,
        order_cost,
        order_total,
        _fivetran_synced

    from order_items a
    inner join orders b
        on a.order_id = b.order_id
    inner join products c
        on a.product_id = c.product_id

)

select * from temporal