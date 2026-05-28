# =============================================================================
# DAY 3 — MySQL + Python for Data Engineering
# Topic  : Handling MySQL Errors
# Goal   : Catch specific MySQL errors, read their attributes, and respond
#          to each failure mode without crashing your pipeline
# =============================================================================

import mysql.connector
from mysql.connector import Error, errorcode

DB_CONFIG = {
    "host":     "localhost",
    "port":     3306,
    "user":     "root",
    "password": "asd123",
    "database": "sql_practice",
}


def get_connection():
    """Opens and returns a MySQL connection. Caller must close it."""
    return mysql.connector.connect(**DB_CONFIG)


# =============================================================================
# CONCEPT 1 — from mysql.connector import Error
# =============================================================================
# `Error` is the base exception class for every MySQL problem the connector
# can raise. The full hierarchy looks like this:
#
#   Exception
#   └── mysql.connector.Error          ← everything MySQL
#       ├── InterfaceError             ← driver-level: bad config, wrong host/port
#       └── DatabaseError              ← server-level: bad SQL, wrong password
#           ├── DataError              ← wrong value type, out-of-range
#           ├── IntegrityError         ← FK violation, duplicate key
#           ├── ProgrammingError       ← bad SQL syntax, unknown table
#           └── OperationalError       ← lost connection, too many connections
#
# You can catch the base `Error` and handle everything in one block,
# OR catch specific subclasses to react differently to each failure.
#
# Import the base class:
#   from mysql.connector import Error
#
# Import specific subclasses when you need them:
#   from mysql.connector import InterfaceError, ProgrammingError
# =============================================================================


# =============================================================================
# CONCEPT 2 — except Error as e: reading error attributes
# =============================================================================
# When a MySQL error is raised, the exception object `e` carries three fields:
#
#   e.errno      → MySQL error number (integer), e.g. 1045 = Access denied
#   e.msg        → human-readable error message string
#   e.sqlstate   → 5-character SQLSTATE code, e.g. "28000" = auth failure
#
# These are more useful than just printing `e` because they let you:
#   - Branch on specific error numbers (errno == 1049 → database not found)
#   - Log structured error info to a table or monitoring system
#   - Show friendly messages to users without exposing raw MySQL internals
#
# Common MySQL error numbers:
#   1045  →  Access denied (wrong password or user)
#   1049  →  Unknown database
#   1064  →  SQL syntax error
#   1146  →  Table doesn't exist
#   2003  →  Can't connect to MySQL server (wrong host / port)
#
# The `errorcode` module gives you named constants so you can write:
#   if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
# instead of magic numbers.
# =============================================================================


def demo_wrong_password():
    """Shows what happens when credentials are wrong."""
    bad_config = {**DB_CONFIG, "password": "wrongpass"}
    conn = None
    try:
        conn = mysql.connector.connect(**bad_config)
    except Error as e:
        print(f"[wrong password]")
        print(f"  errno    : {e.errno}")
        print(f"  msg      : {e.msg}")
        print(f"  sqlstate : {e.sqlstate}")
    finally:
        if conn and conn.is_connected():
            conn.close()


def demo_wrong_database():
    """Shows what happens when the database name doesn't exist."""
    bad_config = {**DB_CONFIG, "database": "db_does_not_exist"}
    conn = None
    try:
        conn = mysql.connector.connect(**bad_config)
    except Error as e:
        print(f"[wrong database]")
        print(f"  errno    : {e.errno}")
        print(f"  msg      : {e.msg}")
        print(f"  sqlstate : {e.sqlstate}")
    finally:
        if conn and conn.is_connected():
            conn.close()


def demo_bad_sql():
    """Shows what happens when you send invalid SQL."""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELEKT * FORM employees")   # typos on purpose
        cursor.close()
    except Error as e:
        print(f"[bad SQL]")
        print(f"  errno    : {e.errno}")
        print(f"  msg      : {e.msg}")
        print(f"  sqlstate : {e.sqlstate}")
    finally:
        if conn and conn.is_connected():
            conn.close()


# =============================================================================
# Python tip — except ExceptionType as e
# =============================================================================
# The `as e` part gives you a name (variable) that points to the exception
# object. Without it you can still catch the error but you lose all the info:
#
#   except Error:           ← silences the error, no details
#   except Error as e:      ← gives you e.errno, e.msg, e.sqlstate
#
# You can use any valid variable name, but `e` and `err` are conventions.
#
# You can also stack multiple except clauses — Python checks them top to
# bottom and runs the FIRST one that matches:
#
#   try:
#       conn = mysql.connector.connect(**bad_config)
#   except InterfaceError as e:
#       print(f"Driver error (host/port/config): {e.msg}")
#   except Error as e:
#       print(f"MySQL error: {e.msg}")
#
# InterfaceError is a subclass of Error, so it would match BOTH blocks.
# Python picks the first match — put the more specific class first.
# =============================================================================


def demo_specific_vs_base():
    """Catching a specific subclass vs the base Error class."""
    bad_config = {**DB_CONFIG, "password": "wrongpass"}
    conn = None
    try:
        conn = mysql.connector.connect(**bad_config)
    except mysql.connector.errors.DatabaseError as e:
        # DatabaseError covers server-side rejections (auth, unknown db, etc.)
        if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Access denied — check your username and password.")
        elif e.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database not found — check DB_CONFIG['database'].")
        else:
            print(f"Database error {e.errno}: {e.msg}")
    except Error as e:
        # Fallback for InterfaceError (wrong host/port, connection refused)
        print(f"Connection error: {e.msg}")
    finally:
        if conn and conn.is_connected():
            conn.close()


# =============================================================================
# DEMO
# =============================================================================

def run_demo():
    print("=== demo_wrong_password ===")
    demo_wrong_password()

    print("\n=== demo_wrong_database ===")
    demo_wrong_database()

    print("\n=== demo_bad_sql ===")
    demo_bad_sql()

    print("\n=== demo_specific_vs_base (errno-based branching) ===")
    demo_specific_vs_base()


if __name__ == "__main__":
    run_demo()