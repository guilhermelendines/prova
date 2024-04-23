CREATE TABLE winemag(
cod_winemag SERIAL PRIMARY KEY,
country VARCHAR(200),
description VARCHAR,
points NUMERIC,
price NUMERIC(10,2)
);


DO $$
DECLARE
    cur_media REFCURSOR;
    tupla RECORD;
    total_price DECIMAL(10,2);
    total_count INT;
BEGIN
    OPEN cur_media FOR 
        SELECT country, SUM(price) AS total_price, COUNT(*) AS total_count FROM winemag GROUP BY country;
        
    LOOP 
        FETCH cur_media INTO tupla;
        EXIT WHEN NOT FOUND;
        
        total_price := tupla.total_price;
        total_count := tupla.total_count;
        
        RAISE NOTICE '% - %', tupla.country, total_price / total_count;
    END LOOP;
    
    CLOSE cur_media;
END;
$$;



