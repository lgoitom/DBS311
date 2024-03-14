/*--******************************************************************
-- Group 06
-- Student1 Name: Luwam Goitom-Worre Student1 ID: 156652224
-- Student2 Name: Chidera Osondu Student2 ID: 174098210
-- Student3 Name: Brandon Davis Student3 ID: 123539223
-- Date: November 30, 2023
-- Purpose: Assignment 2 - DBS311
--******************************************************************/


void displayOrderStatus(Connection* conn, int orderId, int customerId) {
    Statement* stmt = nullptr;
    int customerOrder = 0;

    // Call the customer_order stored procedure
    stmt = conn->createStatement("BEGIN customer_order(:1, :2); END;");
    stmt->setInt(1, customerId);
    stmt->setInt(2,orderId);
    //stmt->registerOutParam(2, Type::OCCIINT, sizeof(orderStatus));
    stmt->executeUpdate();
    customerOrder = stmt->getInt(2);
    conn->terminateStatement(stmt);

    if (customerOrder == 0) {
        cout << "Order ID is not valid." << endl;
    }
    else {
        string orderStatusText;

        // Call the display_order_status procedure
        stmt = conn->createStatement("BEGIN display_order_status(:1, :2); END;");
        stmt->setInt(1, orderId);
        stmt->registerOutParam(2, Type::OCCISTRING, sizeof(orderStatusText));
        stmt->executeUpdate();
        orderStatusText = stmt->getString(2);
        conn->terminateStatement(stmt);

        if (orderStatusText.empty()) {
            cout << "Order does not exist." << endl;
        }
        else {
            cout << "Order is " << orderStatusText << "." << endl;
        }
    }

}

//Complete this function
void cancelOrder(Connection* conn, int orderId, int customerId) {
    Statement* stmt = nullptr;
    int customerStatus = 0;
    int cancelStatus = 0;

    // Call the customer_order procedure to check order ownership
    stmt = conn->createStatement("BEGIN customer_order(:1, :2); END;");
    stmt->setInt(1, customerId); // Pass customerId to check orders
    stmt->registerOutParam(2, Type::OCCIINT, sizeof(customerStatus));
    stmt->executeUpdate();
    customerStatus = stmt->getInt(2);
    conn->terminateStatement(stmt);

    if (customerStatus == 0) {
        cout << "Order ID is not valid." << endl;
    }
    else {
        // Call the cancel_order procedure to cancel the order
        stmt = conn->createStatement("BEGIN cancel_order(:1, :2); END;");
        stmt->setInt(1, orderId);
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(cancelStatus));
        stmt->executeUpdate();
        cancelStatus = stmt->getInt(2);
        conn->terminateStatement(stmt);

        if (cancelStatus == 1) {
            cout << "The order has been already canceled." << endl;
        }
        else if (cancelStatus == 2) {
            cout << "The order is shipped and cannot be canceled." << endl;
        }
        else if (cancelStatus == 3) {
            cout << "The order is canceled successfully." << endl;
        }
    }

}