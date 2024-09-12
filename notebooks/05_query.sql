with products_price_details as (
select p.product_name as product_name, 
trunc(min(od.unit_price)::decimal, 2) as earliest_initial_price, 
min(o.order_date) as earliest_initial_date,
trunc(max(od.unit_price)::decimal, 2) as latest_currect_price, 
max(o.order_date) as latest_currect_date
from order_details od 
inner join orders o on od.order_id = o.order_id  
inner join products p on od.product_id = p.product_id 
group by p.product_name 
) 
select product_name, 
latest_currect_price as current_price, 
earliest_initial_price as pervious_unit_price,
trunc(((latest_currect_price/earliest_initial_price) - 1) * 100, 4) as percentage_increase
from products_price_details
where (((latest_currect_price/earliest_initial_price) - 1) * 100) not between 10 and 30
order by percentage_increase;
