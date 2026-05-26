# =============================================================================
# DAY 2 — MySQL + Python for Data Engineering
# Topic  : Closing Connections Safely
# Goal   : Guarantee conn.close() always runs, even when the script crashes
# =============================================================================

import mysql.connector
from mysql.connector import Error

DB_CONFIG = {
    "host":     "localhost",
    "port":     3306,
    "user":     "root",
    "password": "asd123",
    "database": "sql_practice",
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


# =============================================================================
# CONCEPT 1 — Why unclosed connections are dangerous
# =============================================================================
# Every call to mysql.connector.connect() opens a TCP socket on the MySQL server.
# MySQL has a hard limit on how many connections can be open at once
# (default: 151 on most installs).
#
# If your script crashes mid-run WITHOUT closing the connection:
#   - The server holds that socket open until it times out (minutes to hours).
#   - Run this script in a loop or scheduler and you silently eat all 151 slots.
#   - The next connection attempt gets: "Too many connections" — your pipeline dies.
#
# This is called a CONNECTION LEAK and it's one of the most common DE bugs.
#
# The naive (broken) pattern:
#
#   conn = get_connection()
#   do_something_that_might_crash(conn)
#   conn.close()            # ← never reached if the line above raises
#
# If do_something_that_might_crash() raises an exception, Python jumps out
# of the function immediately and conn.close() is SKIPPED.
# =============================================================================


def unsafe_demo():
    """This leaks a connection if the query raises."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM table_that_does_not_exist")   # raises Error
    cursor.close()
    conn.close()    # ← never reached


# =============================================================================
# CONCEPT 2 — try / finally  (the fix)
# =============================================================================
# Python's `finally` block ALWAYS runs — whether the try block succeeded,
# raised an exception, hit a return, or even called sys.exit().
#
# Pattern to memorise:
#
#   conn = None
#   try:
#       conn = get_connection()
#       ... do your work ...
#   except Error as e:
#       print(f"MySQL error: {e}")
#   finally:
#       if conn and conn.is_connected():
#           conn.close()
#
# Why `conn = None` before the try?
#   If get_connection() itself raises (wrong password, server down),
#   `conn` was never assigned. Without the None initialisation, the finally
#   block would raise NameError when it tries to read `conn`.
#
# Why `conn.is_connected()` check?
#   mysql-connector can auto-close under certain errors.
#   Calling close() on an already-closed connection raises an error.
#   The check makes the finally block safe in all cases.
# =============================================================================


def safe_demo():
    """Connection is always closed, even if the query raises."""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM table_that_does_not_exist")   # raises
        cursor.close()

    except Error as e:
        print(f"Caught MySQL error: {e}")

    finally:
        if conn and conn.is_connected():
            conn.close()
            print("Connection closed in finally block.")


# =============================================================================
# Python tip — finally always runs, even with return
# =============================================================================
# This surprises beginners. Even a `return` inside `try` triggers `finally`:
#
#   def f():
#       try:
#           return 42       # finally still runs before the caller gets 42
#       finally:
#           print("finally!")
#
#   f()   → prints "finally!" then returns 42
#
# This is exactly what makes it safe for cleanup code.
# =============================================================================


def demo_finally_with_return():
    conn = None
    try:
        conn = get_connection()
        print(f"Connected: {conn.is_connected()}")
        return "done"       # finally still runs before the caller gets "done"

    finally:
        if conn and conn.is_connected():
            conn.close()
            print(f"finally ran — closed: {not conn.is_connected()}")


# =============================================================================
# DEMO
# =============================================================================

def run_demo():
    print("=== safe_demo (exception is caught, connection still closes) ===")
    safe_demo()

    print("\n=== demo_finally_with_return ===")
    result = demo_finally_with_return()
    print(f"Return value: {result}")


if __name__ == "__main__":
    run_demo()