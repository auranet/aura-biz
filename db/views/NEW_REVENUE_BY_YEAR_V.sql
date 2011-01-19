select employee_name,
       payable_amount,
       paid_dt
from   payable_detail,
       employee
where  paid = 'Y'
and    payable_detail.employee_id = employee.employee_id
order  by
       paid_dt desc
