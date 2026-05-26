# Python + MySQL for Data Engineering — 30-Day Curriculum
**Audience:** Advanced MySQL | Python Beginner (with Pandas exposure)
**Goal:** Build real Data Engineering pipelines step by step
**Format:** 30 min/day | 2 concepts/day | Concept → Code → Exercise

## FILE STRUCTURE PER DAY
Each day has two files:
- `dayXX_topic.py` — concept file: explanations, examples, runnable demo
- `dayXX_exercise.py` — exercise file: 6 tasks with `pass` stubs to fill in

---

## THREAD MAP

```
Days 01–05  →  Connection & Setup
Days 06–12  →  Cursors & SELECT
Days 13–18  →  CRUD + Safe Writes
Days 19–22  →  Transactions
Days 23–26  →  Context Managers + Streaming
Days 27–30  →  Batch Inserts + Capstone
```

---

## DAY-BY-DAY BREAKDOWN

---

### DAY 01 — Installing the Library + Connection Object
**Files:** `day01_connection.py` · `day01_exercise.py`
**Concepts:**
1. `pip install mysql-connector-python` — what it is and why you need it
2. `mysql.connector.connect(**config)` — opening a TCP connection to MySQL

**Python tip:** Dictionaries as function arguments with `**`

**Exercises (6):**
1. Basic connect and confirm — print `is_connected()` and `server_info`
2. Connect without a dict — pass credentials as direct keyword args
3. Two connections — print `CONNECTION_ID()` for each, observe they differ
4. Reconnect after close — close and re-open a fresh connection
5. Connect without a database — see what `SELECT DATABASE()` returns
6. Connection metadata — print `conn.user`, `conn.server_host`, `conn.database`

---

### DAY 02 — Closing Connections Safely
**File:** `day02_close_safely.py`
**Concepts:**
1. Why unclosed connections are dangerous in pipelines (connection leaks)
2. `try / finally` pattern — conn.close() always runs, even on crash

**Python tip:** `finally` block always executes regardless of exception

**Exercise:** Deliberately raise an exception inside a `try` block and verify `finally` still closes the connection.

---

### DAY 03 — Handling MySQL Errors
**File:** `day03_error_handling.py`
**Concepts:**
1. `from mysql.connector import Error` — the base exception class
2. `except Error as e: print(e)` — catching and reading MySQL errors

**Python tip:** `except ExceptionType as e` — naming the exception object

**Exercise:** Try connecting with a wrong password. Catch the error and print a friendly message.

---

### DAY 04 — Default Cursor (Tuples)
**File:** `day04_default_cursor.py`
**Concepts:**
1. What a cursor is — the messenger between Python and MySQL
2. `conn.cursor()` → default cursor returns rows as **tuples**

**Python tip:** Tuple unpacking — `id, name, dept = row`

**Exercise:** `SHOW TABLES` and `SELECT` 5 rows from any table. Print each row. Access values by index.

---

### DAY 05 — Dictionary Cursor
**File:** `day05_dictionary_cursor.py`
**Concepts:**
1. `conn.cursor(dictionary=True)` → rows as **dicts** with column names
2. When to prefer dict cursor over default cursor in DE pipelines

**Python tip:** `dict.get(key, default)` — safe key access without KeyError

**Exercise:** Run the same SELECT as Day 4 with a dict cursor. Access values by column name instead of index.

---

### DAY 06 — Buffered Cursor
**File:** `day06_buffered_cursor.py`
**Concepts:**
1. `conn.cursor(buffered=True)` — all rows loaded into memory immediately
2. When you need buffered: running a second query before consuming the first

**Python tip:** What "consuming" an iterator means in Python

**Exercise:** Open two cursors on the same connection. Show that default cursor raises `InternalError` when you open a second query mid-iteration, but buffered cursor does not.

---

### DAY 07 — cursor.execute() and SELECT
**File:** `day07_execute_and_select.py`
**Concepts:**
1. `cursor.execute(sql)` — sending SQL to MySQL
2. `cursor.fetchall()` — pulling all result rows into a Python list

**Python tip:** `for row in rows:` — iterating a list of tuples/dicts

**Exercise:** SELECT all rows from `employees`. Print the count using `len(rows)`.

---

### DAY 08 — fetchone() and fetchmany()
**File:** `day08_fetchone_fetchmany.py`
**Concepts:**
1. `cursor.fetchone()` — pull exactly one row; returns `None` when exhausted
2. `cursor.fetchmany(size=N)` — pull N rows at a time

**Python tip:** `while row := cursor.fetchone():` — walrus operator `:=`

**Exercise:** Use `fetchone()` in a while loop to print all rows one at a time. Then repeat using `fetchmany(size=3)`.

---

### DAY 09 — cursor.description
**File:** `day09_cursor_description.py`
**Concepts:**
1. `cursor.description` — tuple of column metadata after a SELECT
2. Extracting column names: `[desc[0] for desc in cursor.description]`

**Python tip:** List comprehensions — `[expr for item in iterable]`

**Exercise:** Write a function `get_columns(conn, table)` that returns a list of column names without hardcoding them.

---

### DAY 10 — Parameterized Queries (the most important safety rule)
**File:** `day10_parameterized_queries.py`
**Concepts:**
1. Why f-strings in SQL = SQL injection vulnerability
2. `cursor.execute(sql, (value,))` — `%s` placeholders, values as a tuple

**Python tip:** Single-element tuple needs a trailing comma: `(value,)` not `(value)`

**Exercise:** Write an INSERT using an f-string (see why it's dangerous). Rewrite it with `%s`. Try passing a name with a `'` apostrophe — the parameterized version handles it cleanly.

---

### DAY 11 — INSERT + cursor.lastrowid
**File:** `day11_insert.py`
**Concepts:**
1. `cursor.execute(INSERT sql, values_tuple)` — writing a row
2. `cursor.lastrowid` — the auto-generated primary key of the row you just inserted

**Python tip:** `conn.commit()` — you must commit after writes (covered more in Day 19)

**Exercise:** Insert 3 employees one at a time. Print the `lastrowid` after each insert.

---

### DAY 12 — UPDATE + DELETE + cursor.rowcount
**File:** `day12_update_delete.py`
**Concepts:**
1. `cursor.execute(UPDATE/DELETE sql, values_tuple)` — modifying/removing rows
2. `cursor.rowcount` — how many rows were actually affected

**Python tip:** Comparing `rowcount == 0` to detect "nothing changed"

**Exercise:** Update a salary. If `rowcount == 0`, print "Employee not found". Delete a row and confirm with rowcount.

---

### DAY 13 — autocommit and why it's off by default
**File:** `day13_autocommit.py`
**Concepts:**
1. `autocommit=False` is mysql-connector's default — every write is in a transaction
2. `conn.commit()` — persist changes to disk permanently

**Python tip:** Default parameter values in function definitions

**Exercise:** Insert a row. Without calling `commit()`, open a new connection and verify the row is NOT visible. Then commit and verify it IS.

---

### DAY 14 — conn.rollback()
**File:** `day14_rollback.py`
**Concepts:**
1. `conn.rollback()` — undo all writes since the last commit
2. The `try / except / rollback` pattern — the foundation of safe DE writes

**Python tip:** `raise` (bare) inside an except block — re-raise the original exception

**Exercise:** Insert a valid row and an invalid row (e.g. NULL in a NOT NULL column) in sequence. Rollback on error. Verify neither row landed.

---

### DAY 15 — Atomic Batch Inserts
**File:** `day15_atomic_batch.py`
**Concepts:**
1. Wrapping multiple inserts in one transaction — all succeed or all fail
2. `for i, row in enumerate(rows, start=1)` — tracking which row failed

**Python tip:** `enumerate(iterable, start=N)` — get index + value together

**Exercise:** Insert a list of 5 dicts atomically. Introduce a bad row at position 3. Confirm the whole batch rolls back (0 rows in table).

---

### DAY 16 — `with` Statement Internals
**File:** `day16_with_statement.py`
**Concepts:**
1. What the `with` statement does — `__enter__` and `__exit__`
2. How `__exit__` guarantees cleanup even on exception

**Python tip:** Context managers work on any object that defines `__enter__`/`__exit__`

**Exercise:** Write your own tiny context manager class `Timer` that prints elapsed time on exit. Use it with a `with` block.

---

### DAY 17 — Cursor as Context Manager
**File:** `day17_cursor_context_manager.py`
**Concepts:**
1. `with conn.cursor() as cur:` — cursor auto-closes when the block ends
2. Why this is safer than manual `cursor.close()` in a finally block

**Python tip:** Nesting `with` statements — `with A as a, B as b:`

**Exercise:** Rewrite the Day 11 INSERT function using `with conn.cursor() as cur:`. Verify the cursor is closed after the block using `cur.is_closed()`.

---

### DAY 18 — yield and Generator Functions
**File:** `day18_generators.py`
**Concepts:**
1. `yield` — pauses a function and hands a value to the caller
2. Generator functions return a generator object; body runs lazily on demand

**Python tip:** `next(gen)` vs `for x in gen:` — two ways to consume a generator

**Exercise:** Write `count_up(n)` — a generator that yields 0, 1, 2 … n-1. Loop over it with `for`. Then manually call `next()` on a fresh one and catch `StopIteration`.

---

### DAY 19 — Streaming Large Tables with fetchmany + Generator
**File:** `day19_streaming_fetchmany.py`
**Concepts:**
1. Why `fetchall()` kills pipelines on large tables (OOM)
2. `stream_table(conn, table, chunk_size)` — generator using `fetchmany`

**Python tip:** `while True: ... if not chunk: break` — the canonical fetchmany loop

**Exercise:** Write `stream_table()`. Run it on `employees` with `chunk_size=2`. Print each chunk and the running row total. Confirm total matches `SELECT COUNT(*)`.

---

### DAY 20 — cursor.executemany()
**File:** `day20_executemany.py`
**Concepts:**
1. `cursor.executemany(sql, list_of_tuples)` — insert many rows in one call
2. Why `executemany` is 10–100x faster than a Python loop of `execute()`

**Python tip:** List of tuples vs list of dicts — executemany needs tuples

**Exercise:** Insert 1000 rows with a loop (`execute` in a for loop) and time it with `time.perf_counter()`. Repeat with `executemany`. Print rows/sec for each.

---

### DAY 21 — INSERT IGNORE vs UPSERT
**File:** `day21_insert_ignore_upsert.py`
**Concepts:**
1. `INSERT IGNORE` — silently skip duplicate key violations
2. `INSERT ... ON DUPLICATE KEY UPDATE` — upsert: insert or update in one statement

**Python tip:** Multi-line strings for SQL readability — triple-quoted `""" """`

**Exercise:** Insert the same row twice. With `INSERT IGNORE` verify no error and only 1 row. With `ON DUPLICATE KEY UPDATE` verify the row is updated.

---

### DAY 22 — Loading a CSV into MySQL
**File:** `day22_csv_to_mysql.py`
**Concepts:**
1. Python `csv.DictReader` — read a CSV file row by row as dicts
2. Combine with `executemany` to bulk-load CSV → MySQL

**Python tip:** `open(file, newline='')` — the correct way to open CSVs on Windows

**Exercise:** Download any small CSV (sales, flights, etc). Load it into a new MySQL table using `csv.DictReader` + `executemany`. Verify row count.

---

### DAY 23 — Pandas read_csv with chunksize
**File:** `day23_pandas_chunked_csv.py`
**Concepts:**
1. `pd.read_csv(file, chunksize=N)` — returns an iterator of DataFrames, not one big DF
2. Processing each chunk: clean → insert → move to next chunk

**Python tip:** `df.itertuples()` vs `df.to_records()` — converting DataFrame rows to tuples

**Exercise:** Read a CSV in chunks of 100. For each chunk, strip whitespace from string columns and insert into MySQL with `executemany`.

---

### DAY 24 — SQLAlchemy Engine (Pandas ↔ MySQL bridge)
**File:** `day24_sqlalchemy_engine.py`
**Concepts:**
1. Why Pandas needs SQLAlchemy — `pd.read_sql` doesn't accept raw mysql-connector
2. `sqlalchemy.create_engine("mysql+mysqlconnector://user:pass@host/db")`

**Python tip:** Connection string format — protocol://user:password@host:port/database

**Exercise:** Create a SQLAlchemy engine. Use `pd.read_sql("SELECT * FROM employees", engine)` and print the resulting DataFrame.

---

### DAY 25 — pd.read_sql + df.to_sql
**File:** `day25_pandas_mysql.py`
**Concepts:**
1. `pd.read_sql(query, engine)` — MySQL → DataFrame in one line
2. `df.to_sql(table, engine, if_exists='append', index=False)` — DataFrame → MySQL

**Python tip:** `df.info()` and `df.dtypes` — quick schema inspection

**Exercise:** Pull `employees` into a DataFrame. Add a new column `salary_usd = salary * 0.012`. Write it to a new table `employees_usd`. Verify with a COUNT query.

---

### DAY 26 — Python json Module
**File:** `day26_json_module.py`
**Concepts:**
1. `json.loads(string)` / `json.dumps(obj)` — parse and serialize JSON in memory
2. `json.load(file)` / `json.dump(obj, file)` — read/write JSON files

**Python tip:** `json.dumps(obj, indent=2, default=str)` — the `default=str` trick for datetimes

**Exercise:** Create a Python dict with a `datetime` value. Dump it to JSON (use `default=str`). Load it back and print each key-value pair.

---

### DAY 27 — MySQL JSON Column
**File:** `day27_mysql_json_column.py`
**Concepts:**
1. MySQL `JSON` column type — store arbitrary JSON without a fixed schema
2. Querying JSON: `JSON_EXTRACT(col, '$.key')` and the `->` / `->>` shorthand

**Python tip:** `json.dumps(dict)` to serialize before inserting into a JSON column

**Exercise:** Create a table with a JSON column. Insert a Python dict (serialized). Query it back with `JSON_EXTRACT`. Verify the value matches.

---

### DAY 28 — Public REST APIs with requests
**File:** `day28_rest_api_basics.py`
**Concepts:**
1. `requests.get(url, params={})` — anatomy of an HTTP GET request
2. `response.raise_for_status()` + `response.json()` — check status and parse body

**Python tip:** `requests.Session()` — reuse TCP connection across multiple calls

**Exercise:** Call `https://httpbin.org/get?name=yourname` (public, no auth). Print the response JSON. Store the `origin` field in MySQL.

---

### DAY 29 — Secrets with python-dotenv
**File:** `day29_dotenv_secrets.py`
**Concepts:**
1. `.env` file format + `python-dotenv` — never hardcode secrets in source code
2. `os.getenv("KEY", default)` — reading env vars safely

**Python tip:** `.gitignore` — always add `.env` so secrets never reach git

**Exercise:** Store your MySQL password in `.env`. Update DB_CONFIG to read from `os.getenv()`. Verify the connection still works.

---

### DAY 30 — Capstone Mini-Pipeline
**File:** `day30_capstone_pipeline.py`
**Concepts:**
1. End-to-end: public API → JSON → MySQL (combining Days 28 + 26 + 27)
2. Idempotent run: re-running the script should not duplicate data (INSERT IGNORE or UPSERT)

**Python tip:** `if __name__ == "__main__":` — making a script both importable and runnable

**Exercise:** Call `https://httpbin.org/uuid` 10 times. Store each UUID + timestamp in MySQL. Run the script twice — verify no duplicate UUIDs in the table.

---

## SKILLS BUILT BY END OF DAY 30

| Skill | Days |
|---|---|
| MySQL connection lifecycle | 01–03 |
| All cursor types and when to use each | 04–06 |
| SELECT, fetchone, fetchall, fetchmany | 07–08 |
| Schema introspection with cursor.description | 09 |
| Safe parameterized queries (no SQL injection) | 10 |
| INSERT, UPDATE, DELETE + rowcount/lastrowid | 11–12 |
| Transactions: commit, rollback, atomicity | 13–15 |
| with statement and context managers | 16–17 |
| Generator functions and yield | 18 |
| Streaming large tables with fetchmany | 19 |
| Batch inserts with executemany | 20 |
| UPSERT and INSERT IGNORE patterns | 21 |
| CSV → MySQL loading | 22–23 |
| Pandas ↔ MySQL bridge (SQLAlchemy) | 24–25 |
| JSON: Python module + MySQL JSON column | 26–27 |
| Public REST API consumption | 28 |
| Secrets management with dotenv | 29 |
| End-to-end DE mini-pipeline | 30 |

---

## QUICK REFERENCE — Libraries Used

```
mysql-connector-python   # MySQL connection and cursors
sqlalchemy               # Pandas ↔ MySQL engine
pandas                   # DataFrames
requests                 # HTTP API calls
python-dotenv            # Secret management
```

Install all at once:
```bash
pip install mysql-connector-python sqlalchemy pandas requests python-dotenv
```