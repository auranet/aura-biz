select  invoice.invoice_id,
	invoice_month.year,
	invoice_month.month,
	client_name
from 	invoice_month,
	invoice,
	client
where	invoice.invoice_month_id = invoice_month.invoice_month_id
and	invoice.client_id = client.client_id
order	by
	invoice_month.year desc,
	invoice_month.month desc
