--Description: This file contains the SQL queries for the QAP2 project.
--Author: Nicole Sparkes
--Date: Feburary 5, 2024

--Problem 1: University Course Enrollment System

-- Create Table for Students
CREATE TABLE students (
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100),
    school_enrollment_date DATE
);

-- Create Table for Professors
CREATE TABLE professors (
	professor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50)
    department VARCHAR(100);
);

-- Create Table for Courses
CREATE TABLE courses (
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(100),
    professor_id INT REFERENCES professors(professor_id) ON DELETE CASCADE,
    course_description TEXT
);

-- Create Table for Enrollment
CREATE TABLE enrollment (
	enrollment_id SERIAL PRIMARY KEY,
	student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
	course_id INT REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Insert Data into Students Table
INSERT INTO students (student_id, first_name, last_name, email) VALUES
(2203, 'Sue', 'Martin', 'suemartin@gmail.com', '2023-09-01'),
(2209, 'Jack', 'Turner', 'jturner@gmail.com', '2022-08-15'),
(2371, 'Erica', 'Johnson', 'ericaj@gmail.com', '2021-06-10'),
(2263, 'Martina', 'Smith', 'martinasmith@gmail.com', '2023-01-20'),
(2315, 'Travis', 'Warren', 'twarren@email.com', '2023-09-01', '2024-02-01');

-- Insert Data into Courses Table
INSERT INTO courses (course_name, professor_id) VALUES
('Math 101', 103,'An introduction to mathematical principles and problem-solving.'),
('Biology 2201', 115, 'A study of biological concepts, including evolution and ecology.'),
('English 201', 129, 'Advanced English literature and writing techniques.'),
('Physics 101', 115, 'Introduction to classical mechanics, waves, and thermodynamics.'),
('Computer Science 101', 123, 'Basic programming concepts, algorithms, and data structures.'),
('History 205', 129, 'An exploration of world history from ancient civilizations to modern times.');

-- Insert Data into Professors Table
INSERT INTO professors (professor_id, first_name, last_name, department) VALUES
(115, 'Theo', 'McLachlan', 'Biology, Physics'),
(123, 'Abby', 'Singh', 'Computer Science'),
(103, 'Molly', 'Lane', 'Math'),
(129, 'Hank', 'Rockford', 'English, History');

-- Insert Data into Enrollment Table
INSERT INTO enrollment (student_id, course_id, enrollment_date) VALUES
(2203, 9, '2024-02-01'),  -- Sue enrolled in Physics 101
(2209, 6, '2024-02-02'),  -- Jack enrolled in Biology 2201
(2371, 3, '2024-02-03'),  -- Erica enrolled in Math 101
(2263, 11, '2024-02-04'), -- Martina enrolled in History 205
(2315, 10, '2024-02-05'), -- Travis enrolled in Computer Science 101
(2203, 7, '2024-02-06'),  -- Sue also enrolled in English 201
(2209, 11, '2024-02-07'); -- Jack also enrolled in History 205

-- SQL Queries for University Course Enrollment System
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Physics 101';

SELECT c.course_name, CONCAT(p.first_name, ' ', p.last_name) AS professor_name
FROM courses c
JOIN professors p ON c.professor_id = p.professor_id;

SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollment e ON c.course_id = e.course_id;

-- Update Data
UPDATE students
SET email = 'newemail@example.com'
WHERE student_id = 2203;

-- Delete Data
DELETE FROM enrollment
WHERE student_id = 2203 AND course_id = 9;  

--------------------------------------------------------------

-- Problem #2: Online Store Inventory and Orders System
-- Create Products Table
CREATE TABLE products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(200) NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	stock_quantity INT NOT NULL
);

-- Create Table Customers
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL
);

-- Create Table Orders
CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Create Table Order Items
CREATE TABLE order_items (
	order_id INT REFERENCES orders(order_id),
	product_id INT REFERENCES products(product_id),
	quantity INT NOT NULL CHECK (quantity >0),
	PRIMARY KEY (order_id, product_id)
);

-- Insert 5 products into products table
INSERT INTO products (product_id, product_name, price, stock_quantity) VALUES
(142, 'Laptop', 899.99, 50),
(182, 'Smartphone', 499.99, 100),
(173, 'Headphones', 129.99, 200),
(157, 'Tablet', 299.99, 75),
(190, 'Smartwatch', 199.99, 150);

-- Insert 4 customers into customers table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(263, 'Alanis', 'Andrews', 'alanisandrews@hotmail.com'),
(344, 'Tommy', 'Hawkins', 'thawkins@gmail.com'),
(286, 'Katie', 'James', 'katiej@hotmail.com'),
(197, 'John', 'Johnson', 'jjohnson@gmail.com');

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(2080, 263, '2024-09-20'),
(3424, 344, '2024-03-15'),
(4030, 286, '2024-10-27'),
(1027, 197, '2024-12-01');

-- Insert order items (2+ items per order)
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(2080, 142, 1),  -- Order 1: Laptop
(2080, 173, 2),  -- Order 1: Headphones
(3424, 182, 1),  -- Order 2: Smartphone
(3424, 157, 1),  -- Order 2: Tablet
(4030, 190, 3),  -- Order 3: Smartwatch
(4030, 173, 1),  -- Order 3: Headphones
(4030, 142, 2),  -- Order 4: Laptops
(1027, 182, 1),  -- Order 4: Smartphone
(1027, 157, 1),  -- Order 5: Tablet
(1027, 190, 2);  -- Order 5: Smartwatches

-- SQL Queries for Online Store Inventory and Orders System
SELECT 
    p.product_name,
    oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1027;

-- List all orders for a specific customer
SELECT 
    o.order_id,
    oi.product_id,
    p.product_name,
    oi.quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 263;

-- Update stock quantity after order
UPDATE products p
SET stock_quantity = stock_quantity - oi.quantity
FROM order_items oi
WHERE p.product_id = oi.product_id
AND oi.order_id = 4030; 

-- Delete order items for a specific order
DELETE FROM order_items WHERE order_id = 3424;
DELETE FROM orders WHERE order_id = 3424;