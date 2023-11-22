{% snapshot users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='check',
      check_cols=['address_id'],
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('stg_users') }} where f_carga > (select max(f_carga) from {{ ref('stg_users') }})

{% endsnapshot %}