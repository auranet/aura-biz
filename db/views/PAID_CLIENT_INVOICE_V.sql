select	*
from	CLIENT_INVOICE_V
where	total_invoiceable <= c_amt + p_amt
