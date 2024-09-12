select c.category_name as category_name,
case
	when s.country in ('USA', 'Canada', 'Brazil') then 'America'
	when s.country in ('UK', 'Germany', 'Netherlands', 'Spain', 'France', 'Italy', 'Norway', 'Sweden', 'Denmark', 'Finland') then 'Europe'
	when s.country in ('Japan', 'Singapore') then 'Asia'
	else 
		'Oceania'
end supplier_region,
sum(p.unit_in_stock) as units_in_stock,
sum(p.unit_on_order) as units_on_order,
sum(p.reorder_level) as reorder_level
from categories c 
inner join products p on c.category_id = p.category_id 
inner join suppliers s on p.supplier_id = s.supplier_id 
group by category_name, supplier_region
order by supplier_region, category_name, reorder_level;