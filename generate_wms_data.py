from faker import Faker
import random
from datetime import datetime

fake = Faker()

# Configuration
NUM_ORDERS = 5
NUM_PRODUCTS = 10
NUM_INVENTORY = NUM_PRODUCTS
ORDER_LINES_PER_ORDER = 2

# Generate Inventory Data
inventory = []
for i in range(NUM_INVENTORY):
    inventory_id = 5000 + i
    product_id = 100 + i
    qty_on_hand = random.randint(1, 100)
    qty_allocated = 0
    unlocked_status = random.choice(['UNLOCKED', 'LOCKED'])
    last_updated = fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
    inventory.append((inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated))
    print(f"INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES ({inventory_id}, {product_id}, {qty_on_hand}, {qty_allocated}, '{unlocked_status}', TO_DATE('{last_updated}', 'YYYY-MM-DD HH24:MI:SS'));")

print("\n-- Orders and Order Lines --\n")

# Generate Orders and Order Lines
order_id_seq = 1000
order_line_id_seq = 10000
for o in range(NUM_ORDERS):
    order_id = order_id_seq + o
    customer_id = fake.random_int(min=1, max=50)
    order_date = fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
    status = 'NEW'
    created_by = fake.user_name()
    created_at = order_date
    print(f"INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES ({order_id}, {customer_id}, TO_DATE('{order_date}', 'YYYY-MM-DD HH24:MI:SS'), '{status}', '{created_by}', TO_DATE('{created_at}', 'YYYY-MM-DD HH24:MI:SS'));")
    
    # Order Lines
    for l in range(ORDER_LINES_PER_ORDER):
        order_line_id = order_line_id_seq
        order_line_id_seq += 1
        product = random.choice(inventory)
        product_id = product[1]
        quantity = random.randint(1, 5)
        unit_price = round(random.uniform(10, 100), 2)
        line_total = round(quantity * unit_price, 2)
        created_at_line = fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
        print(f"INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES ({order_line_id}, {order_id}, {product_id}, {quantity}, {unit_price}, {line_total}, TO_DATE('{created_at_line}', 'YYYY-MM-DD HH24:MI:SS'));") 