CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_date DATE,
    language_id INT NOT NULL,
    publisher_id INT NOT NULL
);
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    bio TEXT
);
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255)
);
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE address_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);
CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL UNIQUE,
    cost DECIMAL(10,2) NOT NULL
);
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    shipping_method_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id)
);
CREATE TABLE order_line (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);
CREATE ROLE 'admin', 'staff', 'customer_support';

GRANT ALL PRIVILEGES ON bookstore.* TO 'admin';

GRANT SELECT, INSERT, UPDATE ON bookstoredb.cust_order TO 'staff';
GRANT SELECT, INSERT, UPDATE ON bookstoredb.order_line TO 'staff';
GRANT SELECT, INSERT, UPDATE ON bookstoredb.order_history TO 'staff';
GRANT SELECT ON bookstoredb.shipping_method TO 'staff';
GRANT SELECT ON bookstoredb.order_status TO 'staff';

GRANT SELECT ON bookstoredb.customer TO 'customer_support';
GRANT SELECT ON bookstoredb.customer_address TO 'customer_support';
GRANT SELECT ON bookstoredb.address TO 'customer_support';
GRANT SELECT ON bookstoredb.country TO 'customer_support';

CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT 'admin' TO 'bookstore_admin'@'localhost';

CREATE USER 'order_staff'@'localhost' IDENTIFIED BY 'staff_pass';
GRANT 'staff' TO 'order_staff'@'localhost';

CREATE USER 'support_team'@'localhost' IDENTIFIED BY 'support_pass';
GRANT 'customer_support' TO 'support_team'@'localhost';

