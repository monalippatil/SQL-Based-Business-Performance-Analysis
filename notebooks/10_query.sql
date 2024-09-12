with categorywise_employee_amount as (
select c.category_id as category_id,
e2.employee_id employee_id, 
sum((od2.unit_price - (od2.unit_price * od2.discount)) * od2.quantity) as total_employee_categorywise_amount
from categories c 
inner join products p on c.category_id = p.category_id  
inner join order_details od2 on p.product_id = od2.product_id 
inner join orders o2 on od2.order_id = o2.order_id 
inner join  employees e2 on o2.employee_id = e2.employee_id 
group by c.category_id, e2.employee_id
),
employeewise_across_all_category_amount as (
select e.employee_id as employee_id,
concat (e.first_name, ' ', e.last_name) as employee_full_name,
sum((od.unit_price - (od.unit_price * od.discount)) * od.quantity) as total_sales_amount_including_discount
from employees e
inner join orders o on e.employee_id = o.employee_id 
inner join order_details od on o.order_id = od.order_id  
group by e.employee_id, concat (e.first_name, ' ', e.last_name)
),
categorywise_across_all_employees_amount as (
select c2.category_id as category_id,
c2.category_name as category_name,
sum((od3.unit_price - (od3.unit_price * od3.discount)) * od3.quantity) as total_categorywise_amount
from categories c2  
inner join products p2 on c2.category_id = p2.category_id 
inner join order_details od3 on p2.product_id = od3.product_id 
inner join orders o3 on od3.order_id = o3.order_id 
inner join employees e3 on o3.employee_id = e3.employee_id 
group by c2.category_id, c2.category_name
)
select 
category_name,
employee_full_name, 
round(total_employee_categorywise_amount::decimal, 2) as total_sales_amount,
round((total_employee_categorywise_amount/total_sales_amount_including_discount)::decimal, 5) as percent_of_employeee_sales,
round((total_employee_categorywise_amount/total_categorywise_amount)::decimal, 5) as percent_of_category_sales
from categorywise_employee_amount cea
inner join employeewise_across_all_category_amount ea on cea.employee_id = ea.employee_id
inner join categorywise_across_all_employees_amount ca on cea.category_id =  ca.category_id
order by category_name asc, total_sales_amount desc;