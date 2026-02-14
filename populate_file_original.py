# Import Statements
import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

# Initialize Faker
fake = Faker()

# Database connection
DB_HOST = "localhost"
DB_NAME = "rushmore_db"
DB_USER = "HARRY_GUUSU"
DB_PASSWORD = ""

print("=" * 60)
print("RUSHMORE PIZZERIA - FULL DATA POPULATION")
print("=" * 60)

try:
    # Connect to database
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()
    print("Connected to database successfully!")

    # =============
    # 1. STORES LIST
    # =============
    print("\n stores locations list...")
    stores = []
    cities = ["Lagos", "Abuja", "Port Harcourt", "Kano", "Ibadan"]
    for city in cities:
        address = fake.street_address()
        phone = fake.phone_number()[:20]
        cursor.execute("""
            INSERT INTO stores (address, city, phone_no) 
            VALUES (%s, %s, %s) RETURNING store_id """, 
        (address, city, phone)
        )
        
        result = cursor.fetchone()
        if result:
            store_id = result[0]
            stores.append(store_id)
            print(f"  ✓ Store in {city} (ID: {store_id})")
    conn.commit()
    print(f" {len(stores)} stores inserted!")

    # ===================
    # 2. MENU ITEMS LIST 
    # ===================
    print("\n menu items list...")
    
    pizza_names = ["Margherita", "Pepperoni", "Hawaiian", "Meat Lovers", "Veggie", 
                   "BBQ Chicken", "Four Cheese", "Mushroom", "Supreme", "Buffalo Chicken"]
    drink_names = ["Coca Cola", "Diet Coke", "Sprite", "Fanta", "Lemonade", "Iced Tea", "Water"]
    side_names = ["Garlic Bread", "Chicken Wings", "French Fries", "Onion Rings", "Caesar Salad", "Mozzarella Sticks"]
    dessert_names = ["Chocolate Cake", "Cheesecake", "Ice Cream", "Brownie", "Tiramisu"]
    
    menu_items = []
    
    # Insert pizzas (with sizes)
    for name in pizza_names[:8]:  # 8 pizzas
        for size in ["Small", "Medium", "Large"]:
            price = round(random.uniform(8.99, 18.99), 2)
            cursor.execute("""
                INSERT INTO menu_items (item_name, item_category, size, item_price) 
                VALUES (%s, %s, %s, %s) RETURNING item_id """, 
            (f"{name} Pizza", "Pizza", size, price)
            )
            result = cursor.fetchone()
            if result:
                menu_items.append(result[0])
    
    # Insert drinks
    for name in drink_names:
        price = round(random.uniform(1.99, 3.99), 2)
        cursor.execute("""
            INSERT INTO menu_items (item_name, item_category, size, item_price) 
            VALUES (%s, %s, %s, %s) RETURNING item_id """, 
        (name, "Drink", "500ml", price)
        )
        result = cursor.fetchone()
        if result:
            menu_items.append(result[0])
    
    # Insert sides
    for name in side_names:
        price = round(random.uniform(4.99, 8.99), 2)
        cursor.execute("""
            INSERT INTO menu_items (item_name, item_category, size, item_price) 
            VALUES (%s, %s, %s, %s) RETURNING item_id """, 
        (name, "Side", "N/A", price)
        )
        result = cursor.fetchone()
        if result:
            menu_items.append(result[0])
    
    # Insert desserts
    for name in dessert_names:
        price = round(random.uniform(3.99, 6.99), 2)
        cursor.execute("""
            INSERT INTO menu_items (item_name, item_category, size, item_price) 
            VALUES (%s, %s, %s, %s) RETURNING item_id """, 
        (name, "Dessert", "N/A", price)
        )
        result = cursor.fetchone()
        if result:
            menu_items.append(result[0])
    
    conn.commit()
    print(f" {len(menu_items)} menu items inserted!")

    # ===================
    # 3. INGREDIENTS LIST
    # ===================
    print("\n Ingredients list...")
    
    ingredient_list = [
        ("Pizza Dough", "units"), ("Tomato Sauce", "liters"), ("Mozzarella Cheese", "kg"),
        ("Pepperoni", "kg"), ("Mushrooms", "kg"), ("Onions", "kg"), ("Green Peppers", "kg"),
        ("Black Olives", "kg"), ("Pineapple", "kg"), ("Ham", "kg"), ("Bacon", "kg"),
        ("Chicken", "kg"), ("BBQ Sauce", "liters"), ("Alfredo Sauce", "liters"),
        ("Parmesan Cheese", "kg"), ("Cheddar Cheese", "kg"), ("Flour", "kg"), ("Yeast", "kg"),
        ("Sugar", "kg"), ("Salt", "kg"), ("Olive Oil", "liters"), ("Cornmeal", "kg"),
        ("Italian Sausage", "kg"), ("Ground Beef", "kg"), ("Anchovies", "kg"),
        ("Jalapenos", "kg"), ("Spinach", "kg"), ("Feta Cheese", "kg"), ("Ricotta Cheese", "kg"),
        ("Eggs", "units"), ("Milk", "liters"), ("Butter", "kg"), ("Garlic", "kg"),
        ("Basil", "kg"), ("Oregano", "kg"), ("Rosemary", "kg"), ("Thyme", "kg"),
        ("Red Pepper Flakes", "kg"), ("Honey", "kg"), ("Worcestershire Sauce", "liters"),
        ("Hot Sauce", "liters"), ("Balsamic Vinegar", "liters"), ("Red Wine Vinegar", "liters"),
        ("Lemons", "units"), ("Limes", "units"), ("Potatoes", "kg"), ("Breadcrumbs", "kg")
    ]
    
    ingredients = []
    num_ingredients = random.randint(40, 45)
    for name, unit in ingredient_list[:num_ingredients]:
        stock = round(random.uniform(5, 50), 2)
        cursor.execute("""
            INSERT INTO ingredients (name, stock_avail, unit) 
            VALUES (%s, %s, %s) RETURNING ingredient_id """, 
        (name, stock, unit)
        )
        result = cursor.fetchone()
        if result:
            ingredient_id = result[0]
            ingredients.append(ingredient_id)
    
    conn.commit()
    print(f" {len(ingredients)} ingredients inserted!")

    # ===================
    # 4. CUSTOMERS LIST
    # ===================
    print("\n customers list...")
    customers = []
    used_emails = set()
    max_attempts = 5 

    num_customers = random.randint(1000, 2000)
    attempts = 0

    while len(customers) < num_customers and attempts < num_customers * 3:
        attempts += 1
        
        first_name = fake.first_name()
        last_name = fake.last_name()
        full_name = f"{first_name} {last_name}"
        email = fake.email()
        phone = fake.phone_number()[:20]
        if email in used_emails:
            continue
        
        try:
            cursor.execute("""
                INSERT INTO customer (full_name, email, customer_phone) 
                VALUES (%s, %s, %s) RETURNING customer_id """, 
            (full_name, email, phone)
            )
            result = cursor.fetchone()
            if result:
                customer_id = result[0]
                customers.append(customer_id)
                used_emails.add(email)
                
            if len(customers) % 100 == 0:
                print(f"  ... {len(customers)} customers inserted")
                conn.commit()
                
        except psycopg2.errors.UniqueViolation:
            conn.rollback()
            continue

    conn.commit()
    print(f" ✅ {len(customers)} customers inserted!")

    # ==============
    # 5. ORDERS LIST
    # ==============
    print("\n Orders list...")
    orders = []
    
    num_orders = random.randint(5000, 6500)
    start_date = datetime.now() - timedelta(days=180) # 6 months History
    for i in range(num_orders):
        customer_id = random.choice(customers)
        store_id = random.choice(stores)
        
        # Random order time within recent 6 months
        random_days = random.randint(0, 180)
        random_hours = random.randint(0, 23)
        random_minutes = random.randint(0, 59)
        order_time = start_date + timedelta(days=random_days, hours=random_hours, minutes=random_minutes)
        
        cursor.execute("""
            INSERT INTO "order" (customer_id, store_id, order_time, total_amount) 
            VALUES (%s, %s, %s, %s) RETURNING order_id """, 
        (customer_id, store_id, order_time, 0)
        )
        
        result = cursor.fetchone()
        if result:
            order_id = result[0]
            orders.append(order_id)
        
        if (i + 1) % 500 == 0:
            print(f"  ... {i + 1} orders inserted")
            conn.commit()
    
    conn.commit()
    print(f" {len(orders)} orders inserted!")


    # ==================================================
    # 6. ORDER_ITEMS LIST (linking orders to menu items)
    # ==================================================
    print("\n Order items list...")
    order_items_count = 0
    
    for i, order_id in enumerate(orders):
        # Each order has 1-5 items (average ~3)
        num_items = random.choices([1,2,3,4,5], weights=[10,20,40,20,10])[0]
        order_total = 0
        
        for _ in range(num_items):
            item_id = random.choice(menu_items)
            quantity = random.randint(1, 3)
            
            # Getting prices from menu_items
            cursor.execute("SELECT item_price FROM menu_items WHERE item_id = %s", (item_id,))
            price_result = cursor.fetchone()
            if price_result:
                price = price_result[0]
                
                cursor.execute("""
                    INSERT INTO order_items (order_id, item_id, quantity, unit_price) 
                    VALUES (%s, %s, %s, %s) RETURNING order_item_id """, 
                (order_id, item_id, quantity, price)
                )
                order_total += price * quantity
                order_items_count += 1
        
        # The total order now becomes
        cursor.execute("UPDATE \"order\" SET total_amount = %s WHERE order_id = %s", 
                      (round(order_total, 2), order_id))
        
        if (i + 1) % 500 == 0:
            print(f"  ... {order_items_count} order items inserted so far")
            conn.commit()
    
    conn.commit()
    print(f" {order_items_count} order items inserted!")

    # ==================================================================
    # 7. INVENTORY LIST (This is the stock availble at a specific store)
    # ==================================================================
    print("\n inventory list...")
    inventory_count = 0
    
    for store_id in stores:
        num_ingredients_for_store = random.randint(30, 40)
        for ingredient_id in random.sample(ingredients, min(num_ingredients_for_store, len(ingredients))):
            stock = round(random.uniform(5, 100), 2)
            cursor.execute("""
                INSERT INTO inventory (store_id, ingredient_id, stock_avail) 
                VALUES (%s, %s, %s) RETURNING inventory_id """, 
            (store_id, ingredient_id, stock)
            )
            result = cursor.fetchone()
            if result:
                inventory_count += 1
    
    conn.commit()
    print(f" {inventory_count} inventory records inserted!")

    # ==================================================
    # 8. RECIPES LIST (linking menu_items to ingredients)
    # ==================================================
    print("\n Inserting basic recipes...")
    recipe_count = 0
    
    num_menu_items_for_recipe = random.randint(15, 25)
    for item_id in random.sample(menu_items, min(num_menu_items_for_recipe, len(menu_items))):
        num_ingredients_for_recipe = random.randint(3, 8)
        for ingredient_id in random.sample(ingredients, min(num_ingredients_for_recipe, len(ingredients))):
            quantity = round(random.uniform(0.1, 2.0), 2)
            unit = "kg"
            cursor.execute("""
                INSERT INTO recipe (item_id, ingredient_id, quantity_needed, unit) 
                VALUES (%s, %s, %s, %s) RETURNING recipe_id """, 
            (item_id, ingredient_id, quantity, unit)
            )
            result = cursor.fetchone()
            if result:
                recipe_count += 1
    
    conn.commit()
    print(f"✅ {recipe_count} recipe records inserted!")

    # ===========================================
    # OUTPUT SUMMARY
    # ===========================================
    print("\n" + "=" * 60)
    print("🎉 DATA POPULATION COMPLETE! 🎉")
    print("=" * 60)
    print(f"📊 Summary:")
    print(f"   • Stores: {len(stores)} (FIXED)")
    print(f"   • Menu Items: {len(menu_items)} (RANDOMIZED)")
    print(f"   • Ingredients: {len(ingredients)} (RANDOMIZED)")
    print(f"   • Customers: {len(customers)} (RANDOMIZED)")
    print(f"   • Orders: {len(orders)} (RANDOMIZED)")
    print(f"   • Order Items: {order_items_count} (RANDOMIZED)")
    print(f"   • Inventory Records: {inventory_count} (RANDOMIZED)")
    print(f"   • Recipe Records: {recipe_count} (RANDOMIZED)")
    print("=" * 60)

    # Ending the connection
    cursor.close()
    conn.close()
    print("\n Connection to DB closed.")

except Exception as e:
    print(f"\n Error: {e}")
    if 'conn' in locals():
        conn.rollback()
    print(" Transaction rolled back.")