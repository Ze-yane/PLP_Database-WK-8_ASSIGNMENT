CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

/* creating customers table*/
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* creating categories table */
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

/* creating suppliers table*/
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    address TEXT
);

/* creating products table */
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category_id INT,
    supplier_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

/* creating inventory table */
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

/* creating orders table */
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('Pending','Processing','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* creating orders items table */
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* Creating payments table */
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('Credit Card','PayPal','Bank Transfer','Cash') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* creating shipments table */
CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    shipment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    carrier VARCHAR(100),
    tracking_number VARCHAR(100) UNIQUE,
    status ENUM('Pending','In Transit','Delivered','Returned') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* creating reviews table */
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* inserting data */
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Zain', 'Malik', 'zain.malik@example.com', '1234567890'),
('Femi', 'Shade', 'femi.shade@example.com', '0987654321'),
('Usain', 'Ayo', 'usain.ayo@example.com', '1122334455');

INSERT INTO categories (category_name, description) VALUES
('Skincare', 'Products for facial and body skin care'),
('Haircare', 'Products for hair treatment and styling'),
('Fragrance', 'Perfumes, body sprays, and scents');

INSERT INTO suppliers (supplier_name, contact_name, phone, email, address) VALUES
('GlowBeauty Ltd', 'Alice Johnson', '5551234567', 'alice@glowbeauty.com', '123 Beauty Street, City A'),
('HairEssence Co', 'David Lee', '5559876543', 'david@hairessence.com', '456 Style Ave, City B'),
('AromaWorld', 'Emma Davis', '5556789012', 'emma@aromaworld.com', '789 Fragrance Rd, City C');

INSERT INTO products (product_name, description, price, stock, category_id, supplier_id) VALUES
('Moisturizing Cream', 'Hydrating facial and body cream', 25.00, 40, 1, 1),
('Sunscreen Lotion', 'SPF 50+ sun protection cream', 18.00, 60, 1, 1),
('Shampoo', 'Anti-dandruff herbal shampoo', 12.00, 80, 2, 2),
('Hair Conditioner', 'Moisturizing conditioner for smooth hair', 15.00, 50, 2, 2),
('Perfume Spray', 'Long-lasting fragrance spray', 45.00, 30, 3, 3);

-- Insert inventory records (tracking stock separately)
INSERT INTO inventory (product_id, quantity) VALUES
(1, 40),   -- Moisturizing Cream
(2, 60),   -- Sunscreen Lotion
(3, 80),   -- Shampoo
(4, 50),   -- Hair Conditioner
(5, 30);   -- Perfume Spray

INSERT INTO orders (customer_id, total, status) VALUES
(1, 43.00, 'Pending'),
(2, 60.00, 'Processing'),
(3, 45.00, 'Shipped');

-- Insert order items (products linked to orders)
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 25.00),   -- 1 Moisturizing Cream
(1, 3, 1, 12.00),   -- 1 Shampoo
(1, 2, 1, 6.00),    -- Half-bottle Sunscreen sample
(2, 4, 4, 15.00),   -- 4 Hair Conditioners
(3, 5, 1, 45.00);   -- 1 Perfume Spray

INSERT INTO payments (order_id, amount, method) VALUES
(1, 43.00, 'Credit Card'),
(2, 60.00, 'PayPal'),
(3, 45.00, 'Cash');

-- Insert shipments
INSERT INTO shipments (order_id, carrier, tracking_number, status) VALUES
(1, 'DHL', 'TRACKCOSM123', 'In Transit'),
(2, 'FedEx', 'TRACKCOSM456', 'Pending'),
(3, 'UPS', 'TRACKCOSM789', 'Delivered');

-- Insert sample reviews
INSERT INTO reviews (customer_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Amazing cream! My skin feels so soft after using it.'),
(2, 2, 4, 'Good sunscreen, not greasy, but a bit pricey.'),
(3, 3, 5, 'The best shampoo I have ever used, smells great too!'),
(1, 4, 3, 'Conditioner is okay, but I expected better results.'),
(2, 5, 5, 'Love this perfume! Long-lasting and refreshing.');


