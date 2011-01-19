select	*
from	CLIENT_INVOICE_V
where	(i_amt + r_amt + a_amt) > (c_amt + p_amt + x_amt)
