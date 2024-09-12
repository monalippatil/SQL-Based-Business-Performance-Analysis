with employees_kpi as (
select o.employee_id as employee_id,
concat (e.first_name, ' ', e.last_name) as employee_full_name,
e.title as employee_title,
trunc(sum(od.unit_price * od.quantity)::decimal, 2) as total_sales_amount_excluding_discount,
count(distinct o.order_id) as number_unique_orders, 
count(o.order_id) as number_orders,
trunc((sum(od.unit_price * od.quantity)/count(distinct od.product_id))::decimal, 2) as average_product_amount,
trunc((sum(od.unit_price * od.quantity)/count(distinct o.order_id))::decimal, 2) as average_order_amount,
trunc(sum((od.unit_price - (od.unit_price * od.discount)) * od.quantity)::decimal, 2) as total_sales_amount_including_discount
from orders o 
inner join order_details od on od.order_id = o.order_id 
inner join employees e on e.employee_id = o.employee_id 
group by o.employee_id, concat (e.first_name, ' ', e.last_name), e.title
)
select 
employee_full_name,
employee_title,
total_sales_amount_excluding_discount,
number_unique_orders,
number_orders,
average_product_amount,
average_order_amount,
(total_sales_amount_excluding_discount - total_sales_amount_including_discount) as total_discount_amount,
total_sales_amount_including_discount,
trunc((((total_sales_amount_excluding_discount - total_sales_amount_including_discount) * 100)/total_sales_amount_excluding_discount)::decimal ,2) as total_discount_percent
from employees_kpi
order by total_sales_amount_including_discount desc;