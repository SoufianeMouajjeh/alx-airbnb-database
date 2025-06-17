--- SQL script to create the database schema for Airbnb clone project

CREATE TABLE `users` (
  `user_id` uuid PRIMARY KEY,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `email` varchar(255) UNIQUE,
  `password_hash` varchar(255),
  `phone_number` varchar(255),
  `role` enum(admin,host,guest),
  `created_at` timestamp DEFAULT 'CURRENT_TIMESTAMP'
);

CREATE TABLE `properties` (
  `property_id` uuid PRIMARY KEY,
  `host_id` uuid,
  `name` varchar(255),
  `description` text,
  `location` varchar(255),
  `pricepernight` decimal,
  `created_at` timestamp DEFAULT 'CURRENT_TIMESTAMP',
  `updated_at` timestamp DEFAULT 'CURRENT_TIMESTAMP' COMMENT 'ON UPDATE CURRENT_TIMESTAMP'
);

CREATE TABLE `bookings` (
  `booking_id` uuid PRIMARY KEY,
  `property_id` uuid,
  `user_id` uuid,
  `start_date` date,
  `end_date` date,
  `total_price` decimal,
  `status` enum(pending,confirmed,canceled),
  `created_at` timestamp DEFAULT 'CURRENT_TIMESTAMP'
);

CREATE TABLE `payments` (
  `payment_id` uuid PRIMARY KEY,
  `booking_id` uuid,
  `amount` decimal,
  `payment_date` timestamp DEFAULT 'CURRENT_TIMESTAMP',
  `payment_method` enum(credit_card,paypal,stripe)
);

CREATE TABLE `reviews` (
  `review_id` uuid PRIMARY KEY,
  `property_id` uuid,
  `user_id` uuid,
  `rating` int COMMENT '1 <= rating <= 5',
  `comment` text,
  `created_at` timestamp DEFAULT 'CURRENT_TIMESTAMP'
);

CREATE TABLE `messages` (
  `message_id` uuid PRIMARY KEY,
  `sender_id` uuid,
  `recipient_id` uuid,
  `message_body` text,
  `sent_at` timestamp DEFAULT 'CURRENT_TIMESTAMP'
);

ALTER TABLE `properties` ADD FOREIGN KEY (`host_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `bookings` ADD FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

ALTER TABLE `bookings` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `payments` ADD FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);


ALTER TABLE `messages` ADD FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`recipient_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `reviews` ADD CONSTRAINT `chk_rating` CHECK (`rating` BETWEEN 1 AND 5);