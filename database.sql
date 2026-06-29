CREATE DATABASE IF NOT EXISTS analytics_db;
USE analytics_db;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    revenue DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS logins (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    login_date DATE
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO orders (customer_id, order_date, revenue) VALUES
(101, '2026-01-01', 150.00),
(101, '2026-01-02', 200.00),
(101, '2026-01-03', 100.00), 
(102, '2026-01-01', 500.00), 
(102, '2026-01-05', 600.00),
(103, '2026-01-02', 50.00),
(104, '2026-01-03', 80.00),
(105, '2026-01-05', 120.00);

INSERT INTO logins (user_id, login_date) VALUES
(1, '2026-01-01'), 
(1, '2026-01-15'),
(1, '2026-01-31'), 
(2, '2026-01-01'), 
(2, '2026-01-10'),
(3, '2026-02-15'),
(3, '2026-03-17'); 


INSERT INTO employees (employee_id, department, salary) VALUES
(1, 'IT', 9000.00), 
(2, 'IT', 8500.00),  
(3, 'IT', 6000.00),
(4, 'IT', 5000.00),
(5, 'Sales', 7000.00),
(6, 'Sales', 4000.00),
(7, 'Sales', 3000.00);