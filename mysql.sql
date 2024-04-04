CREATE TABLE `users` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(127) NOT NULL,
  `email` varchar(127) UNIQUE NOT NULL,
  `gender` enum('MALE', 'FEMALE', 'OTHER') NOT NULL,
  `password` varchar(255) NOT NULL,
  `otp` varchar(7),
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `product_categories` (
  `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `parent_category_id` INT,
  `created_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `products` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `sku` varchar(50) UNIQUE NOT NULL,
  `barcode` varchar(50) UNIQUE NOT NULL,
  `mrp` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  `product_category_id` INT,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`product_category_id`) REFERENCES `product_categories` (`id`)
);

CREATE TABLE `discounts` (
  `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `type` ENUM('PERCENT_OFF', 'AMOUNT_OFF', 'FLAT_PRICE', 'BASKET_DISCOUNT') NOT NULL,
  `value` DECIMAL(10,2) NOT NULL,
  `min_order_amount` DECIMAL(10,2) DEFAULT 0,
  `max_discount_amount` DECIMAL(10,2),
  `start_date` TIMESTAMP,
  `end_date` TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `discount_products` (
  `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `discount_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  FOREIGN KEY (`discount_id`) REFERENCES `discounts` (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
);

CREATE TABLE `orders` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
);

CREATE TABLE `order_items` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `mrp` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL,
  `final_price` decimal(10,2) NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
);

CREATE TABLE `payments` (
  `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `discount` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('CASH', 'DEBIT_CARD', 'CREDIT_CARD', 'UPI') NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
);

CREATE TABLE `return_orders` (
  `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `return_reason` TEXT,
  `status` enum('REQUESTED', 'APPROVED', 'REJECTED', 'PROCESSED') DEFAULT 'REQUESTED',
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
);

CREATE TABLE `return_order_items` (
  `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `return_order_id` int NOT NULL,
  `order_item_id` int NOT NULL,
  `quantity` INT NOT NULL,
  `final_price` DECIMAL(10,2) NOT NULL,
  `updated_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  FOREIGN KEY (`return_order_id`) REFERENCES `return_orders` (`id`),
  FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`)
);
