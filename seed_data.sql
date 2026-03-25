-- Wed n Feast – Seed Data (PostgreSQL)
-- Run AFTER schema.sql: psql -d wedandfeast -f seed_data.sql

-- Cities
INSERT INTO cities (name, image_url) VALUES
('Mumbai', '/static/images/mumbai.jpg'),
('Delhi', '/static/images/delhi.jpg'),
('Bangalore', '/static/images/bangalore.jpg'),
('Chennai', '/static/images/chennai.jpg'),
('Hyderabad', '/static/images/hyderabad.jpg')
ON CONFLICT (name) DO NOTHING;

-- Sample Users (password = "password123" bcrypt hashed, generated for demo)
INSERT INTO users (name, email, password_hash, role, phone) VALUES
('Demo User', 'user@demo.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'user', '9876543210'),
('Grand Vendor', 'vendor@demo.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'vendor', '9123456780')
ON CONFLICT (email) DO NOTHING;

-- Venues – Mumbai (city_id=1)
INSERT INTO venues (name, city_id, description, capacity, price_per_day, price_per_plate, amenities, layout_options, image1, image2, image3, rating, review_count, vendor_id, venue_type) VALUES
('The Grand Pavilion', 1, 'A luxurious banquet hall in the heart of Mumbai, perfect for grand weddings and receptions. Features crystal chandeliers and marble flooring.', 800, 250000, 1200, 'Parking,AC,Bridal Suite,Generator,WiFi,Valet', 'Banquet,Theatre,Cocktail', '/static/images/venues/The Grand Pavilion.jpg', NULL, NULL, 4.8, 124, 2, 'banquet_hall'),
('Sunset Lawns', 1, 'Beautiful open lawn venue with lush greenery, ideal for outdoor weddings. Stunning sunset views and customizable décor.', 1200, 180000, 900, 'Parking,Open Garden,Stage,Generator,Catering Kitchen', 'Garden,Amphitheatre', '/static/images/venues/Sunset Lawns.jpg', NULL, NULL, 4.6, 89, 2, 'open_lawn'),
('Royal Marine Hotel', 1, 'Premium 5-star hotel venue with world-class amenities. Multiple halls available for ceremonies, receptions, and corporate events.', 500, 350000, 1800, 'Parking,AC,Pool,Spa,Accommodation,WiFi,Bar,Valet', 'Banquet,Boardroom,Cocktail','/static/images/venues/Royal Marine Hotel.jpg', NULL, NULL, 4.9, 215, 2, 'hotel');

-- Venues – Delhi (city_id=2)
INSERT INTO venues (name, city_id, description, capacity, price_per_day, price_per_plate, amenities, layout_options, image1, image2, image3, rating, review_count, vendor_id, venue_type) VALUES
('Heritage Haveli', 2, 'Stunning heritage property in South Delhi with Mughal architecture. An unforgettable backdrop for royal weddings and events.', 600, 300000, 1500, 'Parking,AC,Heritage Décor,Stage,Generator,Garden', 'Banquet,Courtyard,Cocktail', '/static/images/venues/Heritage Haveli.jpg', NULL, NULL, 4.7, 98, 2, 'marriage_hall'),
('The Capital Greens', 2, 'Expansive green venue in Dwarka offering affordable yet elegant spaces for every budget. Popular for family functions.', 1500, 150000, 750, 'Parking,Open Garden,AC Hall,Generator,Catering Kitchen', 'Garden,Banquet', '/static/images/venues/The Capital Greens.jpg', NULL, NULL, 4.4, 67, 2, 'open_lawn'),
('Indira Palace Hotel', 2, 'Modern 4-star hotel with sophisticated event spaces. Equipped with the latest AV technology for hybrid and live events.', 700, 280000, 1600, 'Parking,AC,WiFi,Accommodation,AV System,Bar', 'Banquet,Theatre,Boardroom', '/static/images/venues/Indira Palace Hotel.jpg', NULL, NULL, 4.6, 143, 2, 'hotel');

-- Venues – Bangalore (city_id=3)
INSERT INTO venues (name, city_id, description, capacity, price_per_day, price_per_plate, amenities, layout_options,image1,image2,image3, rating, review_count, vendor_id, venue_type) VALUES
('Silicon City Greens', 3, 'A lush garden venue popular with tech-savvy Bangaloreans. Perfect for themed weddings and corporate retreats.', 900, 200000, 1100, 'Parking,Garden,AC,Generator,Stage,WiFi', 'Garden,Banquet,Cocktail', '/static/images/venues/Silicon City Greens.jpg', NULL, NULL, 4.5, 76, 2, 'open_lawn'),
('Palazzo Di Bangalore', 3, 'Italian-inspired banquet hall with grand arches and ornate interiors. One of Bangalores most sought-after wedding venues.', 650, 290000, 1400, 'Parking,AC,Bridal Suite,Valet,Bar,Generator', 'Banquet,Cocktail', '/static/images/venues/Palazzo Di Bangalore.jpg', NULL, NULL, 4.8, 132, 2, 'banquet_hall');

-- Venues – Chennai (city_id=4)
INSERT INTO venues (name, city_id, description, capacity, price_per_day, price_per_plate, amenities, layout_options, image1, image2, image3, rating, review_count, vendor_id, venue_type) VALUES
('Marina Wedding Hall', 4, 'Traditional South Indian wedding hall near Marina Beach. Specializes in Tamil Brahmin, Christian, and Muslim ceremonies.', 700, 170000, 950, 'Parking,AC,Stage,Generator,Kalyana Mandapam', 'Traditional Hall,Banquet', '/static/images/venues/Marina Wedding Hall.jpg', NULL, NULL, 4.6, 88, 2, 'marriage_hall'),
('Taj Garden Retreat Chennai', 4, 'Five-star luxury hotel with sprawling event lawns and palatial interiors. Exceptional catering and hospitality services.', 1000, 400000, 2000, 'Parking,AC,Pool,Accommodation,Spa,Bar,WiFi,Valet', 'Garden,Banquet,Boardroom', '/static/images/venues/Taj Garden Retreat Chennai.jpg', NULL, NULL, 4.9, 201, 2, 'hotel');

-- Venues – Hyderabad (city_id=5)
INSERT INTO venues (name, city_id, description, capacity, price_per_day, price_per_plate, amenities, layout_options, image1, image2, image3, rating, review_count, vendor_id, venue_type) VALUES
('Nizami Nights Lawn', 5, 'Grand outdoor venue with Hyderabadi royal décor. Famous for extravagant Muslim weddings and lavish parties.', 2000, 220000, 1000, 'Parking,Open Lawn,Stage,Generator,Catering Kitchen,Gold Décor', 'Garden,Stage,Cocktail', '/static/images/venues/Nizami Nights Lawn.jpg', NULL, NULL, 4.7, 110, 2, 'open_lawn'),
('GVK Banquet Hall', 5, 'Modern multi-purpose banquet hall in HITEC City. Ideal for corporate events, product launches, and weddings.', 550, 240000, 1300, 'Parking,AC,WiFi,AV System,Generator,Valet', 'Banquet,Theatre,Cocktail', '/static/images/venues/GVK Banquet Hall.jpg', NULL, NULL, 4.5, 92, 2, 'banquet_hall'),
('Golconda Heritage Hotel', 5, 'A heritage property at the foot of Golconda Fort. Magnificent settings for royal theme weddings.', 800, 320000, 1700, 'Parking,AC,Pool,Accommodation,Heritage Décor,Generator', 'Banquet,Courtyard,Garden', '/static/images/venues/Golconda Heritage Hotel.jpg', NULL, NULL, 4.8, 155, 2, 'hotel');

-- Catering Services – Mumbai (city_id=1)
INSERT INTO catering_services (name, city_id, description, price_per_plate_veg, price_per_plate_nonveg, cuisines, menu_snacks, menu_main_course, menu_desserts, menu_beverages, min_order_persons, rating, review_count, vendor_id) VALUES
('Maharaja Caterers', 1, 'Award-winning catering service with 25+ years of experience. Specializing in North Indian and Continental cuisines for weddings and corporate events.', 850, 1100, 'North Indian,Continental,Chinese', 'Samosa,Paneer Tikka,Spring Rolls,Bruschetta', 'Dal Makhani,Paneer Butter Masala,Biryani,Pasta Alfredo,Naan,Steamed Rice', 'Gulab Jamun,Ice Cream,Kheer,Tiramisu', 'Fresh Juices,Mocktails,Lassi,Soft Drinks', 100, 4.8, 203, 2),
('Spice Route Catering', 1, 'Pan-India catering specialists with expertise in regional cuisines. From Kerala Sadya to Rajasthani Thali — we do it all.', 700, 950, 'South Indian,Rajasthani,Bengali,Gujarati', 'Medu Vada,Dhokla,Kachori,Aloo Tikki', 'Avial,Dal Baati Churma,Rasmalai Curry,Undhiyu,Appam', 'Rasgulla,Shrikhand,Payasam,Modak', 'Coconut Water,Chaas,Rose Sharbat', 75, 4.6, 156, 2);

-- Catering Services – Delhi (city_id=2)
INSERT INTO catering_services (name, city_id, description, price_per_plate_veg, price_per_plate_nonveg, cuisines, menu_snacks, menu_main_course, menu_desserts, menu_beverages, min_order_persons, rating, review_count, vendor_id) VALUES
('Delhi Darbar Catering', 2, 'Premium Mughlai and North Indian catering. Renowned for authentic Dum Biryani, Kebabs, and royal wedding setups.', 900, 1250, 'Mughlai,North Indian,Continental', 'Seekh Kebab,Galouti Kebab,Paneer Tikka,Dahi Puri', 'Dum Biryani,Butter Chicken,Dal Tadka,Shahi Paneer,Laccha Paratha', 'Rabri,Firni,Jalebi,Kulfi Falooda', 'Thandai,Shahi Sharbat,Fresh Lime Soda', 100, 4.9, 312, 2),
('Punjab Da Dhabba Events', 2, 'Authentic Punjabi food catering for large-scale events. Famous for live tawa roti counters and fresh tandoor.', 650, 900, 'Punjabi,North Indian', 'Amritsari Kulcha,Paneer Roll,Tikki Chaat,Dal Pakora', 'Saag,Makki Roti,Rajma,Chole Bhature,Tandoori Roti', 'Gajar Halwa,Besan Ladoo,Pinni', 'Lassi,Chaas,Sugarcane Juice', 50, 4.5, 178, 2);

-- Catering Services – Bangalore (city_id=3)
INSERT INTO catering_services (name, city_id, description, price_per_plate_veg, price_per_plate_nonveg, cuisines, menu_snacks, menu_main_course, menu_desserts, menu_beverages, min_order_persons, rating, review_count, vendor_id) VALUES
('Garden City Gourmet', 3, 'Bangalore''s finest fusion caterer. Blends South Indian tradition with global flavours for an unforgettable dining experience.', 950, 1200, 'South Indian,Continental,Asian Fusion', 'Idli,Vada,Bruschetta,Thai Spring Rolls', 'Chettinad Curry,Pasta,Thai Green Curry,Pulao,Chapati', 'Mysore Pak,Panna Cotta,Gulab Jamun', 'Filter Coffee,Mocktails,Fresh Juices', 80, 4.7, 134, 2);

-- Catering Services – Chennai (city_id=4)
INSERT INTO catering_services (name, city_id, description, price_per_plate_veg, price_per_plate_nonveg, cuisines, menu_snacks, menu_main_course, menu_desserts, menu_beverages, min_order_persons, rating, review_count, vendor_id) VALUES
('Saravana Bhavan Events', 4, 'Inspired by the legendary Saravana Bhavan, our catering brings authentic Tamil cuisine to your celebrations. Traditional banana leaf setup available.', 600, 850, 'Tamil,South Indian,Chettinad', 'Sambar Vada,Masala Dosa Mini,Kuzhi Paniyaram', 'Sambar,Rasam,Kootu,Poriyal,Curd Rice,Lemon Rice,Papad', 'Payasam,Kesari,Paal Poli', 'Filter Coffee,Buttermilk,Tender Coconut', 100, 4.8, 267, 2);

-- Catering Services – Hyderabad (city_id=5)
INSERT INTO catering_services (name, city_id, description, price_per_plate_veg, price_per_plate_nonveg, cuisines, menu_snacks, menu_main_course, menu_desserts, menu_beverages, min_order_persons, rating, review_count, vendor_id) VALUES
('Hyderabadi Royal Catering', 5, 'Authentic Hyderabadi cuisine specialists. Our signature Dum Biryani and Haleem are legendary across the city.', 800, 1100, 'Hyderabadi,Mughlai,North Indian', 'Shami Kebab,Mirchi Bajji,Boti Kebab,Patthar Ka Gosht', 'Dum Biryani,Haleem,Nihari,Mirchi Ka Salan,Bagara Khana', 'Double Ka Meetha,Qubani Ka Meetha,Shahi Tukda', 'Irani Chai,Rooh Afza Sharbat,Fresh Lime', 100, 4.9, 389, 2),
('Telangana Kitchen Catering', 5, 'Traditional Telangana and Andhra cuisine for your events. Known for spicy curries, fresh flavours, and hearty portions.', 550, 800, 'Andhra,Telangana,South Indian', 'Pesarattu,Gongura Chicken Tikka,Punugulu', 'Pappu,Gongura Mutton,Gutti Vankaya,Chapala Pulusu,Rice', 'Bobbatlu,Pootharekulu,Ariselu', 'Chilled Majjiga,Fresh Coconut Water,Nannari Sharbat', 60, 4.6, 142, 2);
