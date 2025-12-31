-- Populate trip table with 1,000,000 rows
INSERT INTO trip (destination, start_date, end_date, price, description)
SELECT
    'Destination ' || i,
    CURRENT_DATE + (random() * 365)::integer,
    CURRENT_DATE + (random() * 365 + 5)::integer,
    (random() * 1000 + 100)::numeric(10, 2),
    'Description for trip ' || i || ' ' || md5(random()::text)
FROM generate_series(1, 1000000) AS i;

-- Populate traveler table with 1,000,000 rows
INSERT INTO traveler (name, email, phone, passport_number)
SELECT
    'Traveler ' || i,
    'traveler' || i || '@example.com',
    '09' || lpad((random() * 100000000)::int::text, 8, '0'),
    'P' || lpad(i::text, 8, '0')
FROM generate_series(1, 1000000) AS i;

-- Populate booking table with 2,000,000 rows
INSERT INTO booking (trip_id, traveler_id, booking_date)
SELECT
    (random() * 999999 + 1)::int,
    (random() * 999999 + 1)::int,
    CURRENT_TIMESTAMP - (random() * 365 * 24 * 60 * 60 * '1 second'::interval)
FROM generate_series(1, 2000000) AS i;
