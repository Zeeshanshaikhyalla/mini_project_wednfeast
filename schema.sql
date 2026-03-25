-- Wed n Feast – PostgreSQL Schema
-- Run: psql -d wedandfeast -f schema.sql

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Cities
CREATE TABLE IF NOT EXISTS cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    image_url VARCHAR(500)
);

-- Users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(300) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',   -- 'user' or 'vendor'
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Venues
CREATE TABLE IF NOT EXISTS venues (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    city_id INTEGER REFERENCES cities(id) ON DELETE SET NULL,
    description TEXT,
    capacity INTEGER,
    price_per_day NUMERIC(12,2),
    price_per_plate NUMERIC(10,2),
    amenities TEXT,           -- comma-separated e.g. "Parking,AC,Pool"
    layout_options TEXT,      -- e.g. "Banquet,Theatre,Cocktail"
    image1 VARCHAR(500),
    image2 VARCHAR(500),
    image3 VARCHAR(500),
    rating NUMERIC(3,1) DEFAULT 4.0,
    review_count INTEGER DEFAULT 0,
    vendor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    venue_type VARCHAR(50),   -- 'hotel', 'banquet_hall', 'open_lawn', 'marriage_hall'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Catering Services
CREATE TABLE IF NOT EXISTS catering_services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    city_id INTEGER REFERENCES cities(id) ON DELETE SET NULL,
    description TEXT,
    price_per_plate_veg NUMERIC(10,2),
    price_per_plate_nonveg NUMERIC(10,2),
    cuisines TEXT,            -- comma-separated e.g. "Indian,Continental,Chinese"
    menu_snacks TEXT,
    menu_main_course TEXT,
    menu_desserts TEXT,
    menu_beverages TEXT,
    min_order_persons INTEGER DEFAULT 50,
    image1 VARCHAR(500),
    image2 VARCHAR(500),
    rating NUMERIC(3,1) DEFAULT 4.0,
    review_count INTEGER DEFAULT 0,
    vendor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Bookings
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    booking_type VARCHAR(20) NOT NULL,  -- 'venue' or 'catering'
    venue_id INTEGER REFERENCES venues(id) ON DELETE SET NULL,
    catering_id INTEGER REFERENCES catering_services(id) ON DELETE SET NULL,
    event_date DATE NOT NULL,
    event_type VARCHAR(100),   -- e.g. "Wedding", "Corporate Event"
    guests INTEGER NOT NULL,
    special_requests TEXT,
    total_price NUMERIC(14,2),
    status VARCHAR(30) DEFAULT 'pending',  -- 'pending','confirmed','cancelled'
    created_at TIMESTAMP DEFAULT NOW()
);

-- Reviews
CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    venue_id INTEGER REFERENCES venues(id) ON DELETE CASCADE,
    catering_id INTEGER REFERENCES catering_services(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
