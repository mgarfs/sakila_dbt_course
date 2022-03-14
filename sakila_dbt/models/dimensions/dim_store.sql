{{ config(post_hook='INSERT INTO {{this}}(store_id) VALUES(-1)') }}

SELECT store.* FROM stg.store