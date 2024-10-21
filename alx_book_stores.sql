import mysql.connector
from mysql.connector import Error

def create_connection(host_name, user_name, user_password):
    """Create a connection to MySQL Server."""
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=user_password
        )
        if connection.is_connected():
            print("Connected to MySQL server.")
        return connection
    except Error as e:
        print(f"Error: '{e}'")
        return None

def create_database(connection, query):
    """Create the bookstore database."""
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        print("Database created successfully.")
    except Error as e:
        print(f"Error: '{e}'")

def connect_database(host_name, user_name, user_password, db_name):
    """Connect to the specific database."""
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=user_password,
            database=db_name
        )
        if connection.is_connected():
            print(f"Connected to the database '{db_name}'.")
        return connection
    except Error as e:
        print(f"Error: '{e}'")
        return None

def execute_query(connection, query):
    """Execute SQL queries such as creating tables or inserting data."""
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query executed successfully.")
    except Error as e:
        print(f"Error: '{e}'")

if __name__ == "__main__":
    # Step 1: Connect to MySQL server
    connection = create_connection("localhost", "root", "password")

    # Step 2: Create the database
    create_database_query = "CREATE DATABASE IF NOT EXISTS alx_book_store;"
    create_database(connection, create_database_query)

    # Step 3: Connect to the 'alx_book_store' database
    db_connection = connect_database("localhost", "root", "password", "alx_book_store")

    # Step 4: Create tables
    create_authors_table = """
    CREATE TABLE IF NOT EXISTS Authors (
        author_id INT AUTO_INCREMENT PRIMARY KEY,
        author_name VARCHAR(215) NOT NULL
    );
    """
    create_books_table = """
    CREATE TABLE IF NOT EXISTS Books (
        book_id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(130) NOT NULL,
        author_id INT,
        price DOUBLE NOT NULL,
        publication_date DATE,
        FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
    );
    """
    create_customers_table = """
    CREATE TABLE IF NOT EXISTS Customers (
        customer_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_name VARCHAR(215) NOT NULL,
        email VARCHAR(215) UNIQUE NOT NULL,
        address TEXT
    );
    """
    create_orders_table = """
    CREATE TABLE IF NOT EXISTS Orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT NOT NULL,
        order_date DATE NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
    );
    """
    create_order_details_table = """
    CREATE TABLE IF NOT EXISTS Order_Details (
        orderdetailid INT AUTO_INCREMENT PRIMARY KEY,
        order_id INT NOT NULL,
        book_id INT NOT NULL,
        quantity DOUBLE NOT NULL,
        FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
        FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
    );
    """

    # Execute table creation queries
    execute_query(db_connection, create_authors_table)
    execute_query(db_connection, create_books_table)
    execute_query(db_connection, create_customers_table)
    execute_query(db_connection, create_orders_table)
    execute_query(db_connection, create_order_details_table)

    # Step 5: Insert sample data
    insert_data_query = """
    INSERT INTO Authors (author_name) VALUES
    ('J.K. Rowling'), ('George R.R. Martin');
    
    INSERT INTO Books (title, author_id, price, publication_date) VALUES
    ('Harry Potter', 1, 19.99, '1997-06-26'),
    ('A Game of Thrones', 2, 29.99, '1996-08-06');
    
    INSERT INTO Customers (customer_name, email, address) VALUES
    ('Alice', 'alice@example.com', '123 Wonderland St.');
    
    INSERT INTO Orders (customer_id, order_date) VALUES
    (1, '2024-10-20');
    
    INSERT INTO Order_Details (order_id, book_id, quantity) VALUES
    (1, 1, 2);
    """
    execute_query(db_connection, insert_data_query)

    # Step 6: Close the connection
    if db_connection.is_connected():
        db_connection.close()
        print("Database connection closed.")
        