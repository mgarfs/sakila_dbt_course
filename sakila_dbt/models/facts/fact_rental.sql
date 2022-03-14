SELECT r.rental_id
      ,r.rental_date
      ,r.inventory_id
      ,r.customer_id
      ,r.return_date
      ,r.staff_id
      ,GREATEST(r.last_update,i.last_update) AS last_update
      ,i.film_id
      ,i.store_id
      ,'{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::TIMESTAMP WITH TIME ZONE AS dbt_time
 FROM  stg.rental r
       LEFT JOIN
	   stg.inventory i ON (i.inventory_id=r.inventory_id)
