select flat_invoice_detail_v.*,
       year,
       month,
       partners.name as partner_name,
       customers.name as customer_name,
       invoices.billable_entity_type,
       invoices.billable_entity_id,
       invoices.partner_id,
       invoices.customer_id
--        client.client_name,
--        client.client_id
from   flat_invoice_detail_v,
       billable_periods,
       invoices left outer join partners on (invoices.partner_id = partners.id)
                left outer join customers on (invoices.customer_id = customers.id)
where  flat_invoice_detail_v.invoice_id = invoices.id
and    invoices.billable_period_id = billable_periods.id

--and    invoice.client_id  = client.client_id


      
