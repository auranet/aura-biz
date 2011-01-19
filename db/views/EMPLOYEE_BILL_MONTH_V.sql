select	employee_name,
	client_name,
	billing_detail.month,
	billing_detail.year,
	sum(hours) hours,
	sum(billable_amount) billable_amount,
	sum(payable_amount) payable_amount
from 	billing_detail,
	task_time,
	employee,
	client
where	billing_detail.employee_id = employee.employee_id
and	billing_detail.task_time_id = task_time.task_time_id
and	billing_detail.client_id =  client.client_id
group 	by
	billing_detail.month,
	billing_detail.year,
	employee_name,
	client_name
order	by
	billing_detail.year desc,
	billing_detail.month desc
