CREATE SCHEMA retails;

===========================================================
--DDL COMMANDS
===========================================================

SET search_path TO retails;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    address_line TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(15),
    address TEXT
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    supplier_id INT REFERENCES suppliers(supplier_id),
    stock_quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending','shipped','delivered','cancelled')),
    total_amount DECIMAL(10,2)
);


CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    payment_status VARCHAR(20) CHECK (payment_status IN ('success','failed','pending'))
);


CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    address_id INT REFERENCES addresses(address_id),
    shipment_date TIMESTAMP,
    delivery_date TIMESTAMP,
    shipment_status VARCHAR(20) CHECK (shipment_status IN ('pending','shipped','delivered')),
    tracking_number VARCHAR(100)
);

==========================================================================================================
--INDEX
==========================================================================================================

CREATE INDEX customer 
ON orders(customer_id);

SELECT * FROM orders WHERE customer_id=1;

CREATE INDEX inx_order
ON order_items(order_id);

CREATE INDEX products_category 
ON products(category_id);

CREATE INDEX payments_order 
ON payments(order_id);

===========================================================================
--ALTER TABLES
===========================================================================

ALTER TABLE products
ADD COLUMN brand VARCHAR(100);

ALTER TABLE inventory
ADD CONSTRAINT check_stock 
CHECK (stock_quantity >= 0);

ALTER TABLE customers
RENAME COLUMN phone TO contact_number;

ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);



-----------------------------------------------------------------------------------------------------------------------


======================================================================
--DML COMMANDS
======================================================================



=========================================================================
--INSERTION
=========================================================================

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic items'),
('Clothing', 'Apparel and garments'),
('Books', 'Educational and reading materials');

INSERT INTO products (product_name, category_id, price, description) VALUES
('Laptop', 1, 55000, 'Gaming laptop'),
('Smartphone', 1, 20000, 'Android phone'),
('T-Shirt', 2, 500, 'Cotton T-shirt'),
('Data Science Book', 3, 800, 'ML concepts');

INSERT INTO customers (first_name, last_name, email,contact_number ) VALUES
('Prashant', 'Sahu', 'prashant@gmail.com', '9876543210'),
('Rahul', 'Sharma', 'rahul@gmail.com', '9123456780');

INSERT INTO addresses (customer_id, address_line, city, state, pincode, country) VALUES
(1, 'Karond Bhopal', 'Bhopal', 'MP', '462038', 'India'),
(2, 'Indore Road', 'Indore', 'MP', '452001', 'India');

INSERT INTO suppliers (supplier_name, contact_email, phone, address) VALUES
('ABC Suppliers', 'abc@mail.com', '9999999999', 'Delhi'),
('XYZ Traders', 'xyz@mail.com', '8888888888', 'Mumbai');

INSERT INTO inventory (product_id, supplier_id, stock_quantity) VALUES
(1, 1, 50),
(2, 1, 100),
(3, 2, 200),
(4, 2, 80);

INSERT INTO orders (customer_id, status, total_amount) VALUES
(1, 'pending', 75000),
(2, 'shipped', 500);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 55000),
(1, 2, 1, 20000),
(2, 3, 1, 500);

INSERT INTO payments (order_id, amount, payment_method, payment_status) VALUES
(1, 75000, 'UPI', 'success'),
(2, 500, 'COD', 'pending');


INSERT INTO shipments (order_id, address_id, shipment_status, tracking_number) VALUES
(1, 1, 'shipped', 'TRK12345'),
(2, 2, 'pending', 'TRK67890');


========================================================================================================
--UPDATION
========================================================================================================

UPDATE orders
SET status = 'delivered'
WHERE order_id = 1;

UPDATE inventory
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1;

DELETE FROM orders
WHERE status = 'cancelled';

=============================================================================================
--BULK INSERTION
=============================================================================================

INSERT INTO customers (first_name, last_name, email,contact_number ) VALUES
('Arjun','Mehta','arjun1@gmail.com','9000000004'),
('Karan','Patel','karan1@gmail.com','9000000005'),
('Rohit','Yadav','rohit1@gmail.com','9000000006'),
('Sanjay','Gupta','sanjay1@gmail.com','9000000007'),
('Vikas','Sharma','vikas1@gmail.com','9000000008'),
('Ankit','Jain','ankit1@gmail.com','9000000009'),
('Deepak','Verma','deepak1@gmail.com','9000000010'),
('Manish','Tiwari','manish1@gmail.com','9000000011'),
('Nitin','Chauhan','nitin1@gmail.com','9000000012'),

('Sneha','Mishra','sneha1@gmail.com','9000000014'),
('Ritu','Singh','ritu1@gmail.com','9000000015'),
('Komal','Dubey','komal1@gmail.com','9000000016'),
('Neeraj','Pandey','neeraj1@gmail.com','9000000017'),
('Harsh','Srivastava','harsh1@gmail.com','9000000018'),
('Aakash','Tripathi','aakash1@gmail.com','9000000019'),
('Priya','Saxena','priya1@gmail.com','9000000020'),
('Mohit','Bansal','mohit1@gmail.com','9000000021'),
('Rakesh','Malhotra','rakesh1@gmail.com','9000000022'),
('Alok','Sinha','alok1@gmail.com','9000000023'),

('Shivam','Raj','shivam1@gmail.com','9000000024'),
('Gaurav','Kapoor','gaurav1@gmail.com','9000000025'),
('Tarun','Joshi','tarun1@gmail.com','9000000026'),
('Abhishek','Rana','abhishek1@gmail.com','9000000027'),
('Varun','Chawla','varun1@gmail.com','9000000028'),
('Simran','Kaur','simran1@gmail.com','9000000029'),
('Isha','Arora','isha1@gmail.com','9000000030'),
('Tanya','Gill','tanya1@gmail.com','9000000031'),
('Meena','Rao','meena1@gmail.com','9000000032'),
('Nisha','Kulkarni','nisha1@gmail.com','9000000033'),

('Kunal','Deshmukh','kunal1@gmail.com','9000000034'),
('Suresh','Pillai','suresh1@gmail.com','9000000035'),
('Ramesh','Naidu','ramesh1@gmail.com','9000000036'),
('Dinesh','Shetty','dinesh1@gmail.com','9000000037'),
('Vijay','Iyer','vijay1@gmail.com','9000000038'),
('Anu','Nair','anu1@gmail.com','9000000039'),
('Bhavna','Reddy','bhavna1@gmail.com','9000000040'),
('Kriti','Chopra','kriti1@gmail.com','9000000041'),
('Zoya','Khan','zoya1@gmail.com','9000000042'),
('Farhan','Ali','farhan1@gmail.com','9000000043'),

('Imran','Shaikh','imran1@gmail.com','9000000044'),
('Yusuf','Pathan','yusuf1@gmail.com','9000000045'),
('Salman','Qureshi','salman1@gmail.com','9000000046'),
('Aftab','Ansari','aftab1@gmail.com','9000000047'),
('Rehan','Khan','rehan1@gmail.com','9000000048'),
('Naveen','Goyal','naveen1@gmail.com','9000000049'),
('Pankaj','Mittal','pankaj1@gmail.com','9000000050'),
('Sachin','Aggarwal','sachin1@gmail.com','9000000051'),
('Lokesh','Bhardwaj','lokesh1@gmail.com','9000000052'),
('Ajay','Thakur','ajay1@gmail.com','9000000053');


------------------------------------------------------------------------------------------------------------------------


==============================================================================
--DQL COMMANDS
==============================================================================

SELECT * FROM customers;

SELECT * FROM order_items
ORDER BY price DESC;

SELECT * FROM addresses 
WHERE city = 'Bhopal';

SELECT * FROM orders
WHERE status = 'delivered';

SELECT * FROM orders
ORDER BY order_date DESC;

SELECT product_name,price FROM products
ORDER BY price DESC;

SELECT SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'success';

SELECT AVG(price) AS avg_price
FROM products;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT CONCAT(c.first_name,' ',c.last_name) name, o.order_id, p.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id;

SELECT o.order_id, p.product_name, oi.quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT first_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
);

SELECT product_name, price
FROM products
WHERE price = (
    SELECT MAX(price) FROM products
);

SELECT product_id,
       SUM(quantity) AS total_sold,
       RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank
FROM order_items
GROUP BY product_id;

SELECT payment_id,
       amount,
       SUM(amount) OVER (ORDER BY payment_id) AS running_total
FROM payments;

SELECT c.customer_id, c.first_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'success'
GROUP BY c.customer_id, c.first_name
ORDER BY total_spent DESC
LIMIT 3;

SELECT p.product_name, i.stock_quantity
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.stock_quantity = 0;

SELECT o.order_id, s.shipment_status
FROM orders o
JOIN shipments s ON o.order_id = s.order_id
WHERE s.shipment_status = 'pending';



=============================================================================
--TCl COMMANDS
=============================================================================

BEGIN;

-- Step 1: Insert Order
INSERT INTO orders (customer_id, status, total_amount)
VALUES (1, 'pending', 20000);

-- Step 2: Create Savepoint
SAVEPOINT after_order;

-- Step 3: Insert Order Item
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (currval('retails.orders_order_id_seq'), 2, 1, 20000);

-- Step 4: Update Inventory
UPDATE inventory
SET stock_quantity = stock_quantity - 1
WHERE product_id = 2;

-- Step 5: Simulate Error 
INSERT INTO retails.order_items (order_id, product_id, quantity, price)
VALUES (currval('retails.orders_order_id_seq'), 999, 1, 1000);

-- If everything is fine
COMMIT;

-- If error occurs manually run:
ROLLBACK TO after_order;

-------------------------------------------------------

BEGIN;

-- Step 1: Mark order as cancelled
UPDATE orders
SET status = 'cancelled'
WHERE order_id = 2;

-- Step 2: Savepoint
SAVEPOINT after_cancel;

-- Step 3: Restore inventory (add back stock)
UPDATE inventory i
SET stock_quantity = stock_quantity + oi.quantity
FROM order_items oi
WHERE oi.order_id = 2
AND i.product_id = oi.product_id;

-- Step 4: Optional - update payment status
UPDATE retails.payments
SET payment_status = 'failed'
WHERE order_id = 2;

-- If everything is fine
COMMIT;

-- If something fails
-- ROLLBACK TO after_cancel;

---------------------------------------------------------------------------------------

========================================================
--DCL COMMANDS
========================================================


CREATE ROLE Admin;
CREATE ROLE sales_staff;
CREATE ROLE inventory_manager;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA retails TO admin; 
GRANT SELECT ON products TO sales_staff;
GRANT SELECT, INSERT ON orders TO sales_staff;
GRANT SELECT, INSERT, UPDATE ON products TO inventory_manager;
GRANT ALL PRIVILEGES ON inventory TO inventory_manager;

REVOKE INSERT ON products FROM sales_staff;


CREATE USER prashant WITH PASSWORD '12345';
CREATE USER rahul WITH PASSWORD 'abc123';
CREATE USER neha WITH PASSWORD 'xyz789';



GRANT Admin TO prashant;
GRANT sales_staff TO rahul;
GRANT inventory_manager TO neha;



ALTER ROLE prashant LOGIN;
ALTER ROLE rahul LOGIN;
ALTER ROLE neha LOGIN;


GRANT CONNECT ON DATABASE "RETAIL_MANAGEMENT" TO prashant;
GRANT CONNECT ON DATABASE "RETAIL_MANAGEMENT" TO rahul;
GRANT CONNECT ON DATABASE "RETAIL_MANAGEMENT" TO neha;


GRANT USAGE ON SCHEMA public TO prashant,rahul,neha;

