select c.category_name as category_name,
case
	when p.unit_price < 10 then '1. Below $10'
	when p.unit_price between 10 and 20 then '2. $10 - $20'
	when p.unit_price between 20 and 50 then '3. $20 - $50'
	else 
		'4. Over $50'
end price_range,
trunc (sum((od.unit_price - (od.unit_price * od.discount)) * od.quantity)::decimal, 2) as total_amount,
count(od.order_id) as total_number_orders
from categories c 
inner join products p on c.category_id = p.category_id 
inner join order_details od on p.product_id = od.product_id
group by category_name, price_range
order by category_name, price_range;