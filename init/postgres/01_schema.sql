CREATE TABLE trip (
    id SERIAL PRIMARY KEY,
    destination VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

CREATE TABLE traveler (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    passport_number VARCHAR(50)
);

CREATE TABLE booking (
    id SERIAL PRIMARY KEY,
    trip_id INT REFERENCES trip(id),
    traveler_id INT REFERENCES traveler(id),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO trip (destination, start_date, end_date, price, description) VALUES 
('Tokyo, Japan', '2024-04-01', '2024-04-10', 2500.00, 'Cherry blossom tour in Tokyo'),
('Kyoto, Japan', '2024-11-15', '2024-11-25', 2200.00, 'Autumn leaves in Kyoto');

INSERT INTO traveler (name, email, phone, passport_number) VALUES
('Nguyen Van A', 'vana@example.com', '0901234567', 'B1234567'),
('Tran Thi B', 'thib@example.com', '0909876543', 'C9876543');

INSERT INTO booking (trip_id, traveler_id) VALUES (1, 1), (2, 2);
