# =============================================================================
# DAY 3 — EXERCISES
# Topic  : Handling MySQL Errors
# Instructions: Work through each exercise in order.
#               Do NOT look at day03_error_handling.py while solving — try first.
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
    return mysql.connector.connect(**DB_CONFIG)


# =============================================================================
# EXERCISE 1 — Catch a wrong-password error
# =============================================================================
# Task:
#   Write a function called wrong_password() that:
#     a. Builds a config dict with a WRONG password (e.g. "badpass")
#     b. Tries to connect with it
#     c. Catches the Error and prints:
#        "Login failed: <e.msg>"
#
# Expected output (exact message varies by MySQL version):
#   Login failed: Access denied for user 'root'@'localhost' (using password: YES)
#
# Key observation: MySQL returns error number 1045 for auth failures.
# =============================================================================

def wrong_password():
    pass


# =============================================================================
# EXERCISE 2 — Catch a bad database name
# =============================================================================
# Task:
#   Write a function called bad_database() that:
#     a. Builds a config dict pointing to a database that doesn't exist
#        (e.g. "database": "ghost_db")
#     b. Tries to connect
#     c. Catches the Error and prints:
#        "errno=<e.errno>  msg=<e.msg>"
#
# Expected output:
#   errno=1049  msg=Unknown database 'ghost_db'
#
# Key observation: errno 1049 means unknown database.
# =============================================================================

def bad_database():
    pass


# =============================================================================
# EXERCISE 3 — Catch a bad SQL query
# =============================================================================
# Task:
#   Write a function called bad_query() that:
#     a. Opens a real connection (use get_connection())
#     b. Creates a cursor
#     c. Executes intentionally broken SQL: "SELEKT * FORM employees"
#     d. Catches the Error and prints:
#        "SQL error <e.errno>: <e.msg>"
#     e. Always closes the connection in finally
#
# Expected output:
#   SQL error 1064: You have an error in your SQL syntax ...
# =============================================================================

def bad_query():
    pass


# =============================================================================
# EXERCISE 4 — Read all three error attributes
# =============================================================================
# Task:
#   Write a function called show_error_attrs() that:
#     a. Tries to connect with a wrong password
#     b. In the except block, prints ALL three attributes on separate lines:
#        "errno    : <value>"
#        "msg      : <value>"
#        "sqlstate : <value>"
#
# Expected output:
#   errno    : 1045
#   msg      : Access denied for user ...
#   sqlstate : 28000
#
# Key observation: sqlstate "28000" is the ANSI code for auth failure —
# it's the same across MySQL, PostgreSQL, and other SQL databases.
# =============================================================================

def show_error_attrs():
    pass


# =============================================================================
# EXERCISE 5 — Branch on errno
# =============================================================================
# Task:
#   Write a function called smart_connect(host, user, password, database) that:
#     a. Tries to connect with the given credentials
#     b. Returns the connection object on success
#     c. On Error, checks e.errno and prints a SPECIFIC friendly message:
#        - errno 1045  →  "Wrong username or password."
#        - errno 1049  →  "Database '<database>' not found."
#        - errno 2003  →  "Cannot reach MySQL at <host>. Check host/port."
#        - anything else → "MySQL error <e.errno>: <e.msg>"
#     d. Returns None on any error
#
# Test it by calling:
#   smart_connect("localhost", "root", "badpass",    "sql_practice")  → wrong pw
#   smart_connect("localhost", "root", "asd123",     "ghost_db")      → bad db
#   smart_connect("localhost", "root", "asd123",     "sql_practice")  → success
# =============================================================================

def smart_connect(host, user, password, database):
    pass


# =============================================================================
# EXERCISE 6 — Combine Error handling with try / finally
# =============================================================================
# Task:
#   Write a function called safe_query(sql) that:
#     a. Opens a connection (get_connection())
#     b. In try: creates a cursor, executes the given sql, fetches all rows,
#        closes the cursor, and returns the rows
#     c. In except Error: prints "Query failed: <e.msg>" and returns []
#     d. In finally: always closes the connection if open
#
# Test it with:
#   safe_query("SELECT id, name FROM employees LIMIT 3")  → returns rows
#   safe_query("SELECT * FROM no_such_table")             → prints error, returns []
#
# Key observation: This is the production-ready pattern — error handling +
# connection cleanup in one function.
# =============================================================================

def safe_query(sql):
    pass


# =============================================================================
# RUN ALL
# =============================================================================

if __name__ == "__main__":
    print("=" * 50)
    print("EXERCISE 1 — Catch wrong-password error")
    print("=" * 50)
    wrong_password()

    print("\n" + "=" * 50)
    print("EXERCISE 2 — Catch bad database name")
    print("=" * 50)
    bad_database()

    print("\n" + "=" * 50)
    print("EXERCISE 3 — Catch bad SQL query")
    print("=" * 50)
    bad_query()

    print("\n" + "=" * 50)
    print("EXERCISE 4 — Read all error attributes")
    print("=" * 50)
    show_error_attrs()

    print("\n" + "=" * 50)
    print("EXERCISE 5 — Branch on errno")
    print("=" * 50)
    smart_connect("localhost", "root", "badpass",  "sql_practice")
    smart_connect("localhost", "root", "asd123",   "ghost_db")
    conn = smart_connect("localhost", "root", "asd123", "sql_practice")
    if conn:
        print("Connected successfully!")
        conn.close()

    print("\n" + "=" * 50)
    print("EXERCISE 6 — safe_query with Error + finally")
    print("=" * 50)
    rows = safe_query("SELECT id, name FROM employees LIMIT 3")
    print(f"Rows: {rows}")
    empty = safe_query("SELECT * FROM no_such_table")
    print(f"Rows: {empty}")