SELECT r.rental_id
      ,r.rental_date
      ,TO_CHAR(r.rental_date,'YYYYMMDD')::INTEGER AS date_dim_id
      ,r.inventory_id
      ,COALESCE(c.customer_id,-1) AS customer_id
      --,r.customer_id AS original_customer_id
      ,r.return_date
      ,COALESCE(st.staff_id,-1) AS staff_id
      --,r.staff_id AS original_staff_id
      ,GREATEST(r.last_update,i.last_update) AS last_update
      ,COALESCE(f.film_id,-1) AS film_id
      --,i.film_id AS original_inventory_film_id
      ,COALESCE(s.store_id,-1) AS store_id
      --,i.store_id AS original_inventory_store_id
      ,'{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::TIMESTAMP WITH TIME ZONE AS dbt_time
      ,CASE
         WHEN COALESCE(EXTRACT(EPOCH FROM r.return_date)-EXTRACT(EPOCH FROM r.rental_date),0)=0 THEN
           NULL
         ELSE
           ROUND(((EXTRACT(EPOCH FROM r.return_date)-EXTRACT(EPOCH FROM r.rental_date))/3600)::NUMERIC,0)
       END AS rental_hours
 FROM  {{ ref('stg_rental') }} r
       LEFT JOIN
	     {{ ref('stg_inventory') }} i ON (i.inventory_id=r.inventory_id)
       LEFT JOIN
       dwh.dim_film f ON (f.film_id=i.film_id)
       LEFT JOIN
       dwh.dim_store s ON (s.store_id=i.store_id)
       LEFT JOIN
       dwh.dim_customer c ON (c.customer_id=r.customer_id)
       LEFT JOIN
       dwh.dim_staff st ON (st.staff_id=r.staff_id)
