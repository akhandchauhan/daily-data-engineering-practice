# =============================================================================
# DAY 1 — MySQL + Python for Data Engineering
# Topic  : Installing the library + Connection object
# Goal   : Open a TCP connection from Python to MySQL and confirm it works
# =============================================================================

# =============================================================================
# SETUP — Run this once in your terminal before anything else
# =============================================================================
#   pip install mysql-connector-python
#
# What this installs:
#   A pure-Python driver that lets Python talk to MySQL over TCP.
#   Without it, Python has no idea what MySQL is.
# =============================================================================


import mysql.connector


# =============================================================================
# CONCEPT 1 — mysql.connector.connect(**config)
# =============================================================================
# This function opens a TCP socket from your Python script to the MySQL server.
# Think of it like dialling a phone number — until this call succeeds,
# Python and MySQL cannot communicate at all.
#
# You pass connection details as keyword arguments.
# Storing them in a dict and unpacking with ** is the standard pattern —
# it keeps all credentials in one place and makes the connect() call clean.
#
# Python tip — the ** operator:
#   def f(host, port, user): ...
#   config = {"host": "localhost", "port": 3306, "user": "root"}
#   f(**config)   ← same as   f(host="localhost", port=3306, user="root")
# =============================================================================

DB_CONFIG = {
    "host":     "localhost",   # MySQL server address (IP or hostname)
    "port":     3306,          # default MySQL port
    "user":     "root",        # your MySQL username
    "password": "asd123",      # your MySQL password
    "database": "sql_practice" # the schema you want to connect to
}


def get_connection():
    """Opens and returns a MySQL connection. Caller must close it."""
    conn = mysql.connector.connect(**DB_CONFIG)
    return conn


# =============================================================================
# CONCEPT 2 — conn.is_connected() and conn.server_info
# =============================================================================
# After connect(), you can ask the connection object about itself:
#
#   conn.is_connected()  → True / False  — is the TCP socket still alive?
#   conn.server_info     → e.g. "8.0.32" — MySQL server version string
#
# In a DE pipeline you often check is_connected() before sending queries,
# especially after a long-running transformation that might have timed out.
# =============================================================================

def run_demo():
    conn = get_connection()

    print(f"Connected?    {conn.is_connected()}")   # True
    print(f"MySQL version: {conn.server_info}")

    conn.close()
    print(f"After close:  {conn.is_connected()}")   # False


# =============================================================================
# EXERCISE — Your task for today
# =============================================================================
# 1. Fill in DB_CONFIG above with your MySQL credentials.
# 2. Run the script.  You should see:
#      Connected?     True
#      MySQL version: 8.x.x   (or whatever version you have)
#      After close:   False
# 3. Try changing the password to something wrong.
#    What happens?  (We handle that properly on Day 3.)
# =============================================================================

if __name__ == "__main__":
    run_demo()