select *
from (
select cast(date_trunc('month', order_date) as date) as year_month,
count(order_id) as total_number_orders,
trunc (sum(freight)) as total_freight
from orders
where EXTRACT(year FROM order_date) between 1996 and 1997
group by cast(date_trunc('month', order_date) as date)
) global_performances
where total_number_orders > 20 and total_freight > 2500
order by total_freight desc;