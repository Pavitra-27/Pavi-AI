-- 1. Create Order Table
CREATE TABLE wms_order (
    order_id         NUMBER PRIMARY KEY,
    customer_id      NUMBER NOT NULL,
    order_date       DATE DEFAULT SYSDATE,
    status           VARCHAR2(20) DEFAULT 'NEW',
    total_amount     NUMBER(10,2),
    created_by       VARCHAR2(50),
    created_at       DATE DEFAULT SYSDATE
);

-- 2. Create Order Line Table
CREATE TABLE wms_order_line (
    order_line_id    NUMBER PRIMARY KEY,
    order_id         NUMBER REFERENCES wms_order(order_id),
    product_id       NUMBER NOT NULL,
    quantity         NUMBER(10,2) NOT NULL,
    unit_price       NUMBER(10,2) NOT NULL,
    line_total       NUMBER(10,2),
    created_at       DATE DEFAULT SYSDATE
);

-- 3. Create Sequences
CREATE SEQUENCE seq_order_id START WITH 1000 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_order_line_id START WITH 10000 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 2a. Create Inventory Table
CREATE TABLE wms_inventory (
    inventory_id     NUMBER PRIMARY KEY,
    product_id       NUMBER NOT NULL,
    qty_on_hand      NUMBER(10,2) NOT NULL,
    qty_allocated    NUMBER(10,2) DEFAULT 0,
    unlocked_status  VARCHAR2(20) DEFAULT 'UNLOCKED',
    last_updated     DATE DEFAULT SYSDATE
);

CREATE SEQUENCE seq_inventory_id START WITH 5000 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 4. Create PL/SQL Package Specification
CREATE OR REPLACE PACKAGE pkg_order_mgmt AS
    -- Procedure to create a new order
    PROCEDURE create_order(
        p_customer_id   IN NUMBER,
        p_order_lines   IN SYS.ODCINUMBERLIST, -- List of product IDs
        p_quantities    IN SYS.ODCINUMBERLIST, -- List of quantities
        p_unit_prices   IN SYS.ODCINUMBERLIST, -- List of unit prices
        p_created_by    IN VARCHAR2,
        p_order_id      OUT NUMBER
    );

    -- Procedure to update order status
    PROCEDURE update_order_status(
        p_order_id      IN NUMBER,
        p_status        IN VARCHAR2
    );

    -- Function to get order total
    FUNCTION get_order_total(
        p_order_id      IN NUMBER
    ) RETURN NUMBER;

    -- Procedure to allocate order if inventory conditions are met
    PROCEDURE allocate_order(p_order_id IN NUMBER);
END pkg_order_mgmt;
/

-- 5. Create PL/SQL Package Body
CREATE OR REPLACE PACKAGE BODY pkg_order_mgmt AS

    PROCEDURE create_order(
        p_customer_id   IN NUMBER,
        p_order_lines   IN SYS.ODCINUMBERLIST,
        p_quantities    IN SYS.ODCINUMBERLIST,
        p_unit_prices   IN SYS.ODCINUMBERLIST,
        p_created_by    IN VARCHAR2,
        p_order_id      OUT NUMBER
    ) IS
        v_order_id      NUMBER;
        v_total         NUMBER := 0;
    BEGIN
        v_order_id := seq_order_id.NEXTVAL;
        p_order_id := v_order_id;

        -- Insert into order table
        INSERT INTO wms_order(order_id, customer_id, status, created_by)
        VALUES (v_order_id, p_customer_id, 'NEW', p_created_by);

        -- Insert order lines
        FOR i IN 1 .. p_order_lines.COUNT LOOP
            INSERT INTO wms_order_line(
                order_line_id, order_id, product_id, quantity, unit_price, line_total
            ) VALUES (
                seq_order_line_id.NEXTVAL,
                v_order_id,
                p_order_lines(i),
                p_quantities(i),
                p_unit_prices(i),
                p_quantities(i) * p_unit_prices(i)
            );
            v_total := v_total + (p_quantities(i) * p_unit_prices(i));
        END LOOP;

        -- Update order total
        UPDATE wms_order SET total_amount = v_total WHERE order_id = v_order_id;
    END create_order;

    PROCEDURE update_order_status(
        p_order_id      IN NUMBER,
        p_status        IN VARCHAR2
    ) IS
    BEGIN
        UPDATE wms_order SET status = p_status WHERE order_id = p_order_id;
    END update_order_status;

    FUNCTION get_order_total(
        p_order_id      IN NUMBER
    ) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT total_amount INTO v_total FROM wms_order WHERE order_id = p_order_id;
        RETURN v_total;
    END get_order_total;

    PROCEDURE allocate_order(p_order_id IN NUMBER) IS
        v_count NUMBER;
        v_total_lines NUMBER;
    BEGIN
        -- Count order lines that meet inventory conditions
        SELECT COUNT(*) INTO v_count
        FROM wms_order_line ol
        JOIN wms_inventory inv ON ol.product_id = inv.product_id
        WHERE ol.order_id = p_order_id
          AND inv.qty_on_hand <> 0
          AND inv.qty_allocated = 0
          AND inv.unlocked_status <> 'LOCKED';

        -- Count total order lines
        SELECT COUNT(*) INTO v_total_lines FROM wms_order_line WHERE order_id = p_order_id;

        -- If all order lines meet the inventory conditions, allocate the order
        IF v_count = v_total_lines THEN
            UPDATE wms_order SET status = 'ALLOCATE' WHERE order_id = p_order_id;
        END IF;
    END allocate_order;

END pkg_order_mgmt;
/

-- 6. Grant permissions (optional, for app user)
-- GRANT EXECUTE ON pkg_order_mgmt TO your_app_user;

-- 7. Example usage:
-- DECLARE
--   v_order_id NUMBER;
-- BEGIN
--   pkg_order_mgmt.create_order(
--     p_customer_id => 123,
--     p_order_lines => SYS.ODCINUMBERLIST(101, 102),
--     p_quantities  => SYS.ODCINUMBERLIST(2, 3),
--     p_unit_prices => SYS.ODCINUMBERLIST(10.5, 20.0),
--     p_created_by  => 'admin',
--     p_order_id    => v_order_id
--   );
--   DBMS_OUTPUT.PUT_LINE('Order ID: ' || v_order_id);
-- END;
-- /
