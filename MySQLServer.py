import mysql.connector
from mysql.connector import Error

def create_database():
    """Connects to MySQL server and creates the database."""
    try:
        
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="password"
        )

        if connection.is_connected():
            print("Connected to MySQL server.")

            
            cursor = connection.cursor()

           
            cursor.execute("CREATE DATABASE IF NOT EXISTS alx_book_store;")
            print("Database 'alx_book_store' created successfully!")

    except Error as e:
        print(f"Error: '{e}'")

    finally:
        
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("MySQL connection closed.")

if __name__ == "__main__":
    create_database()

