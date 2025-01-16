/*****************************************************************************************************************************
** ------- First Student
** Student ID: 166194233
** Student Full Name:  Fariha Shajjan
** ------- Second Student
** Student ID:
** Student Full Name:
** ------- Third Student
** Student ID:
** Student Full Name:
** DBS311 Assignment 2 - Fall 2024
******************************************************************************************************************************/


#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <occi.h>

#include <string>
#include <sstream>
#include <cstring>

#include <iomanip>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;
using std::setw;

struct ShoppingCart {
    int product_id;
    string name;
    double price;
    int quantity;
};
struct Product {
    double price;
    string name;
};

int mainMenu();
int subMenu();
void customerService(Connection* conn, int customerId);
void displayOrderStatus(Connection* conn, int orderId, int customerId); // Implemented
void cancelOrder(Connection* conn, int orderId, int customerId);        // Implemented
void createEnvironement(Environment* env);
void openConnection(Environment* env, Connection* conn, string user, string pass, string constr);
void closeConnection(Connection* conn, Environment* env);
void teminateEnvironement(Environment* env);
int customerLogin(Connection* conn, int customerId);
void findProduct(Connection* conn, int product_id, struct Product* product);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);

int main(void)
{
    int option;
    /* OCCI Variables */
    Environment* env = nullptr;
    Connection* conn = nullptr;

    /* Used Variables */
    /* Used Variables */
    string str;
    string user = "dbs311_243ncc06";
    string pass = "32513200";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

    try {
        // Create environment and open the connection
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);

        int customerId = 0;

        do {

            option = mainMenu();
            switch (option) {

            case 1:

                cout << "Enter the customer ID: ";
                cin >> customerId;

                if (customerLogin(conn, customerId) == 1) {
                    // Call customerService()
                    customerService(conn, customerId);
                }
                else {
                    cout << "The customer does not exist." << endl;
                }
                break;
            case 0:
                cout << "Good bye!..." << endl;
                break;

            default:
                cout << "You entered a wrong value. Enter an option (0-1): ";
                break;
            }
        } while (option != 0);

        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);

    }

    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
    }

    return 0;
}

int mainMenu() {
    int option = -1;
    do {
        // Display the menu options
        cout << "******************** Main Menu ********************" << endl;
        cout << "1)      Login" << endl;
        cout << "0)      Exit" << endl;
        // Read an option value

        cout << "Enter an option (0-1): ";
        cin >> option;

        if (cin.fail() || option < 0 || option > 1) {
            cin.clear();
            cin.ignore(1000, '\n');
            cout << "You entered a wrong value. Please try again." << endl;
            option = -1; // Reset option to stay in the loop
        }
    } while (option < 0 || option > 1);

    return option;
}

int subMenu() {
    int opt = -1;

    do {
        // Display the menu options
        cout << "******************** Customer Service Menu ********************" << endl;
        cout << "1) Place an order" << endl;
        cout << "2) Check an order status" << endl;
        cout << "3) Cancel an order" << endl;
        cout << "0) Exit" << endl;
        // Read an option value

        cout << "Enter an option (0-3): ";
        cin >> opt;

        if (cin.fail() || opt < 0 || opt > 3) {
            cin.clear();
            cin.ignore(1000, '\n');
            cout << "You entered a wrong value. Please try again." << endl;
            opt = -1; // Reset opt to stay in the loop
        }
    } while (opt < 0 || opt > 3);

    return opt;
}

void customerService(Connection* conn, int customerId) {
    struct ShoppingCart cart[5];
    int checkedout = 0;
    int productCount;
    int orderId;
    int opt = 0;

    do {

        opt = subMenu();
        switch (opt) {

        case 1:

            cout << ">-------- Place an order ---------<" << endl;

            productCount = addToCart(conn, cart);
            displayProducts(cart, productCount);
            checkedout = checkout(conn, cart, customerId, productCount);
            if (checkedout) {
                cout << "The order is successfully completed." << endl;
            }
            else {
                cout << "The order is cancelled." << endl;
            }
            break;
        case 2:
            cout << ">-------- Check the order status --------<" << endl;
            cout << "Enter an order ID: ";
            cin >> orderId;
            displayOrderStatus(conn, orderId, customerId);
            break;
        case 3:

            cout << ">-------- Cancel an Order --------<" << endl;
            cout << "Enter an order ID: ";
            cin >> orderId;
            cancelOrder(conn, orderId, customerId);
            break;
        case 0:
            cout << "Back to main menu!..." << endl;
            break;

        default:
            cout << "You entered a wrong value. Enter an option (0-3): " << endl;
            break;
        }
    } while (opt != 0);

}

// Implemented displayOrderStatus function
void displayOrderStatus(Connection* conn, int orderId, int customerId) {

    try {
        Statement* stmt = nullptr;
        int validOrderId = orderId; // Since orderId is IN OUT

        // Call customer_order procedure
        stmt = conn->createStatement("BEGIN customer_order(:1, :2); END;");
        stmt->setInt(1, customerId);
        stmt->setInt(2, orderId);
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(validOrderId));
        stmt->executeUpdate();
        validOrderId = stmt->getInt(2);
        conn->terminateStatement(stmt);

        if (validOrderId ==1) {
            cout << "Order ID is not valid." << endl;
            return;
        }

        // Call display_order_status procedure
        stmt = conn->createStatement("BEGIN display_order_status(:1, :2); END;");
        stmt->setInt(1, orderId);
        stmt->registerOutParam(2, Type::OCCISTRING, 100); // Assuming max length of status is 100
        stmt->executeUpdate();
        string status = stmt->getString(2);
        conn->terminateStatement(stmt);

        if (status.empty()) {
            cout << "Order does not exist." << endl;
        }
        else {
            cout << "Order is " << status << "." << endl;
        }
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
    }

}

// Implemented cancelOrder function
void cancelOrder(Connection* conn, int orderId, int customerId) {

    try {
        Statement* stmt = nullptr;
        int validOrderId = orderId; // Since orderId is IN OUT

        // Call customer_order procedure to confirm the order belongs to the customer
        stmt = conn->createStatement("BEGIN customer_order(:1, :2); END;");
        stmt->setInt(1, customerId);
        stmt->setInt(2, orderId);
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(validOrderId));
        stmt->executeUpdate();
        validOrderId = stmt->getInt(2);
        conn->terminateStatement(stmt);

        if (validOrderId < 0) {
            cout << "Order ID is not valid." << endl;
            return;
        }

        // Call cancel_order procedure
        int cancelStatus = 0;
        stmt = conn->createStatement("BEGIN cancel_order(:1, :2); END;");
        stmt->setInt(1, orderId);
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(cancelStatus));
        stmt->executeUpdate();
        cancelStatus = stmt->getInt(2);
        conn->terminateStatement(stmt);

        // Interpret cancelStatus and display appropriate message
        switch (cancelStatus) {
        case 0:
            cout << "The order does not exist." << endl;
            break;
        case 1:
            cout << "The order has been already canceled." << endl;
            break;
        case 2:
            cout << "The order is shipped and cannot be canceled." << endl;
            break;
        case 3:
            cout << "The order is canceled successfully." << endl;
            break;
        default:
            cout << "Unknown status." << endl;
            break;
        }

    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
    }

}

void createEnvironement(Environment* env) {
    try {
        env = Environment::createEnvironment(Environment::DEFAULT);
        cout << "Environment created" << endl;
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
    }

}

void teminateEnvironement(Environment* env) {
    Environment::terminateEnvironment(env);
}

void openConnection(Environment* env, Connection* conn, string user, string pass, string constr) {
    try {
        conn = env->createConnection(user, pass, constr);
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
    }
}

void closeConnection(Connection* conn, Environment* env) {
    env->terminateConnection(conn);
}

int customerLogin(Connection* conn, int customerId) {

    Statement* stmt = nullptr;
    int found = 0;
    try {
        stmt = conn->createStatement("BEGIN find_customer(:1, :2); END;");
        stmt->setInt(1, customerId);
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(found));
        stmt->executeUpdate();
        found = stmt->getInt(2);
        conn->terminateStatement(stmt);
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
        conn->terminateStatement(stmt);
    }

    return found;

}

int addToCart(Connection* conn, struct ShoppingCart cart[]) {
    int product_id = 0;
    int productCount = 0;
    int addMore = 1;

    Product product;

    cout << "-------------- Add Products to Cart --------------" << endl;
    for (int i = 0; i < 5 && addMore == 1; i++) {
        do {
            cout << "Enter the product ID: ";
            cin >> product_id;

            // Call a stored procedure/function to check if the product exists
            findProduct(conn, product_id, &product);

            /* If the price is zero, the product does not exist
               if the price is greater than zero the product display the following
               output:
               Product Price: */

            if (product.price != 0) {
                cout << "Product Name: " << product.name << endl;
                cout << "Product Price: " << product.price << endl;
                cart[i].product_id = product_id;
                cart[i].name = product.name;
                cart[i].price = product.price;
                
            }
            else {
                cout << "The product does not exist. Try again..." << endl;
            }

        } while (product.price == 0);

        cout << "Enter the product Quantity: ";
        cin >> cart[i].quantity;

        productCount++;

        if (productCount < 5) {
            cout << "Enter 1 to add more products or 0 to checkout: ";
            cin >> addMore;

            while (addMore != 0 && addMore != 1) {
                cout << "Invalid input. Enter 1 to add more products or 0 to checkout: ";
                cin >> addMore;
            }
        }
        else {
            cout << "You have reached the maximum number of items in the cart." << endl;
            addMore = 0;
        }
    }

    return productCount;

}

void findProduct(Connection* conn, int productId, struct Product* product) {
    Statement* stmt = nullptr;

    try {
        stmt = conn->createStatement("BEGIN find_product(:1, :2, :3); END;");
        stmt->setInt(1, productId);
        stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(product->price));
        stmt->registerOutParam(3, Type::OCCISTRING, 100); // Assuming product name max length is 100
        stmt->executeUpdate();
        product->price = stmt->getDouble(2);
        product->name = stmt->getString(3);
        conn->terminateStatement(stmt);
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
        product->price = 0;
        product->name = "";
        conn->terminateStatement(stmt);
    }

}

void displayProducts(struct ShoppingCart cart[], int productCount) {

    double total = 0;
    cout << "------- Ordered Products ---------" << endl;
    for (int i = 0; i < productCount; i++) {
        cout << "---Item " << i + 1 << endl;
        cout << "Product ID: " << cart[i].product_id << endl;
        cout << "Name: " << cart[i].name << endl;
        cout << "Price: " << fixed << setprecision(2) << cart[i].price << endl;
        cout << "Quantity: " << cart[i].quantity << endl;
        total = total + cart[i].price * cart[i].quantity;
    }

    cout << "----------------------------------" << endl;
    cout << "Total: " << fixed << setprecision(2) << total << endl;

}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
    char confirm = ' ';
    int exit = 1;
    do {
        cout << "Would you like to checkout? (Y/y or N/n) ";
        cin >> confirm;
        if (confirm == 'Y' || confirm == 'y') {
            exit = 0;
        }
        else if (confirm == 'N' || confirm == 'n') {
            exit = 1;
        }
        else {
            cout << "Wrong input. Try again..." << endl;
        }
    } while (confirm != 'N' && confirm != 'n' && confirm != 'Y' && confirm != 'y');

    if (!exit) {
        Statement* stmt = nullptr;
        int order_id = 0;

        try {
            // Add order
            stmt = conn->createStatement("BEGIN add_order(:1, :2); END;");
            stmt->setInt(1, customerId);
            stmt->registerOutParam(2, Type::OCCIINT, sizeof(order_id));
            stmt->executeUpdate();
            order_id = stmt->getInt(2);
            conn->terminateStatement(stmt);

            // Add items
            for (int i = 0; i < productCount; i++) {
                stmt = conn->createStatement("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");
                stmt->setInt(1, order_id);
                stmt->setInt(2, i + 1);
                stmt->setInt(3, cart[i].product_id);
                stmt->setInt(4, cart[i].quantity);
                stmt->setDouble(5, cart[i].price);
                stmt->executeUpdate();
                conn->terminateStatement(stmt);
            }

            conn->commit();

        }
        catch (SQLException& sqlExcp) {
            cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage() << endl;
            conn->rollback();
            if (stmt != nullptr) {
                conn->terminateStatement(stmt);
            }
            return 0; // Return 0 to indicate checkout failed
        }

    }

    return !exit;
}

   

