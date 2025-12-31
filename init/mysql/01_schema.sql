CREATE TABLE trip (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destination VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

CREATE TABLE traveler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    passport_number VARCHAR(50)
);

CREATE TABLE booking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT,
    traveler_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trip(id),
    FOREIGN KEY (traveler_id) REFERENCES traveler(id)
);

-- Insert some sample data
INSERT INTO trip (destination, start_date, end_date, price, description) VALUES 
('Osaka, Japan', '2024-05-01', '2024-05-07', 1800.00, 'Food tour in Osaka'),
('Hokkaido, Japan', '2024-12-20', '2024-12-30', 3000.00, 'Skiing in Hokkaido');

INSERT INTO traveler (name, email, phone, passport_number) VALUES
('Le Van C', 'vanc@example.com', '0912345678', 'D1234567'),
('Pham Thi D', 'thid@example.com', '0987654321', 'E9876543');

INSERT INTO booking (trip_id, traveler_id) VALUES (1, 1), (2, 2);
