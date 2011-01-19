select	invoice_id,
 	sum(case when detail_type = 'I' then amount else 0 end) as I_AMT,
 	sum(case when detail_type = 'C' then amount else 0 end) as C_AMT,
 	sum(case when detail_type = 'X' then amount else 0 end) as X_AMT,
 	sum(case when detail_type = 'A' then amount else 0 end) as A_AMT,
 	sum(case when detail_type = 'B' then amount else 0 end) as B_AMT,
 	sum(case when detail_type = 'D' then amount else 0 end) as D_AMT,
 	sum(case when detail_type = 'P' then amount else 0 end) as P_AMT,
 	sum(case when detail_type = 'R' then amount else 0 end) as R_AMT,
 	sum(case when detail_type = 'I' then amount else 0 end) + sum(case when detail_type = 'R' then amount else 0 end ) + sum(case when detail_type = 'A' then amount else 0 end) - (sum(case when detail_type = 'C' then amount else 0 end ) + sum(case when detail_type = 'X' then amount else 0 end )) as TOTAL_INVOICEABLE
from 	invoice_detail_v
group   by
	invoice_id
order	by
	invoice_id desc;
