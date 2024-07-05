{{ config(schema='CURATED') }}

with stg_product as (
    select *
    from {{ source('fivetran_database', 'product') }}
),

stg_product_category as (
    select *
    from {{ source('fivetran_database', 'productcategory')}}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_product.productid']) }} as product_key,
    stg_product.productid,
    stg_product.name as product_name,
    stg_product.productnumber,
    stg_product.color,
    stg_product_category.name as product_category_name
from stg_product
left join stg_product_category on stg_product.productcategoryid = stg_product_category.productcategoryid