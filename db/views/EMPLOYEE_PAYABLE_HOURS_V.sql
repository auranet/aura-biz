select	employee_name,
	employee.employee_id,
	client_name,
	client_invoice_v.client_id,
	client_invoice_v.month,
	client_invoice_v.year,
	invoice_id,
	sum(payable_amount) payable_amount,
	sum(billable_hours) billable_hours
from	billing_detail,
	employee,
	client_invoice_v
where	billing_detail.employee_id = employee.employee_id
and	billing_detail.month = client_invoice_v.month
and	billing_detail.year = client_invoice_v.year
and	billing_detail.client_id = client_invoice_v.client_id
group	by
	employee_name,
	client_name,
	client_invoice_v.client_id,
	employee.employee_id,
	client_invoice_v.month,
	client_invoice_v.year,
	invoice_id,
	pay_rate
having	sum(payable_amount) <> 0
order	by year desc,
	month desc
