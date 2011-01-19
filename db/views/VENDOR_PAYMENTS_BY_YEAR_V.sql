select employee_name as name,
       to_char(paid_dt,'YYYY') as year,
       sum(payable_amount) as amount_paid,
       employee.ssn,
       company.ein,
       company.company_name,
       employee.address as employee_address,
       employee.city as employee_city,
       employee.state as employee_state,
       employee.postalcode as employee_postalcode,
       company.address as company_address,
       company.city as company_city,
       company.state as company_state,
       company.postalcode as company_postalcode
from   payable_detail 
inner join 
      employee on (payable_detail.employee_id = employee.employee_id)
left outer join 
      company on (employee.company_id = company.company_id)
where  paid = 'Y'
group  by
       to_char(paid_dt,'YYYY'),
       employee_name,
       ssn,
       company.ein,
       company.company_name,
       employee.address,
       employee.city,
       employee.state,
       employee.postalcode,
       company.address,
       company.city,
       company.state,
       company.postalcode;
