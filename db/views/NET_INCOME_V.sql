select	client_invoice_v.month,
	client_invoice_v.year,
	sum(payable_amount) payable_amount,
	sum(i_amt) i_amt,
	sum(i_amt - payable_amount) net
from	(
		select sum(payable_amount) payable_amount,
		       month,
		       year
		from   payable_detail
		group  by
		       month,
		       year
        ) payable_detail,
	(
		select	year,
			month,
			sum(i_amt) i_amt
		from	client_invoice_v
		group  by
		       month,
		       year
        ) client_invoice_v
where	client_invoice_v.month = payable_detail.month
and	client_invoice_v.year = payable_detail.year
group   by client_invoice_v.year,client_invoice_v.month
