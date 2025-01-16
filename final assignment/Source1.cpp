///*****************************************************************************************************************************
//** ------- First Student
//** Student ID: 106758238
//** Student Full Name: Juhi Abhay Bhandari
//** ------- Second Student
//** Student ID:
//** Student Full Name: Khushi Abhay Bhandari
//** ------- Third Student
//** Student ID:
//** Student Full Name: Fariha Sajjan
//** DBS311 Assignment 2 - Fall 2024
//******************************************************************************************************************************/
//
//#define _CRT_SECURE_NO_WARNINGS
//#include <iostream>
//#include <occi.h>
//#include <string>
//#include <sstream>
//#include <cstring>
//#include <iomanip>
//
//using oracle::occi::Environment;
//using oracle::occi::Connection;
//using namespace oracle::occi;
//using namespace std;
//using std::setw;
//
//struct ShoppingCart {
//    int product_id;
//    string name;
//    double price;
//    int quantity;
//};
//
//struct Product {
//    double price;
//    string name;
//};
//
//int mainMenu();
//int subMenu();
//void customerService(Connection* conn, int customerId);
//void displayOrderStatus(Connection* conn, int orderId, int customerId);
//void cancelOrder(Connection* conn, int orderId, int customerId);
//void createEnvironement(Environment* env);
//void openConnection(Environment* env, Connection* conn, string user, string pass, string constr);
//void closeConnection(Connection* conn, Environment* env);
//void teminateEnvironement(Environment* env);
//int customerLogin(Connection* conn, int customerId);
//void findProduct(Connection* conn, int product_id, struct Product* product);
//int addToCart(Connection* conn, struct ShoppingCart cart[]);
//void displayProducts(struct ShoppingCart cart[], int productCount);
//int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);
//
//int main(void) {
//    int option;
//    /* OCCI Variables */
//    Environment* env = nullptr;
//    Connection* conn = nullptr;
//    string str;
//    string user = "dbs311_243ncc06";
//    string pass = "32513200";
//    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
//
//    try {
//        cout << "Connection successful" << endl;
//
//        // create environment and Open the connection
//        env = Environment::createEnvironment(Environment::DEFAULT);
//        conn = env->createConnection(user, pass, constr);
//
//        int customerId = 0;
//        do {
//            option = mainMenu();
//            switch (option) {
//            case 1:
//                cout << "Enter the customer ID: ";
//                cin >> customerId;
//                if (customerLogin(conn, customerId) == 1) {
//                    customerService(conn, customerId);
//                }
//                else {
//                    cout << "Customer does not exist." << endl;
//                }
//                break;
//            case 0:
//                cout << "Goodbye!..." << endl;
//                break;
//            }
//        } while (option != 0);
//
//        env->terminateConnection(conn);
//        Environment::terminateEnvironment(env);
//
//    }
//    catch (SQLException& sqlExcp) {
//        cout << "Error: " << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
//    }
//
//    return 0;
//}
//
//int mainMenu() {
//    int option = 1;
//    do {
//        cout << "******************** Main Menu ********************" << endl;
//        cout << "1) Login" << endl;
//        cout << "0) Exit" << endl;
//        cout << "Enter an option (0-1): ";
//        cin >> option;
//
//    } while (option < 0 || option > 1);
//    return option;
//}
//
//int subMenu() {
//    int opt = 1;
//    do {
//        cout << "******************** Customer Service Menu ********************" << endl;
//        cout << "1) Place an order" << endl;
//        cout << "2) Check an order status" << endl;
//        cout << "3) Cancel an order" << endl;
//        cout << "0) Exit" << endl;
//        cout << "Enter an option (0-3): ";
//        cin >> opt;
//    } while (opt < 0 || opt > 3);
//    return opt;
//}
//
//void customerService(Connection* conn, int customerId) {
//    struct ShoppingCart cart[5];
//    int checkedout = 0;
//    int productCount;
//    int orderId;
//    int opt = 0;
//
//    do {
//        opt = subMenu();
//        switch (opt) {
//        case 1:
//            cout << ">-------- Place an order ---------<" << endl;
//            productCount = addToCart(conn, cart);
//            displayProducts(cart, productCount);
//            checkedout = checkout(conn, cart, customerId, productCount);
//            if (checkedout) {
//                cout << "The order is successfully completed." << endl;
//            }
//            else {
//                cout << "The order is cancelled." << endl;
//            }
//            break;
//        case 2:
//            cout << ">-------- Check the order status --------<" << endl;
//            cout << "Enter an order ID: ";
//            cin >> orderId;
//            displayOrderStatus(conn, orderId, customerId);
//            break;
//        case 3:
//            cout << ">-------- Cancel an Order --------<" << endl;
//            cout << "Enter an order ID: ";
//            cin >> orderId;
//            cancelOrder(conn, orderId, customerId);
//            break;
//        case 0:
//            cout << "Back to main menu!..." << endl;
//            break;
//        }
//    } while (opt != 0);
//}
//
//void displayOrderStatus(Connection* conn, int orderId, int customerId) {
//    Statement* stmt = conn->createStatement("BEGIN get_order_status(:1, :2, :3); END;");
//    stmt->setInt(1, orderId);
//    stmt->setInt(2, customerId);
//    ResultSet* rs = stmt->executeQuery();
//    if (rs->next()) {
//        cout << "Order Status: " << rs->getString(1) << endl;
//    }
//    else {
//        cout << "No such order found!" << endl;
//    }
//    conn->terminateStatement(stmt);
//}
//
//void cancelOrder(Connection* conn, int orderId, int customerId) {
//    Statement* stmt = conn->createStatement("BEGIN cancel_order(:1, :2); END;");
//    stmt->setInt(1, orderId);
//    stmt->setInt(2, customerId);
//    stmt->executeUpdate();
//    cout << "Order has been canceled." << endl;
//    conn->terminateStatement(stmt);
//}
//
//void createEnvironement(Environment* env) {
//    try {
//        env = Environment::createEnvironment(Environment::DEFAULT);
//        cout << "Environment created" << endl;
//    }
//    catch (SQLException& sqlExcp) {
//        cout << "Error: " << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
//    }
//}
//
//void teminateEnvironement(Environment* env) {
//    Environment::terminateEnvironment(env);
//}
//
//void openConnection(Environment* env, Connection* conn, string user, string pass, string constr) {
//    try {
//        conn = env->createConnection(user, pass, constr);
//    }
//    catch (SQLException& sqlExcp) {
//        cout << "Error: " << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
//    }
//}
//
//void closeConnection(Connection* conn, Environment* env) {
//    env->terminateConnection(conn);
//}
//
//int customerLogin(Connection* conn, int customerId) {
//    Statement* stmt = nullptr;
//    int found = 0;
//    stmt = conn->createStatement("BEGIN find_customer(:1, :2); END;");
//    stmt->setInt(1, customerId);
//    stmt->registerOutParam(2, Type::OCCIINT, sizeof(found));
//    stmt->executeUpdate();
//    found = stmt->getInt(2);
//    conn->terminateStatement(stmt);
//    return found;
//}
//
//int addToCart(Connection* conn, struct ShoppingCart cart[]) {
//    int product_id = 0;
//    int productCount = 0;
//    int addMore = 1;
//    double price = 0;
//
//    Product product;
//
//    cout << "-------------- Add Products to Cart --------------" << endl;
//    for (int i = 0; i < 5 && addMore == 1; i++) {
//        do {
//            cout << "Enter the product ID: ";
//            cin >> product_id;
//            findProduct(conn, product_id, &product);
//
//            if (product.price != 0) {
//                cout << "Product Name: " << product.name << endl;
//                cout << "Product Price: " << product.price << endl;
//                cart[i].product_id = product_id;
//                cart[i].name = product.name;
//                cart[i].price = product.price;
//            }
//            else {
//                cout << "The product does not exist. Try again..." << endl;
//            }
//
//        } while (product.price == 0);
//
//        cout << "Enter the product Quantity: ";
//        cin >> cart[i].quantity;
//
//        productCount++;
//
//        cout << "Enter 1 to add more products or 0 to checkout: ";
//        cin >> addMore;
//    }
//
//    return productCount;
//}
//
//void findProduct(Connection* conn, int productId, struct Product* product) {
//    Statement* stmt = nullptr;
//    stmt = conn->createStatement("BEGIN find_product(:1, :2, :3); END;");
//    stmt->setInt(1, productId);
//    stmt->registerOutParam(2, Type::OCCIINT, sizeof(product->price));
//    stmt->registerOutParam(3, Type::OCCISTRING, sizeof(product->name));
//    stmt->executeUpdate();
//    product->price = stmt->getDouble(2);
//    product->name = stmt->getString(3);
//    conn->terminateStatement(stmt);
//}
//
//void displayProducts(struct ShoppingCart cart[], int productCount) {
//    double total = 0;
//    cout << "Product Name    | Quantity | Price | Total" << endl;
//    for (int i = 0; i < productCount; i++) {
//        double subtotal = cart[i].price * cart[i].quantity;
//        total += subtotal;
//        cout << setw(15) << cart[i].name << " | " << setw(7) << cart[i].quantity << " | " << setw(5) << cart[i].price << " | " << setw(5) << subtotal << endl;
//    }
//    cout << "Total: " << total << endl;
//}
//
//int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
//    double total = 0;
//    for (int i = 0; i < productCount; i++) {
//        total += cart[i].price * cart[i].quantity;
//    }
//
//    Statement* stmt = conn->createStatement("BEGIN place_order(:1, :2, :3); END;");
//    stmt->setInt(1, customerId);
//    stmt->setDouble(2, total);
//    stmt->setInt(3, productCount);
//    stmt->executeUpdate();
//    conn->terminateStatement(stmt);
//
//    return 1;
//}