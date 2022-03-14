SELECT customer.*,
       customer.first_name||' '||customer.last_name AS full_name,
	   SUBSTR(customer.email,POSITION('@' IN customer.email)+1) AS domain,
       address.address,
       city.city,
       country.country,
      (CASE WHEN customer.active=0 THEN 'no' ELSE 'yes' END)::VARCHAR(100) AS active_description,
      '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::TIMESTAMP WITH TIME ZONE AS dbt_time
 FROM  stg.customer customer
       LEFT JOIN
       stg.address ON (address.address_id=customer.address_id)
       LEFT JOIN
       stg.city ON (city.city_id=address.city_id)
       LEFT JOIN
       stg.country ON (country.country_id=city.country_id)