# =============================================================================
# DAY 1 — MySQL + Python for Data Engineering
# Topic  : Connection object & Cursor types
# Goal   : Understand how Python talks to MySQL and which cursor to pick
# =============================================================================

# -----------------------------------------------------------------------------
# STEP 0 — Install (run once in terminal, not here)
# pip install mysql-connector-python
# -----------------------------------------------------------------------------

import mysql.connector
from mysql.connector import Error

# =============================================================================
# CONCEPT 1 — The Connection Object
# =============================================================================
# mysql.connector.connect() opens a TCP socket to MySQL.
# Think of it like opening a pipeline between your Python script and MySQL server.
# You must always CLOSE it when done — unclosed connections eat server resources,
# which is a real problem in production DE pipelines.

# Fill in your MySQL credentials:
DB_CONFIG = {
    "host": "localhost",      # or your MySQL server IP
    "port": 3306,
    "user": "root",           # your MySQL username
    "password": "asd123",  # your MySQL password
    "database": "sql_practice",   # the DB you want to connect to
}


def get_connection():
    """Returns a MySQL connection. Caller is responsible for closing it."""
    conn = mysql.connector.connect(**DB_CONFIG)
    return conn


# =============================================================================
# CONCEPT 2 — Cursor Types (this is the key decision in every DE script)
# =============================================================================
#
# A cursor is the object you use to send SQL and receive results.
# MySQL connector gives you 3 main flavors:
#
# 1. DEFAULT cursor  → returns rows as TUPLES  → fastest, lowest memory
#    conn.cursor()
#    row = (1, 'alice', 'engineer')
#
# 2. DICTIONARY cursor → returns rows as DICTS  → readable, great for DE
#    conn.cursor(dictionary=True)
#    row = {'id': 1, 'name': 'alice', 'role': 'engineer'}
#
# 3. BUFFERED cursor  → fetches ALL rows into memory immediately after execute()
#    conn.cursor(buffered=True)
#    Use when: you need to run a second query on the SAME connection
#              before fully consuming the first cursor's results.
#
# In Data Engineering:
#   - Use DICTIONARY cursor when you need column names (loading to pandas, logging)
#   - Use DEFAULT cursor for raw speed when column names don't matter
#   - Use BUFFERED when nesting queries on the same connection
# =============================================================================


def demo_default_cursor(conn):
    """Default cursor — rows come back as tuples."""
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES;")

    print("\n--- DEFAULT CURSOR (tuples) ---")
    for row in cursor:
        print(row)       # e.g. ('orders',)   <- tuple, no column name
    cursor.close()


def demo_dictionary_cursor(conn):
    """Dictionary cursor — rows come back as dicts with column names."""
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""SELECT TABLE_NAME, TABLE_ROWS, DATA_LENGTH
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = 'sql_practice';""")

    print("\n--- DICTIONARY CURSOR (dicts) ---")
    for row in cursor:
        print(row)       # e.g. {'Tables_in_your_db': 'orders'}
    cursor.close()


def demo_buffered_cursor(conn):
    """
    Buffered cursor — all rows loaded into memory on execute().
    Needed when you open a second cursor on the same connection
    before consuming the first one fully.
    """
    cursor = conn.cursor(buffered=True)
    cursor.execute("SHOW TABLES;")

    print("\n--- BUFFERED CURSOR ---")
    # Safe to open another cursor here because rows are already in memory
    print(f"Total tables fetched into memory: {cursor.rowcount}")
    cursor1 = conn.cursor(buffered=True)
    cursor1.execute("SELECT * FROM orders;")
    for row in cursor:
        print(row)

    for row in cursor1:
        print(row)
    cursor.close()
    cursor1.close()


# =============================================================================
# CONCEPT 3 — Always close connections (use try/finally)
# =============================================================================
# In a pipeline, if your script crashes mid-run without closing the connection,
# MySQL holds that connection open until timeout. At scale this causes
# "Too many connections" errors. Always use try/finally or context managers.

def safe_connection_demo():
    conn = None
    try:
        conn = get_connection()
        print(f"\nConnected: {conn.is_connected()}")
        print(f"MySQL version: {conn.server_info}")

       # demo_default_cursor(conn)
        demo_dictionary_cursor(conn)
       # demo_buffered_cursor(conn)

    except Error as e:
        print(f"MySQL Error: {e}")

    finally:
        if conn and conn.is_connected():
            conn.close()
            print("\nConnection closed.")


# =============================================================================
# EXERCISE — Your task for today
# =============================================================================
# 1. Fill in DB_CONFIG above with your local MySQL credentials.
# 2. Run this script and observe the difference in output between
#    the 3 cursor types for SHOW TABLES.
# 3. Modify demo_dictionary_cursor() to run this query instead:
#       SELECT TABLE_NAME, TABLE_ROWS, DATA_LENGTH
#       FROM information_schema.TABLES
#       WHERE TABLE_SCHEMA = 'your_db_name';
#    Print each row. Notice how dictionary cursor gives you column names for free.
#    This is exactly how DE pipelines introspect database schemas dynamically.
# =============================================================================

if __name__ == "__main__":
    safe_connection_demo()
