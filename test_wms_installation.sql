-- WMS Installation Test Script
-- Run this as wms_user after executing the main PL/SQL script

-- Enable output for debugging
SET SERVEROUTPUT ON;

-- Test 1: Check if tables exist
PROMPT ========================================
PROMPT Test 1: Checking if tables were created
PROMPT ========================================

SELECT table_name, tablespace_name 
FROM user_tables 
WHERE table_name LIKE 'WMS_%'
ORDER BY table_name;

-- Test 2: Check if sequences exist
PROMPT ========================================
PROMPT Test 2: Checking if sequences were created
PROMPT ========================================

SELECT sequence_name, min_value, max_value, increment_by
FROM user_sequences
WHERE sequence_name LIKE 'SEQ_%'
ORDER BY sequence_name;

-- Test 3: Check if package exists
PROMPT ========================================
PROMPT Test 3: Checking if package was created
PROMPT ========================================

SELECT object_name, object_type, status
FROM user_objects 
WHERE object_name = 'PKG_ORDER_MGMT'
ORDER BY object_name;

-- Test 4: Check package procedures and functions
PROMPT ========================================
PROMPT Test 4: Checking package procedures and functions
PROMPT ========================================

SELECT procedure_name, procedure_type
FROM user_procedures 
WHERE object_name = 'PKG_ORDER_MGMT'
ORDER BY procedure_name;

-- Test 5: Insert test inventory data
PROMPT ========================================
PROMPT Test 5: Inserting test inventory data
PROMPT ========================================

INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status)
VALUES (seq_inventory_id.NEXTVAL, 101, 100, 0, 'UNLOCKED');

INSERT INTO wms_inventory (inventory_id, product_id, qty_on_hand, qty_allocated, unlocked_status)
VALUES (seq_inventory_id.NEXTVAL, 102, 50, 0, 'UNLOCKED');

COMMIT;

-- Test 6: Test order creation
PROMPT ========================================
PROMPT Test 6: Testing order creation
PROMPT ========================================

DECLARE
  v_order_id NUMBER;
BEGIN
  pkg_order_mgmt.create_order(
    p_customer_id => 123,
    p_order_lines => SYS.ODCINUMBERLIST(101, 102),
    p_quantities  => SYS.ODCINUMBERLIST(2, 3),
    p_unit_prices => SYS.ODCINUMBERLIST(10.5, 20.0),
    p_created_by  => 'admin',
    p_order_id    => v_order_id
  );
  
  DBMS_OUTPUT.PUT_LINE('SUCCESS: Order created with ID: ' || v_order_id);
  
  -- Test order total
  DBMS_OUTPUT.PUT_LINE('Order total: $' || pkg_order_mgmt.get_order_total(v_order_id));
  
  -- Test order allocation
  pkg_order_mgmt.allocate_order(v_order_id);
  DBMS_OUTPUT.PUT_LINE('Order allocation completed');
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- Test 7: Verify order data
PROMPT ========================================
PROMPT Test 7: Verifying order data
PROMPT ========================================

SELECT 
  o.order_id,
  o.customer_id,
  o.status,
  o.total_amount,
  o.created_by,
  o.created_at
FROM wms_order o
ORDER BY o.order_id DESC;

-- Test 8: Verify order line data
PROMPT ========================================
PROMPT Test 8: Verifying order line data
PROMPT ========================================

SELECT 
  ol.order_line_id,
  ol.order_id,
  ol.product_id,
  ol.quantity,
  ol.unit_price,
  ol.line_total
FROM wms_order_line ol
ORDER BY ol.order_id DESC, ol.order_line_id;

-- Test 9: Verify inventory data
PROMPT ========================================
PROMPT Test 9: Verifying inventory data
PROMPT ========================================

SELECT 
  inventory_id,
  product_id,
  qty_on_hand,
  qty_allocated,
  unlocked_status,
  last_updated
FROM wms_inventory
ORDER BY product_id;

-- Test 10: Test order status update
PROMPT ========================================
PROMPT Test 10: Testing order status update
PROMPT ========================================

DECLARE
  v_order_id NUMBER;
BEGIN
  -- Get the latest order
  SELECT MAX(order_id) INTO v_order_id FROM wms_order;
  
  -- Update status
  pkg_order_mgmt.update_order_status(v_order_id, 'PROCESSING');
  
  DBMS_OUTPUT.PUT_LINE('SUCCESS: Order ' || v_order_id || ' status updated to PROCESSING');
  
  -- Verify status
  SELECT status INTO v_order_id FROM wms_order WHERE order_id = v_order_id;
  DBMS_OUTPUT.PUT_LINE('Current status: ' || v_order_id);
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

PROMPT ========================================
PROMPT All tests completed!
PROMPT ======================================== 