select 
    md5(created_at) as unique_id,
    *
from {{ source('sql_server_dbo', 'orders')}}