{{ config(post_hook='INSERT INTO {{this}}(staff_id) VALUES(-1)') }}

SELECT s.staff_id ,
    s.first_name,
    s.last_name,
    s.address_id,
    s.email,
    s.store_id ,
    s.active,
    s.username,
    s.last_update
	FROM stg.staff s