--singular data test
-- Sales should have a positive, so the total amount should always be >= 0.
-- Therefore return records where total_amount < 0 to make the test fail.
select
    sales_keyv2,
    sum(SalesOrderTotalDueAmount) as total_amount
from {{ ref('fct_salesorderdetail' )}}
group by 1
having total_amount < 0