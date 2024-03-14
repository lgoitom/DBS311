--******************************************************************
-- Group 06
-- Student1 Name: Luwam Goitom-Worre Student1 ID: 156652224
-- Student2 Name: Chidera Osondu Student2 ID: 174098210
-- Student3 Name: Brandon Davis Student3 ID: 123539223
-- Date: November 30th, 2023
-- Purpose: Assignment 2 - DBS311
--******************************************************************


--find customer
CREATE OR REPLACE PROCEDURE find_customer(customer_id IN NUMBER, found OUT NUMBER) AS
    v_count NUMBER(32);
BEGIN
    -- Initialize found variable
    found := 0;

    -- Check if the customer exists in the database
    SELECT COUNT(*)
    INTO v_count
    FROM customers
    WHERE customer_id = find_customer.customer_id;

    -- Set the found variable based on whether the customer exists or not
    IF v_count >= 1 THEN
        found := 1; -- Customer exists (single or multiple rows found)
    ELSE
        found := 0; -- Customer does not exist
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Customer does not exist
        found := 0;
    WHEN OTHERS THEN
        -- Handle any other exceptions
        found := 0;
        -- Optionally, log or handle the error here
END;

--find product
create or replace PROCEDURE find_product(
    productId IN NUMBER,
    price OUT NUMBER,
    productName OUT VARCHAR2
) AS
    v_discount NUMBER := 1;
BEGIN
    -- Check for November or December
    IF TO_CHAR(SYSDATE, 'MM') IN ('11', '12') THEN
        v_discount := 0.9; -- 10% discount
    END IF;

    SELECT 
        CASE 
            WHEN TO_CHAR(SYSDATE, 'MM') IN ('11', '12') AND category_id IN (2, 5) THEN list_price * 0.9 
            ELSE list_price 
        END,
        product_name
    INTO 
        price, 
        productName
    FROM 
        PRODUCTS
    WHERE 
        product_id = productId;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        price := 0;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Too many rows returned');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END find_product;

--add order
create or replace PROCEDURE add_order(
    customer_id IN NUMBER,
    new_order_id OUT NUMBER
) AS
BEGIN
    -- Call function to generate new order ID
    new_order_id := generate_order_id();

    -- Insert values into the orders table
    INSERT INTO orders (order_id, customer_id, status, salesman_id, order_date)
    VALUES (new_order_id, customer_id, 'Shipped', 56, SYSDATE);

    COMMIT; -- Commit the transaction
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
        -- Handle the error accordingly (rollback transaction, log, etc.)
END add_order;

--generate order id
create or replace FUNCTION generate_order_id RETURN NUMBER IS
    new_order_id NUMBER;
BEGIN
    SELECT MAX(order_id) + 1 INTO new_order_id FROM order_items;
    RETURN new_order_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 1; -- If the table is empty
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
        RETURN -1; -- Error case
END generate_order_id;

--add order item
create or replace PROCEDURE add_order_item (
    orderId    IN order_items.order_id%TYPE,
    itemId     IN order_items.item_id%TYPE,
    productId  IN order_items.product_id%TYPE,
    quantity   IN order_items.quantity%TYPE,
    price      IN order_items.unit_price%TYPE
) AS
BEGIN
    INSERT INTO order_items (order_id, item_id, product_id, quantity, unit_price)
    VALUES (orderId, itemId, productId, quantity, price);

    COMMIT; -- Commit the transaction
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
        -- Handle the error accordingly (rollback transaction, log, etc.)
END add_order_item;

--customer order
create or replace PROCEDURE customer_order(
    customerId IN NUMBER,
    orderId OUT NUMBER
) AS
BEGIN
    SELECT order_id INTO orderId
    FROM ORDERS
    WHERE customer_id = customerId
    AND ROWNUM = 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        orderId := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END customer_order;

--display order status
create or replace PROCEDURE display_order_status(
    orderId IN NUMBER,
    status OUT VARCHAR2
) AS
BEGIN
    SELECT status INTO status
    FROM ORDERS
    WHERE order_id = orderId;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        status := NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END display_order_status;

--cancel order
create or replace PROCEDURE cancel_order(orderId IN NUMBER, cancelStatus OUT NUMBER) AS
    orderStatus VARCHAR2(50);
BEGIN
    -- Initialize cancelStatus variable to 0 (order doesn't exist)
    cancelStatus := 0;

    -- Check if the order exists
    SELECT status INTO orderStatus FROM orders WHERE order_id = orderId;

    IF orderStatus = 'Canceled' THEN
        -- The order has been already canceled
        cancelStatus := 1;
    ELSIF orderStatus = 'Shipped' THEN
        -- The order is shipped and cannot be canceled
        cancelStatus := 2;
    ELSE
        -- The order is not canceled or shipped, update status to "Canceled"
        UPDATE orders SET status = 'Canceled' WHERE order_id = orderId;
        -- Set cancelStatus to indicate successful cancellation
        cancelStatus := 3;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Order does not exist
        cancelStatus := 0;
    WHEN OTHERS THEN
        -- Catch any other exceptions
        NULL; -- Optionally handle or log the exception
END;
