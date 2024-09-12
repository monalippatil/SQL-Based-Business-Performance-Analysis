select concat(e.first_name, ' ', e.last_name) as employee_full_name,
e.title as employee_title,
EXTRACT(year FROM (AGE(e.hire_date, e.birth_date))) as employee_age,
EXTRACT(year from (AGE(CURRENT_DATE, e.hire_date))) as employee_tenure,
concat(m.first_name , ' ', m.last_name) as manager_full_name,
m.title as manager_title
from employees e 
left join employees m on e.reports_to  = m.employee_id 
order by employee_age, employee_full_name;