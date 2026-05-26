# =============================================================================
# DAY 2 — EXERCISES
# Topic  : Closing Connections Safely (try / finally)
# Instructions: Work through each exercise in order.
#               Do NOT look at day02_close_safely.py while solving — try first.
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
# EXERCISE 1 — Prove that finally always runs
# =============================================================================
# Task:
#   Write a function called prove_finally() that:
#     a. Opens a connection inside a try block
#     b. Immediately raises a ValueError("simulated crash") inside try
#     c. In the finally block, closes the connection and prints:
#        "finally ran — connection closed: True/False"
#     d. In the except block, catches the ValueError and prints:
#        "caught: simulated crash"
#
# Expected output:
#   caught: simulated crash
#   finally ran — connection closed: True
#
# Key observation: the print in finally appears AFTER the except print
# because Python runs except first, then finally.
# =============================================================================

def prove_finally():
    pass   # replace with your code


# =============================================================================
# EXERCISE 2 — finally runs even with return
# =============================================================================
# Task:
#   Write a function called return_with_finally() that:
#     a. Opens a connection inside a try block
#     b. Returns the string "query done" from inside the try block
#        (do NOT raise anything — this is the happy path)
#     c. In the finally block, closes the connection and prints:
#        "finally ran before return"
#
#   Call the function and print its return value.
#
# Expected output:
#   finally ran before return
#   query done
#
# Key observation: finally fires BEFORE the caller receives the return value.
# =============================================================================

def return_with_finally():
    pass   # replace with your code


# =============================================================================
# EXERCISE 3 — The conn = None guard
# =============================================================================
# Task:
#   Write a function called safe_bad_password() that:
#     a. Builds a config dict with a WRONG password (e.g. "wrongpass")
#     b. Sets conn = None before the try block
#     c. Inside try: attempts to connect with the bad config
#     d. Inside except Error: prints "connection failed: <error message>"
#     e. Inside finally: checks  `if conn and conn.is_connected()`
#        and prints either "closed connection" or "nothing to close"
#
# Expected output:
#   connection failed: Access denied ...
#   nothing to close
#
# Key observation: without conn = None, the finally block would raise
# NameError because conn was never assigned.
# =============================================================================

def safe_bad_password():
    pass   # replace with your code


# =============================================================================
# EXERCISE 4 — Wrap an existing function safely
# =============================================================================
# Task:
#   The function below is UNSAFE — it leaks a connection if the query fails.
#   Rewrite it as safe_fetch() using try / finally so the connection
#   always closes, whether the query succeeds or raises.
#   Return the rows on success, return an empty list on error.
#
# Do NOT change what the function does — only add the safety pattern.
# =============================================================================

def unsafe_fetch():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, name FROM employees LIMIT 5")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows


def safe_fetch():
    pass   # rewrite unsafe_fetch() with try / finally


# =============================================================================
# EXERCISE 5 — Multiple operations, one finally
# =============================================================================
# Task:
#   Write a function called multi_op(table) that:
#     a. Opens a connection
#     b. In try: runs TWO queries in sequence:
#          1. SELECT COUNT(*) FROM <table>  → print the count
#          2. SELECT DATABASE()             → print the current db name
#     c. In finally: closes the connection
#
#   Call it with table="employees".
#
# Goal: one try/finally block can safely wrap multiple operations.
#       You don't need a separate try/finally for every query.
# =============================================================================

def multi_op(table: str):
    pass   # replace with your code


# =============================================================================
# EXERCISE 6 — Confirm close with is_connected()
# =============================================================================
# Task:
#   Write a function called verify_close() that:
#     a. Opens a connection. Prints is_connected() → True
#     b. Closes it inside a finally block (no exception needed — just finally)
#     c. After the try/finally, prints is_connected() → False
#
#   conn must be accessible after the try/finally block,
#   so declare it as conn = None BEFORE the try.
#
# Expected output:
#   before close: True
#   after close:  False
# =============================================================================

def verify_close():
    pass   # replace with your code


# =============================================================================
# RUN ALL
# =============================================================================

if __name__ == "__main__":
    print("=" * 50)
    print("EXERCISE 1 — Prove finally always runs")
    print("=" * 50)
    prove_finally()

    print("\n" + "=" * 50)
    print("EXERCISE 2 — finally runs even with return")
    print("=" * 50)
    result = return_with_finally()
    print(f"Return value received: {result}")

    print("\n" + "=" * 50)
    print("EXERCISE 3 — conn = None guard")
    print("=" * 50)
    safe_bad_password()

    print("\n" + "=" * 50)
    print("EXERCISE 4 — Wrap unsafe_fetch safely")
    print("=" * 50)
    rows = safe_fetch()
    print(f"Rows returned: {rows}")

    print("\n" + "=" * 50)
    print("EXERCISE 5 — Multiple operations, one finally")
    print("=" * 50)
    multi_op("employees")

    print("\n" + "=" * 50)
    print("EXERCISE 6 — Verify close with is_connected()")
    print("=" * 50)
    verify_close()