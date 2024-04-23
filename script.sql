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
-- 3. Identificação da descrição mais longa para os vinhos de cada país
DO $$
DECLARE
    cur_country CURSOR FOR
        SELECT DISTINCT country FROM winemag;
    country_name VARCHAR(200);
    longest_description VARCHAR;
BEGIN
    OPEN cur_country;

    FETCH NEXT FROM cur_country INTO country_name;
    WHILE FETCH_STATUS = 0 LOOP
        
        SELECT description INTO longest_description
        FROM winemag
        WHERE country = country_name
        ORDER BY LENGTH(description) DESC
        LIMIT 1;

        INSERT INTO WineCursorResults (nome_pais, descricao_mais_longa)
        VALUES (country_name, longest_description);

        FETCH NEXT FROM cur_country INTO country_name;
    END LOOP;

    CLOSE cur_country;
END;
$$;

-- 4. Visualize os resultados na tabela WineCursorResults
SELECT * FROM WineCursorResults;








