CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,  -- Add UNIQUE constraint here
    age SMALLINT,
    birthday TIMESTAMP,
    member_number SMALLINT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    rrp DECIMAL(10, 2),
    date_bought TIMESTAMP,
    stock INT,
    category VARCHAR(255),
    supplier VARCHAR(255),
    image_url VARCHAR(255), 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TRIGGER trigger_update_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    pick_up_date TIMESTAMP,
    reservation_date TIMESTAMP,
    estimated_return_date TIMESTAMP,
    actual_return_date TIMESTAMP,
    status VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TRIGGER trigger_update_bookings_updated_at
BEFORE UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Insert example products # if you update this please also update table creation for products
INSERT INTO products (name, price, rrp, date_bought, stock, category, supplier, image_url) VALUES
('Product 1', 19.99, 24.99, '2023-01-01', 100, 'Category A', 'Supplier X', '/static/img/product1.jpg'),
('Product 2', 29.99, 34.99, '2023-02-01', 200, 'Category B', 'Supplier Y', '/static/img/product2.jpg');

-- Insert admin user
INSERT INTO users (username, password, role, name, email, age, member_number)
VALUES ('admin', '$2a$10$1qAz2wSx3eDc4rFv5tGb5t8lWGIVzOBjdqd4T.VmZv.PGKk/RjJEW', 'admin', 'Admin User', 'admin@example.com', 30, 1)
ON CONFLICT (email) DO NOTHING;

-- Note: The password for the admin user is 'adminpassword'. It's hashed using bcrypt.

-- Normal User Password: password123
-- Admin User Password: adminpassword
