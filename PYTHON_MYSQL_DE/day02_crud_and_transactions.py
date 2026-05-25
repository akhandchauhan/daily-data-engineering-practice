# =============================================================================
# DAY 2 — MySQL + Python for Data Engineering
# Topic  : CRUD Operations, Parameterized Queries & Transactions
# Goal   : Write safe INSERT/UPDATE/DELETE and control commits correctly
# =============================================================================

import mysql.connector
from mysql.connector import Error

DB_CONFIG = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "asd123",
    "database": "sql_practice",
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


# =============================================================================
# SETUP — Run this once to create a practice table
# =============================================================================
# Since you already know MySQL well, here is just the DDL:
#
#   CREATE TABLE IF NOT EXISTS employees (
#       id        INT AUTO_INCREMENT PRIMARY KEY,
#       name      VARCHAR(100) NOT NULL,
#       dept      VARCHAR(50),
#       salary    DECIMAL(10,2),
#       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
#   );


# =============================================================================
# CONCEPT 1 — Parameterized Queries  (NEVER use f-strings for SQL)
# =============================================================================
# BAD  — opens SQL injection:
#   name = "Alice'; DROP TABLE employees; --"
#   cursor.execute(f"INSERT INTO employees (name) VALUES ('{name}')")
#
# GOOD — use %s placeholders. The connector escapes the values for you.
#   cursor.execute("INSERT INTO employees (name) VALUES (%s)", (name,))
#
# Rules:
#   - Always use %s for values, regardless of the Python data type.
#   - Pass values as a TUPLE (or list). Even a single value needs the comma:
#     ("Alice",)  ← tuple     vs   ("Alice")  ← just a string, not a tuple
# =============================================================================


def insert_one(conn, name: str, dept: str, salary: float) -> int:
    """
    Inserts one employee row.
    Returns the auto-generated primary key (lastrowid).
    """
    sql = """
        INSERT INTO employees (name, dept, salary)
        VALUES (%s, %s, %s)
    """
    cursor = conn.cursor()
    cursor.execute(sql, (name, dept, salary))   # values as a tuple
    conn.commit()                                # persist to disk
    new_id = cursor.lastrowid                    # MySQL-assigned PK
    cursor.close()
    print(f"Inserted id={new_id}  name={name}")
    return new_id


# =============================================================================
# CONCEPT 2 — commit() and rollback()
# =============================================================================
# mysql.connector sets autocommit=False by default.
# That means every INSERT/UPDATE/DELETE is inside an implicit transaction
# until YOU call conn.commit() or conn.rollback().
#
# Why this matters in DE pipelines:
#   - You load 10 000 rows. Row 7 312 violates a constraint.
#   - Without explicit rollback: some rows are in, some are not → data corruption.
#   - With rollback: either ALL rows land or NONE do → clean, retryable state.
#
# Pattern to memorise:
#
#   try:
#       ... do work ...
#       conn.commit()       # only if everything succeeded
#   except Exception:
#       conn.rollback()     # undo everything since last commit
#       raise
# =============================================================================


def insert_batch(conn, rows: list[dict]) -> None:
    """
    Inserts a list of employee dicts atomically.
    If any single row fails, the entire batch is rolled back.

    rows = [
        {"name": "Alice", "dept": "Eng",  "salary": 90000},
        {"name": "Bob",   "dept": "Data", "salary": 85000},
    ]
    """
    sql = """
        INSERT INTO employees (name, dept, salary)
        VALUES (%s, %s, %s)
    """
    # Python tip — enumerate(iterable, start=1) gives (index, value) pairs.
    # Useful when you want to log which row number failed.

    cursor = conn.cursor()
    try:
        for i, row in enumerate(rows, start=1):
            cursor.execute(sql, (row["name"], row["dept"], row["salary"]))
            print(f"  [{i}/{len(rows)}] staged: {row['name']}")

        conn.commit()                       # all rows OK → persist
        print(f"Batch committed: {cursor.rowcount} rows affected")

    except Exception as e:
        conn.rollback()                     # something failed → undo all
        print(f"Batch rolled back due to: {e}")
        raise                               # re-raise so the caller knows

    finally:
        cursor.close()


# =============================================================================
# CONCEPT 3 — UPDATE and DELETE (same parameterized pattern)
# =============================================================================


def update_salary(conn, emp_id: int, new_salary: float) -> int:
    """Returns number of rows actually updated (cursor.rowcount)."""
    sql = "UPDATE employees SET salary = %s WHERE id = %s"
    cursor = conn.cursor()
    try:
        cursor.execute(sql, (new_salary, emp_id))
        conn.commit()
        affected = cursor.rowcount          # 0 if id didn't exist
        print(f"Updated {affected} row(s) — id={emp_id} salary={new_salary}")
        return affected
    except Exception as e:
        conn.rollback()
        print(f"Update rolled back: {e}")
        raise
    finally:
        cursor.close()


def delete_employee(conn, emp_id: int) -> int:
    """Returns number of rows deleted."""
    sql = "DELETE FROM employees WHERE id = %s"
    cursor = conn.cursor()
    try:
        cursor.execute(sql, (emp_id,))      # (emp_id,) ← single-value tuple
        conn.commit()
        affected = cursor.rowcount
        print(f"Deleted {affected} row(s) — id={emp_id}")
        return affected
    except Exception as e:
        conn.rollback()
        print(f"Delete rolled back: {e}")
        raise
    finally:
        cursor.close()


# =============================================================================
# CONCEPT 4 — Reading back what you wrote (SELECT after DML)
# =============================================================================


def fetch_all_employees(conn) -> list[dict]:
    """Returns all employees as a list of dicts (dictionary cursor)."""
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, name, dept, salary FROM employees ORDER BY id")
    rows = cursor.fetchall()
    cursor.close()
    return rows


# =============================================================================
# DEMO — Runs all concepts end-to-end
# =============================================================================


def run_demo():
    conn = None
    try:
        conn = get_connection()
        print(f"Connected: {conn.is_connected()}\n")

        # --- Single insert ---
        print("=== Single Insert ===")
        new_id = insert_one(conn, "Alice", "Engineering", 90000.00)

        # --- Batch insert (all-or-nothing) ---
        print("\n=== Batch Insert ===")
        batch = [
            {"name": "Bob",   "dept": "Data",      "salary": 85000},
            {"name": "Carol", "dept": "Data",       "salary": 88000},
            {"name": "Dave",  "dept": "Engineering","salary": 92000},
        ]
        insert_batch(conn, batch)

        # --- UPDATE ---
        print("\n=== Update ===")
        update_salary(conn, new_id, 95000.00)

        # --- SELECT ---
        print("\n=== All Employees ===")
        for emp in fetch_all_employees(conn):
            print(emp)

        # --- DELETE ---
        print("\n=== Delete ===")
        delete_employee(conn, new_id)

        # --- Final state ---
        print("\n=== Final State ===")
        for emp in fetch_all_employees(conn):
            print(emp)

        # --- Simulate a bad batch (will rollback) ---
        print("\n=== Bad Batch (triggers rollback) ===")
        bad_batch = [
            {"name": "Eve",   "dept": "Ops",  "salary": 70000},
            {"name": None,    "dept": "Ops",  "salary": 70000},  # NULL name → error
        ]
        try:
            insert_batch(conn, bad_batch)
        except Exception:
            print("Confirmed: bad batch was rolled back, no partial writes.")
        transfer_dept(conn, 1, 'Data')
    except Error as e:
        print(f"MySQL Error: {e}")

    finally:
        if conn and conn.is_connected():
            conn.close()
            print("\nConnection closed.")


# =============================================================================
# EXERCISE — Your task for today
# =============================================================================
# 1. Create the employees table in sql_practice (DDL in CONCEPT 0 above).
# 2. Run the demo and observe:
#      - cursor.lastrowid after INSERT
#      - cursor.rowcount after UPDATE / DELETE
#      - The rollback kicking in for the bad batch
# 3. Write a new function  transfer_dept(conn, emp_id, new_dept)  that:
#      a. Checks the employee exists (SELECT)  — if not, raise ValueError
#      b. Updates their dept
#      c. Inserts a row into an audit_log table:
#            (emp_id, old_dept, new_dept, changed_at TIMESTAMP)
#      d. Both the UPDATE and the audit INSERT happen in ONE transaction —
#         either both commit or both roll back.
#    Hint: don't call commit() after each statement — call it once at the end.
# =============================================================================

def transfer_dept(conn, emp_id : int, new_dept :str):
        
        sql = """
            SELECT emp_id
            FROM employees
            WHERE emp_id = %s
        """
        cursor = conn.cursor()
        cursor = cursor.execute(sql,(emp_id,))
        rows = cursor.fetchall(dictionary = True)
        
        if rows: 
            
        print(rows)
        
    
if __name__ == "__main__":
    run_demo()