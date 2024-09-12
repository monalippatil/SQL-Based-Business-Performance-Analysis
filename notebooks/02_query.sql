select *
from (
select ship_country as shipping_country,
trunc (avg(shipped_date - order_date), 2) as average_days_between_order_shipping,
count(order_id) as total_voulme_orders
from orders 
where EXTRACT(year FROM shipped_date ) = '1997'
group by ship_country
having count(order_id) > 5
) countries_performance
where average_days_between_order_shipping  >= 3 and  average_days_between_order_shipping < 20
order by average_days_between_order_shipping desc;
