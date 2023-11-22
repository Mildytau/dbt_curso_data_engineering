{% snapshot users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at='_fivetran_synced',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('stg_users') }} where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endsnapshot %}