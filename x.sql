select	billable_tasks.name,
	employees.last_name,
	billable_periods.month,
	billable_periods.id,
	customers.name || ' - ' || partners.name,
	hours,
	partner_contract_id
from 	task_hours,
	billable_tasks,
	employees,
	billable_periods,
	partner_contracts,
	customers,
	partners
where	task_hours.billable_task_id = billable_tasks.id
and	task_hours.employee_id = employees.id
and	task_hours.billable_period_id = billable_periods.id
-- and	month = 10
and	billable_tasks.partner_contract_id = partner_contracts.id
and	partner_contracts.partner_id = partners.id
and	partner_contracts.customer_id = customers.id
-- and 	partners.name = 'ASAP'
order 	by month
;

