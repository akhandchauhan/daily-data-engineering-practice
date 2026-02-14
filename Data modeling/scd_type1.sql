-- Setup
DROP TABLE IF EXISTS product_stg;
DROP TABLE IF EXISTS product_dim;

CREATE TABLE product_stg (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(9,2)
);

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(9,2),
    last_update DATE
);

-- Step 1 -> Initial Load

INSERT INTO product_stg VALUES
(1,'iphone13',40000),
(2,'iphone14',70000);

SET @today = '2024-10-01';


-- Step 2 - Update Existing Records

UPDATE product_dim d
JOIN product_stg s
    ON d.product_id = s.product_id
SET 
    d.product_name = s.product_name,
    d.price = s.price,
    d.last_update = @today
WHERE 
    d.product_name <> s.product_name
    OR d.price <> s.price;

-- show changes

SELECT * FROM product_dim;


-- step 3 -> Insert New Records

INSERT INTO product_dim (product_id, product_name, price, last_update)
SELECT 
    s.product_id,
    s.product_name,
    s.price,
    @today
FROM product_stg s
LEFT JOIN product_dim d
    ON s.product_id = d.product_id
WHERE d.product_id IS NULL;
