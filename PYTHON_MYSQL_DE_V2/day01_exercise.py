# =============================================================================
# DAY 1 — EXERCISES
# Topic  : Connection object + mysql.connector.connect()
# Instructions: Work through each exercise in order.
#               Each one builds on the last.
#               Do NOT look at day01_connection.py while solving — try first.
# =============================================================================

import mysql.connector

DB_CONFIG = {
    "host":     "localhost",
    "port":     3306,
    "user":     "root",
    "password": "asd123",
    "database": "sql_practice",
}


# =============================================================================
# EXERCISE 1 — Basic connect and confirm
# =============================================================================
# Task:
#   Write a function called connect_and_confirm() that:
#     a. Opens a connection using DB_CONFIG
#     b. Prints "Connected: True/False" using conn.is_connected()
#     c. Prints the MySQL server version using conn.server_info
#     d. Closes the connection
#     e. Prints "Connected after close: True/False"
#
# Expected output:
#   Connected: True
#   MySQL version: 8.x.x
#   Connected after close: False
# =============================================================================

def get_connection():
    "It returns a DB connection"
    return mysql.connector.connect(**DB_CONFIG)

def connect_and_confirm():
    conn = get_connection()
    
    print(f"Connected : {conn.is_connected()}")
    print(f"SQL server version : {conn.server_info}")
    
    conn.close()
    print(f"Connected : {conn.is_connected()}")


# =============================================================================
# EXERCISE 2 — Connect with individual parameters (no dict)
# =============================================================================
# Task:
#   Rewrite the connection WITHOUT using DB_CONFIG.
#   Pass host, port, user, password, database directly as keyword arguments.
#   Print is_connected() and close.
#
# Goal: understand what ** actually unpacks — each key becomes a keyword arg.
# =============================================================================

def connect_without_dict():
    conn = mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="asd123",
        database="sql_practice",
    )
    
    print(f"Connected : {conn.is_connected()}")
    print(f"SQL server version : {conn.server_info}")
    
    conn.close()
    print(f"Connected : {conn.is_connected()}")


# =============================================================================
# EXERCISE 3 — Check connection identity
# =============================================================================
# Task:
#   Open TWO separate connections (conn1 and conn2).
#   Print the connection_id of each using:
#       cursor = conn.cursor()
#       cursor.execute("SELECT CONNECTION_ID()")
#       print(cursor.fetchone())
#       cursor.close()
#   Are the two connection IDs the same or different? Why?
#   Close both connections when done.
#
# Goal: see that each connect() call = a brand new TCP session on the server.
# =============================================================================

def two_connections():
    conn1 = get_connection()
    conn2 = get_connection()
    
    cursor1 = conn1.cursor()
    cursor1.execute("SELECT connection_id()")
    print(cursor1.fetchone())
    conn1.close()
    
    cursor2 = conn2.cursor()
    cursor2.execute("SELECT connection_id()")
    print(cursor2.fetchone())
    conn2.close()


# =============================================================================
# EXERCISE 4 — Reconnect after close
# =============================================================================
# Task:
#   a. Open a connection. Print is_connected() → True.
#   b. Close it.       Print is_connected() → False.
#   c. Try to open a NEW connection using the same DB_CONFIG.
#      Print is_connected() → True again.
#   d. Close it.
#
# Goal: understand that conn.close() doesn't destroy the config —
#       you can always open a fresh connection.
# =============================================================================

def reconnect_after_close():
    conn = get_connection()
    print(f"Connected : {conn.is_connected()}")
    conn.close()
    print(f"Connected : {conn.is_connected()}")
    
    conn = get_connection()
    print(f"Connected : {conn.is_connected()}")
    conn.close()


# =============================================================================
# EXERCISE 5 — Connect without specifying a database
# =============================================================================
# Task:
#   Create a new config dict WITHOUT the "database" key.
#   Connect using it.
#   Run:  cursor.execute("SELECT DATABASE()")
#         print(cursor.fetchone())
#   What does MySQL return when no database is selected?
#   Close cursor and connection.
#
# Goal: understand that "database" in the config is optional — it just sets
#       the default schema for queries, like USE sql_practice; in the shell.
# =============================================================================

def connect_no_database():
    conn = mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="asd123",
    )
    cursor = conn.cursor()
    cursor.execute("SELECT DATABASE();")
    print(cursor.fetchone())
    conn.close()


# =============================================================================
# EXERCISE 6 — Read server info fields
# =============================================================================
# Task:
#   Open a connection. Explore the connection object's attributes:
#     - conn.server_info      → version string
#     - conn.user             → which user you're connected as
#     - conn.server_host      → host address
#     - conn.database         → current database
#   Print all four. Close the connection.
#
# Goal: know what metadata is available on the connection object itself.
# =============================================================================

def print_connection_metadata():
    conn = get_connection()
    print(conn.server_info)
    print(conn.user)
    print(conn.server_host)
    print(conn.database)
    conn.close()


# =============================================================================
# RUN ALL
# =============================================================================

if __name__ == "__main__":
    print("=" * 50)
    print("EXERCISE 1 — Basic connect and confirm")
    print("=" * 50)
    connect_and_confirm()

    print("\n" + "=" * 50)
    print("EXERCISE 2 — Connect without dict")
    print("=" * 50)
    connect_without_dict()

    print("\n" + "=" * 50)
    print("EXERCISE 3 — Two connections")
    print("=" * 50)
    two_connections()

    print("\n" + "=" * 50)
    print("EXERCISE 4 — Reconnect after close")
    print("=" * 50)
    reconnect_after_close()

    print("\n" + "=" * 50)
    print("EXERCISE 5 — Connect without database")
    print("=" * 50)
    connect_no_database()

    print("\n" + "=" * 50)
    print("EXERCISE 6 — Connection metadata")
    print("=" * 50)
    print_connection_metadata()