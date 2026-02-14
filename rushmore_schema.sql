-- Drop tables for clean setup)--
DROP TABLE IF EXISTS recipe CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS ingredients CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS stores CASCADE;

-- ===================================
-- SCHEMA TABLES FOR RUSHMORE PROJECT
-- ===================================
-- STORE TABLES
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    phone_no VARCHAR(20) UNIQUE NOT NULL
);
COMMENT ON TABLE stores IS 'Physical store locations of RushMore Pizzeria';
COMMENT ON COLUMN stores.store_id IS 'Unique identifier for each store';
COMMENT ON COLUMN stores.address IS 'Street address of the store';
COMMENT ON COLUMN stores.city IS 'City where the store is located';
COMMENT ON COLUMN stores.reg_time IS 'Timestamp when the store was registered in the system';
COMMENT ON COLUMN stores.phone_no IS 'Contact phone number for the store';

-- MENU ITEMS TABLE
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL,
    item_category VARCHAR(50) NOT NULL CHECK (item_category IN ('Pizza', 'Drink', 'Side', 'Dessert', 'Appetizer')),
    size VARCHAR(20),
    item_price NUMERIC(6,2) NOT NULL CHECK (item_price > 0),
    UNIQUE (item_name, size)
);
COMMENT ON TABLE menu_items IS 'Menu items available in RushMore Pizzeria';
COMMENT ON COLUMN menu_items.item_id IS 'Unique identifier for each menu item';
COMMENT ON COLUMN menu_items.item_name IS 'Name of the menu item';
COMMENT ON COLUMN menu_items.item_category IS 'Category of the menu item (Pizza, Drink, Side, Dessert, Appetizer)';
COMMENT ON COLUMN menu_items.size IS 'Size of the menu item (e.g., Small, Medium, Large)';
COMMENT ON COLUMN menu_items.item_price IS 'Price of the menu item';

-- INGREDIENTS TABLE
CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    stock_avail NUMERIC(10,2) DEFAULT 0 CHECK (stock_avail >= 0),
    unit VARCHAR(20) NOT NULL
);
COMMENT ON TABLE ingredients IS 'Raw materials used to prepare menu items';
COMMENT ON COLUMN ingredients.ingredient_id IS 'Unique identifier for each ingredient';
COMMENT ON COLUMN ingredients.name IS 'Name of the ingredient';
COMMENT ON COLUMN ingredients.stock_avail IS 'Global available stock quantity (optional, see store-specific inventory)';
COMMENT ON COLUMN ingredients.unit IS 'Unit of measurement (kg, grams, liters, units, etc.)';

-- CUSTOMER TABLE
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    customer_phone VARCHAR(20) UNIQUE NOT NULL,
    reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE customer IS 'Registered customers with PII (Personally Identifiable Information)';
COMMENT ON COLUMN customer.customer_id IS 'Unique identifier for each customer';
COMMENT ON COLUMN customer.full_name IS 'Full name of the customer';
COMMENT ON COLUMN customer.email IS 'Unique email address for login and receipts';
COMMENT ON COLUMN customer.customer_phone IS 'Unique phone number for order updates';
COMMENT ON COLUMN customer.reg_time IS 'Timestamp when the customer registered';

-- INVENTORY TABLE
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    store_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    stock_avail NUMERIC(10,2) DEFAULT 0 CHECK (stock_avail >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (store_id, ingredient_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id) ON DELETE CASCADE
);
COMMENT ON TABLE inventory IS 'Inventory levels of ingredients at each store';
COMMENT ON COLUMN inventory.inventory_id IS 'Unique identifier for each inventory record';
COMMENT ON COLUMN inventory.store_id IS 'Foreign key referencing the store';
COMMENT ON COLUMN inventory.ingredient_id IS 'Foreign key referencing the ingredient';
COMMENT ON COLUMN inventory.stock_avail IS 'Available stock quantity of the ingredient at the store';
COMMENT ON COLUMN inventory.last_updated IS 'Timestamp of the last inventory update';

-- ORDER TABLE
CREATE TABLE "order" (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    store_id INTEGER NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE RESTRICT
);

COMMENT ON TABLE "order" IS 'Master transaction table for all customer orders';
COMMENT ON COLUMN "order".order_id IS 'Unique identifier for each order';
COMMENT ON COLUMN "order".customer_id IS 'Reference to the customer who placed the order';
COMMENT ON COLUMN "order".store_id IS 'Reference to the store where the order was placed';
COMMENT ON COLUMN "order".order_time IS 'Timestamp when the order was placed';
COMMENT ON COLUMN "order".total_amount IS 'Total amount of the order including taxes';

-- ORDER_ITEMS TABLES: ie. individual items within each order
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(6,2) NOT NULL,  -- Price at time of order (historical record)
    FOREIGN KEY (order_id) REFERENCES "order"(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE RESTRICT
);

COMMENT ON TABLE order_items IS 'Individual items within each order';
COMMENT ON COLUMN order_items.order_item_id IS 'Unique identifier for each order item';
COMMENT ON COLUMN order_items.order_id IS 'Reference to the parent order';
COMMENT ON COLUMN order_items.item_id IS 'Reference to the menu item';
COMMENT ON COLUMN order_items.quantity IS 'Quantity of this item in the order';
COMMENT ON COLUMN order_items.unit_price IS 'Price of the item at time of order';

CREATE TABLE recipe (
    recipe_id SERIAL PRIMARY KEY,
    item_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity_needed NUMERIC(8,3) NOT NULL CHECK (quantity_needed > 0),
    unit VARCHAR(20) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id) ON DELETE CASCADE,
    UNIQUE (item_id, ingredient_id)
);
COMMENT ON TABLE recipe IS 'Recipes defining which ingredients go into each menu item';
COMMENT ON COLUMN recipe.recipe_id IS 'Unique identifier for each recipe record';
COMMENT ON COLUMN recipe.item_id IS 'Reference to the menu item';
COMMENT ON COLUMN recipe.ingredient_id IS 'Reference to the ingredient';
COMMENT ON COLUMN recipe.quantity_needed IS 'Quantity of this ingredient needed for the menu item';
COMMENT ON COLUMN recipe.unit IS 'Unit of measurement for the quantity needed';

-- STORES INDEX
CREATE INDEX idx_stores_city ON stores(city);
CREATE INDEX idx_stores_reg_time ON stores(reg_time);

-- MENU ITEMS INDEX
CREATE INDEX idx_menu_items_category ON menu_items(item_category);
CREATE INDEX idx_menu_items_price ON menu_items(item_price);

-- INGREDIENTS INDEX
CREATE INDEX idx_ingredients_name ON ingredients(name);

-- CUSTOMER INDEXES
CREATE INDEX idx_customer_email ON customer(email);
CREATE INDEX idx_customer_phone ON customer(customer_phone);
CREATE INDEX idx_customer_reg_time ON customer(reg_time);
CREATE INDEX idx_customer_name ON customer(full_name);

-- ORDER INDEX
CREATE INDEX idx_order_customer_id ON "order"(customer_id);
CREATE INDEX idx_order_store_id ON "order"(store_id);
CREATE INDEX idx_order_order_time ON "order"(order_time);
CREATE INDEX idx_order_total_amount ON "order"(total_amount);

-- ORDER ITEMS INDEXES
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_item_id ON order_items(item_id);
CREATE INDEX idx_order_items_quantity ON order_items(quantity);

-- INVENTORY INDEXES
CREATE INDEX idx_inventory_store_id ON inventory(store_id);
CREATE INDEX idx_inventory_ingredient_id ON inventory(ingredient_id);
CREATE INDEX idx_inventory_stock_avail ON inventory(stock_avail);
CREATE INDEX idx_inventory_last_updated ON inventory(last_updated);

-- RECIPE INDEXES
CREATE INDEX idx_recipe_item_id ON recipe(item_id);
CREATE INDEX idx_recipe_ingredient_id ON recipe(ingredient_id);
