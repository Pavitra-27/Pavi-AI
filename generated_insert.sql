INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5000, 100, 45, 0, 'LOCKED', TO_DATE('2025-06-24 22:25:16', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5001, 101, 84, 0, 'UNLOCKED', TO_DATE('2025-01-26 15:12:18', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5002, 102, 13, 0, 'LOCKED', TO_DATE('2025-05-08 10:35:41', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5003, 103, 15, 0, 'UNLOCKED', TO_DATE('2025-02-24 14:03:32', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5004, 104, 55, 0, 'UNLOCKED', TO_DATE('2025-03-08 15:46:01', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5005, 105, 78, 0, 'UNLOCKED', TO_DATE('2025-04-29 17:21:45', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5006, 106, 22, 0, 'LOCKED', TO_DATE('2025-05-16 04:59:10', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5007, 107, 34, 0, 'UNLOCKED', TO_DATE('2025-04-15 00:21:02', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5008, 108, 40, 0, 'UNLOCKED', TO_DATE('2025-03-30 08:54:52', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status, last_updated) VALUES (5009, 109, 48, 0, 'LOCKED', TO_DATE('2025-03-31 07:44:57', 'YYYY-MM-DD HH24:MI:SS'));

-- Orders and Order Lines --

INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES (1000, 28, TO_DATE('2025-05-11 01:33:45', 'YYYY-MM-DD HH24:MI:SS'), 'NEW', 'griffinann', TO_DATE('2025-05-11 01:33:45', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10000, 1000, 102, 2, 70.2, 140.4, TO_DATE('2025-06-01 08:43:51', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10001, 1000, 104, 4, 83.54, 334.16, TO_DATE('2025-06-06 23:31:08', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES (1001, 35, TO_DATE('2025-04-25 19:35:21', 'YYYY-MM-DD HH24:MI:SS'), 'NEW', 'cartermegan', TO_DATE('2025-04-25 19:35:21', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10002, 1001, 109, 4, 95.31, 381.24, TO_DATE('2025-07-03 04:56:37', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10003, 1001, 106, 5, 60.6, 303.0, TO_DATE('2025-05-25 09:20:15', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES (1002, 27, TO_DATE('2025-07-24 21:38:38', 'YYYY-MM-DD HH24:MI:SS'), 'NEW', 'carlos84', TO_DATE('2025-07-24 21:38:38', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10004, 1002, 106, 2, 74.53, 149.06, TO_DATE('2025-04-04 16:38:57', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10005, 1002, 103, 1, 71.75, 71.75, TO_DATE('2025-02-28 05:55:42', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES (1003, 18, TO_DATE('2025-03-01 13:15:56', 'YYYY-MM-DD HH24:MI:SS'), 'NEW', 'staffordjon', TO_DATE('2025-03-01 13:15:56', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10006, 1003, 104, 5, 28.97, 144.85, TO_DATE('2025-03-05 16:11:56', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10007, 1003, 106, 1, 16.92, 16.92, TO_DATE('2025-03-14 17:44:50', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order (order_id, customer_id, order_date, status, created_by, created_at) VALUES (1004, 33, TO_DATE('2025-02-15 22:15:33', 'YYYY-MM-DD HH24:MI:SS'), 'NEW', 'pattersonpatrick', TO_DATE('2025-02-15 22:15:33', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10008, 1004, 104, 2, 16.94, 33.88, TO_DATE('2025-05-19 02:05:46', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO wms_order_line (order_line_id, order_id, product_id, quantity, unit_price, line_total, created_at) VALUES (10009, 1004, 104, 2, 73.69, 147.38, TO_DATE('2025-03-20 01:41:52', 'YYYY-MM-DD HH24:MI:SS'));
