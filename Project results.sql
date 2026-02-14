(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ python3 populate.py
============================================================
RUSHMORE PIZZERIA - FULL DATA POPULATION
============================================================
Connected to database successfully!

 stores locations list...
  ✓ Store in Lagos (ID: 1)
  ✓ Store in Abuja (ID: 2)
  ✓ Store in Port Harcourt (ID: 3)
  ✓ Store in Kano (ID: 4)
  ✓ Store in Ibadan (ID: 5)
 5 stores inserted!

 menu items list...
 42 menu items inserted!

 Ingredients list...
 44 ingredients inserted!

 customers list...
  ... 100 customers inserted
  ... 200 customers inserted
  ... 300 customers inserted
  ... 400 customers inserted
  ... 500 customers inserted
  ... 600 customers inserted
  ... 700 customers inserted
  ... 800 customers inserted
  ... 900 customers inserted
  ... 1000 customers inserted
  ... 1100 customers inserted
  ... 1200 customers inserted
 ✅ 1292 customers inserted!

 Orders list...
  ... 500 orders inserted
  ... 1000 orders inserted
  ... 1500 orders inserted
  ... 2000 orders inserted
  ... 2500 orders inserted
  ... 3000 orders inserted
  ... 3500 orders inserted
  ... 4000 orders inserted
  ... 4500 orders inserted
  ... 5000 orders inserted
  ... 5500 orders inserted
 5825 orders inserted!

 Order items list...
  ... 1501 order items inserted so far
  ... 2964 order items inserted so far
  ... 4439 order items inserted so far
  ... 5896 order items inserted so far
  ... 7415 order items inserted so far
  ... 8912 order items inserted so far
  ... 10444 order items inserted so far
  ... 11943 order items inserted so far
  ... 13445 order items inserted so far
  ... 14919 order items inserted so far
  ... 16395 order items inserted so far
 17380 order items inserted!

 inventory list...
 176 inventory records inserted!

 Inserting basic recipes...
✅ 115 recipe records inserted!

============================================================
🎉 DATA POPULATION COMPLETE! 🎉
============================================================
📊 Summary:
   • Stores: 5 (FIXED)
   • Menu Items: 42 (RANDOMIZED)
   • Ingredients: 44 (RANDOMIZED)
   • Customers: 1292 (RANDOMIZED)
   • Orders: 5825 (RANDOMIZED)
   • Order Items: 17380 (RANDOMIZED)
   • Inventory Records: 176 (RANDOMIZED)
   • Recipe Records: 115 (RANDOMIZED)
============================================================

 Connection to DB closed.
(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ 
(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ psql -d rushmore_db -c "
> SELECT s.city, s.address, SUM(o.total_amount) as total_revenue
> FROM stores s
> JOIN \"order\" o ON s.store_id = o.store_id
> GROUP BY s.city, s.address
> ORDER BY total_revenue DESC;
> "
     city      |          address          | total_revenue 
---------------+---------------------------+---------------
 Kano          | 026 Larry Field Suite 057 |      73207.35
 Lagos         | 18854 Robert Ford         |      72043.12
 Abuja         | 1618 Wiggins Station      |      68385.68
 Ibadan        | 775 Adams Shoals Apt. 075 |      67630.15
 Port Harcourt | 3735 Lauren Springs       |      67595.51
(5 rows)

(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ psql -d rushmore_db -c "
> SELECT c.full_name, c.email, SUM(o.total_amount) as total_spent
> FROM customer c
> JOIN \"order\" o ON c.customer_id = o.customer_id
> GROUP BY c.customer_id, c.full_name, c.email
> ORDER BY total_spent DESC
> LIMIT 10;
> "
    full_name    |            email            | total_spent 
-----------------+-----------------------------+-------------
 Emily Campbell  | cstark@example.net          |      918.90
 Nathaniel Tate  | ghaynes@example.net         |      862.45
 Kelly Buck      | stephanienorris@example.net |      856.22
 Yolanda Rivas   | shawnsalas@example.com      |      783.25
 Cheryl Leblanc  | nlamb@example.com           |      766.83
 Timothy Hill    | lutzmichael@example.net     |      728.55
 Amber Hernandez | hubervicki@example.org      |      722.34
 Kari Sellers    | ellismichelle@example.com   |      696.10
 Wanda Maldonado | robert06@example.com        |      681.26
 Kristin Perez   | oswanson@example.com        |      670.38
(10 rows)

(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ psql -d rushmore_db -c "
> SELECT mi.item_name, mi.item_category, SUM(oi.quantity) as total_quantity
> FROM menu_items mi
> JOIN order_items oi ON mi.item_id = oi.item_id
> GROUP BY mi.item_name, mi.item_category
> ORDER BY total_quantity DESC
> LIMIT 10;
> "
     item_name     | item_category | total_quantity 
-------------------+---------------+----------------
 Four Cheese Pizza | Pizza         |           2646
 BBQ Chicken Pizza | Pizza         |           2547
 Mushroom Pizza    | Pizza         |           2490
 Veggie Pizza      | Pizza         |           2486
 Margherita Pizza  | Pizza         |           2484
 Pepperoni Pizza   | Pizza         |           2482
 Hawaiian Pizza    | Pizza         |           2459
 Meat Lovers Pizza | Pizza         |           2389
 Ice Cream         | Dessert       |            857
 Caesar Salad      | Side          |            856
(10 rows)

(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ psql -d rushmore_db -c "
> SELECT AVG(total_amount) as avg_order_value
> FROM \"order\";
> "
   avg_order_value   
---------------------
 59.8904394849785408
(1 row)

(base) MacBook-Pro:CapStone_project HARRY_GUUSU$ psql -d rushmore_db -c "
> SELECT EXTRACT(HOUR FROM order_time) as hour_of_day, 
>        COUNT(*) as number_of_orders,
>        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
> FROM \"order\"
> GROUP BY hour_of_day
> ORDER BY number_of_orders DESC;
> "
 hour_of_day | number_of_orders | percentage 
-------------+------------------+------------
          18 |              263 |       4.52
           2 |              262 |       4.50
           3 |              259 |       4.45
          22 |              255 |       4.38
          19 |              254 |       4.36
          13 |              254 |       4.36
          10 |              253 |       4.34
           0 |              252 |       4.33
          12 |              251 |       4.31
          16 |              250 |       4.29
          14 |              248 |       4.26
          20 |              243 |       4.17
           4 |              242 |       4.15
          11 |              241 |       4.14
          21 |              240 |       4.12
          23 |              239 |       4.10
          17 |              238 |       4.09
           9 |              236 |       4.05
           6 |              232 |       3.98
           5 |              231 |       3.97
           1 |              229 |       3.93
          15 |              227 |       3.90
           8 |              221 |       3.79
           7 |              205 |       3.52
(24 rows)