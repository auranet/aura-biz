select id.*, name as detail_type from invoice_details id,invoice_detail_types idt where id.invoice_detail_type_id = idt.id;
