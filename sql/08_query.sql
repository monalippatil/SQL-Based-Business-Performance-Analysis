with product_category_details as (
select p.category_id as category_id, 
round (avg(p.unit_price)::decimal, 2) as average_unit_price,
round (PERCENTILE_CONT(0.5) within group (order by p.unit_price)::decimal, 2) as median_unit_price
from products p 
where p.discontinued = 0
group by p.category_id
)
select c.category_name as category_name,
p2.product_name as product_name,
p2.unit_price as unit_price,
pcd.average_unit_price as average_unit_price,
pcd.median_unit_price as median_unit_price,
case 
	when p2.unit_price < average_unit_price then 'Below Average'
	when p2.unit_price = average_unit_price then 'Average'
	when p2.unit_price > average_unit_price then 'Over Average'
end average_unit_price_position,
case 
	when p2.unit_price < median_unit_price then 'Below Median'
	when p2.unit_price = median_unit_price then 'Median'
	when p2.unit_price > median_unit_price then 'Over Median'
end median_unit_price_position
from product_category_details pcd 
inner join products p2 on pcd.category_id = p2.category_id 
inner join categories c on p2.category_id = c.category_id
where p2.discontinued = 0
order by category_name, product_name;