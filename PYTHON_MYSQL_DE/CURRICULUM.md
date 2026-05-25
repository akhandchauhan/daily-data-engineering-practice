# Python + MySQL for Data Engineering — 15-Day Curriculum
**Audience:** Advanced MySQL | Python Beginner (with Pandas exposure)
**Goal:** Build real Data Engineering pipelines — cursors, APIs, JSON, NumPy, schema validation
**Format:** 30 min/day | Concept → Code → Exercise

---

## THREAD MAP

```
Days 01–06  →  MySQL Cursors (beginner → advanced)
Days 07–09  →  JSON & NumPy Arrays (no-schema + schema)
Days 10–13  →  API Integration (public, authenticated, third-party)
Days 14–15  →  Python DE Tips & Tricks + Capstone Pipeline
```

---

## DAY-BY-DAY BREAKDOWN

---

### DAY 01 ✅ — Connection Object & Cursor Types
**Status:** Complete
**Topics covered:**
- `mysql.connector.connect()` — opening a TCP connection
- Default cursor (tuples), Dictionary cursor (dicts), Buffered cursor
- `try/finally` pattern for safe connection cleanup
- When to pick which cursor in a DE pipeline

---

### DAY 02 — CRUD + Parameterized Queries + Transactions
**File:** `day02_crud_and_transactions.py`
**Topics:**
- INSERT, UPDATE, DELETE via cursor
- Parameterized queries with `%s` placeholders (prevents SQL injection)
- `conn.commit()` and `conn.rollback()` — why autocommit is dangerous in pipelines
- Practical pattern: insert a batch, rollback if any row fails
- `cursor.lastrowid`, `cursor.rowcount`

**Python tips introduced:**
- f-strings vs `%s` placeholders — never use f-strings in SQL
- `enumerate()` in loops

**Exercise:** Write a function that inserts a list of dicts into a table;
rollback the entire batch if any single insert fails.

---

### DAY 03 — Cursor as Context Manager + Streaming with `fetchmany`
**File:** `day03_context_manager_and_fetchmany.py`
**Topics:**
- `with conn.cursor() as cur:` — context manager pattern (auto-close)
- `fetchone()` vs `fetchall()` vs `fetchmany(size=N)` — memory tradeoffs
- Generator pattern: yield rows from `fetchmany` for lazy evaluation
- Why `fetchall()` kills a DE pipeline on a 10M-row table
- `cursor.description` — reading column names programmatically

**Python tips introduced:**
- `yield` and generator functions
- `with` statement internals (`__enter__`, `__exit__`)

**Exercise:** Write a generator that streams any table in chunks of 500 rows
and prints total rows processed without loading everything into memory.

---

### DAY 04 — Batch Inserts with `executemany` + Loading CSV → MySQL
**File:** `day04_executemany_and_csv_load.py`
**Topics:**
- `cursor.executemany(sql, list_of_tuples)` — 10-100x faster than a loop
- Loading a CSV file into MySQL in chunks (Pandas `read_csv(chunksize=N)`)
- `INSERT IGNORE` vs `INSERT ... ON DUPLICATE KEY UPDATE` (UPSERT)
- Timing your inserts — `time.perf_counter()`

**Python tips introduced:**
- `csv` module basics
- Pandas `read_csv` with `chunksize` returns an iterator, not a DataFrame
- `time.perf_counter()` for benchmarking

**Exercise:** Download any CSV (e.g., flights, sales), load it to MySQL in 1000-row
chunks using executemany. Print rows/sec throughput.

---

### DAY 05 — SSCursor (Server-Side Streaming) for Large Datasets
**File:** `day05_sscursor_large_tables.py`
**Topics:**
- Problem: `cursor.fetchall()` on 5M rows = OOM crash
- `MySQLCursorBufferedRaw` vs `MySQLCursorSS` (SSCursor)
- How SSCursor keeps rows on the MySQL server, fetches one at a time
- Trade-off: SSCursor blocks the connection until fully consumed
- When to use SSCursor in a DE pipeline (exports, transformations)

**Python tips introduced:**
- `sys.getsizeof()` — measuring object memory
- `itertools.islice()` — take N rows from any iterator

**Exercise:** Compare memory usage of `fetchall()` vs SSCursor on a large table
using `tracemalloc`. Print peak memory for each approach.

---

### DAY 06 — Pandas ↔ MySQL (read_sql, to_sql, chunked reads)
**File:** `day06_pandas_mysql_bridge.py`
**Topics:**
- `pd.read_sql(query, conn)` — MySQL → DataFrame in one line
- `df.to_sql(table, engine, if_exists='append')` — DataFrame → MySQL
- SQLAlchemy engine vs raw connector (why Pandas needs SQLAlchemy)
- Chunked reads: `pd.read_sql(query, conn, chunksize=N)` returns iterator
- Type mapping: MySQL → Pandas dtype, datetime handling

**Python tips introduced:**
- `sqlalchemy.create_engine()` connection string format
- `pd.concat()` to merge chunks
- `df.dtypes` and `df.info()` for quick schema inspection

**Exercise:** Pull a MySQL table into Pandas, clean one column (strip whitespace,
fix nulls), write it back to a new table. Verify with a COUNT query.

---

### DAY 07 — JSON Basics + Storing Schema-less JSON in MySQL
**File:** `day07_json_no_schema.py`
**Topics:**
- Python `json` module: `json.loads()`, `json.dumps()`, `json.load()`, `json.dump()`
- MySQL JSON column type — store arbitrary JSON without a fixed schema
- Querying JSON columns: `->`, `->>`, `JSON_EXTRACT()`
- Inserting a Python dict as JSON via cursor (serialize → store)
- When schema-less storage is right in DE (event logs, raw API responses)

**Python tips introduced:**
- `json.dumps(obj, indent=2, default=str)` — the `default=str` trick for datetimes
- Dict `.get()` with default vs `[]` — never crash on missing keys
- `collections.defaultdict`

**Exercise:** Call `http://httpbin.org/get` (public API, no auth), store the raw
JSON response in a MySQL JSON column. Query it back using `JSON_EXTRACT`.

---

### DAY 08 — JSON with Schema: `jsonschema` + Pydantic Validation
**File:** `day08_json_with_schema.py`
**Topics:**
- Why schema validation matters before writing to MySQL (garbage-in = garbage pipeline)
- `jsonschema` library: define a schema dict, call `validate(data, schema)`
- Pydantic `BaseModel`: declare types, get free validation + parsing
- Pattern: validate JSON at pipeline boundary, reject bad rows, log them
- `Optional`, `Union`, default values in Pydantic

**Python tips introduced:**
- Type hints: `str`, `int`, `Optional[str]`, `List[dict]`
- `dataclasses` vs Pydantic — when to use each
- `try/except ValidationError` pattern

**Exercise:** Fetch JSON from a public API. Define a Pydantic model for the
expected shape. Validate each record; insert valid rows to MySQL,
write invalid rows to a `_rejected` table with the error message.

---

### DAY 09 — NumPy Arrays + JSON: Serialize, Store, Reconstruct
**File:** `day09_numpy_json_storage.py`
**Topics:**
- Problem: `json.dumps(np.array([1,2,3]))` raises TypeError
- Custom JSON encoder for NumPy: `class NumpyEncoder(json.JSONEncoder)`
- Storing arrays in MySQL: JSON column (small arrays) vs BLOB (large)
- Reconstructing: JSON string → Python list → `np.array()`
- Real DE use case: storing model feature vectors, time-series snapshots

**Python tips introduced:**
- Subclassing `json.JSONEncoder` — `default()` method
- `np.frombuffer()` and `tobytes()` for binary storage
- `pickle` vs JSON for array serialization — trade-offs

**Exercise:** Generate a 100-element NumPy array (random floats). Store it in
MySQL as JSON. Retrieve it and verify `np.allclose(original, reconstructed)`.

---

### DAY 10 — Public REST APIs with `requests` (GET, Pagination, Rate Limits)
**File:** `day10_public_rest_apis.py`
**Topics:**
- `requests.get(url, params={}, headers={})` — anatomy of an HTTP request
- Checking status: `response.raise_for_status()`
- Pagination patterns: offset/limit, page number, cursor-based
- Rate limiting: `time.sleep()`, checking `Retry-After` header
- Writing a generic paginator function

**Python tips introduced:**
- `requests.Session()` — reuse TCP connection across calls
- `response.json()` vs `json.loads(response.text)` — same result, prefer `.json()`
- Exponential backoff with `time.sleep(2 ** attempt)`

**Exercise:** Paginate through all pages of `https://api.github.com/repos/pandas-dev/pandas/issues`
(public, no auth). Store issue number, title, created_at in MySQL.

---

### DAY 11 — Authenticated APIs: API Keys, Bearer Tokens, `.env` Secrets
**File:** `day11_authenticated_apis.py`
**Topics:**
- Never hardcode secrets — `python-dotenv` and `.env` files
- API key in header: `{"Authorization": "Bearer TOKEN"}`
- API key in query param: `?api_key=XXX`
- OAuth2 client credentials flow (concept + example with a real API)
- Refreshing tokens: detecting 401 and retrying

**Python tips introduced:**
- `os.environ.get()` vs `os.getenv()` — same, but `getenv` has a default
- `python-dotenv`: `load_dotenv()`, `.env` file format
- `requests.auth.HTTPBasicAuth`

**Exercise:** Sign up for a free API (OpenWeatherMap or NewsAPI — free tier).
Store your key in `.env`. Fetch today's data and insert it into MySQL.

---

### DAY 12 — Third-Party Data APIs → MySQL Pipeline (Financial / Weather / News)
**File:** `day12_third_party_api_pipeline.py`
**Topics:**
- End-to-end: API call → JSON → Pandas normalize → MySQL insert
- `pd.json_normalize()` — flatten nested JSON into tabular rows
- Handling API-specific quirks: missing fields, nested arrays, timestamps in epoch
- Idempotent inserts: UPSERT so re-running doesn't duplicate data
- Logging pipeline runs to a `pipeline_log` table

**Python tips introduced:**
- `pd.json_normalize(data, record_path=..., meta=...)` for nested JSON
- `datetime.utcfromtimestamp()` for epoch → datetime
- Python `logging` module basics (replace `print` in production)

**Exercise:** Build a pipeline that fetches hourly weather data for your city
(OpenWeatherMap free tier), normalizes it, and upserts into MySQL.
Run it twice — verify no duplicates.

---

### DAY 13 — Retry Logic, Deduplication, and Resilient Pipelines
**File:** `day13_resilient_pipeline_patterns.py`
**Topics:**
- `tenacity` library: `@retry(stop=stop_after_attempt(3), wait=wait_exponential())`
- Idempotency key pattern: store a `source_id` and use ON DUPLICATE KEY
- Dead-letter queue pattern: failed records → `_failed` table, not discarded
- Connection pooling with `mysql.connector.pooling.MySQLConnectionPool`
- Checkpoint pattern: resume a failed pipeline from where it stopped

**Python tips introduced:**
- `functools.wraps` — preserving function metadata in decorators
- Writing your own `@retry` decorator from scratch (understand the library)
- `atexit.register()` — cleanup on script exit

**Exercise:** Wrap your Day 12 pipeline with tenacity retry. Simulate a failure
by temporarily wrong API key. Verify the retry fires and logs each attempt.

---

### DAY 14 — Python DE Tips & Tricks (Power-ups for Every Pipeline)
**File:** `day14_python_tips_and_tricks.py`
**Topics:**
- `dataclasses` for config objects (cleaner than dicts)
- `pathlib.Path` — stop using string paths in 2025
- `argparse` basics — make your pipeline scripts CLI-ready
- `tqdm` — progress bars in loops and iterators
- `concurrent.futures.ThreadPoolExecutor` — parallel API calls (I/O-bound)
- Python walrus operator `:=` — useful in while-fetch loops
- `__slots__` on classes for memory efficiency in tight loops

**Python tips introduced:**
- `@dataclass(frozen=True)` for immutable config
- `Path(__file__).parent` — robust relative paths
- `*args`, `**kwargs` — when and how to use them

**Exercise:** Refactor your Day 12 pipeline: use a `@dataclass` for config,
`pathlib` for file paths, `argparse` for the city name, and `tqdm` for progress.

---

### DAY 15 — Capstone: Full DE Pipeline (API → Validate → Transform → MySQL)
**File:** `day15_capstone_pipeline.py`
**Topics (putting it all together):**
1. Fetch paginated data from an authenticated API (Day 10–11)
2. Validate each record against a Pydantic schema (Day 08) — reject bad rows
3. Normalize nested JSON with `pd.json_normalize` (Day 12)
4. Serialize any NumPy columns to JSON (Day 09)
5. Bulk-insert with `executemany` using a Dictionary cursor (Day 04)
6. UPSERT pattern for idempotency (Day 13)
7. Log pipeline run metadata to `pipeline_log` (Day 12)
8. Wrap with retry and connection pool (Day 13)

**Deliverable:** A single runnable script that ingests real API data end-to-end.
Demonstrates every major concept from the 15-day track.

---

## SKILLS BUILT BY END OF DAY 15

| Skill | Days |
|---|---|
| MySQL cursor types and when to use each | 01–05 |
| Safe connection lifecycle (try/finally, context managers, pooling) | 01, 03, 13 |
| Batch inserts and streaming large tables | 04, 05 |
| Pandas ↔ MySQL bridge | 06 |
| Schema-less JSON storage in MySQL | 07 |
| JSON schema validation with Pydantic | 08 |
| NumPy array serialization to/from MySQL | 09 |
| REST API consumption (public, authenticated, third-party) | 10–12 |
| Resilient pipeline patterns (retry, dead-letter, checkpointing) | 13 |
| Python DE best practices (logging, argparse, pathlib, tqdm) | 14 |
| End-to-end pipeline architecture | 15 |

---

## QUICK REFERENCE — Libraries Used

```
mysql-connector-python   # MySQL connection and cursors
sqlalchemy               # Pandas ↔ MySQL engine
pandas                   # DataFrames and json_normalize
numpy                    # Arrays
requests                 # HTTP API calls
python-dotenv            # Secret management
jsonschema               # JSON schema validation
pydantic                 # Data model validation
tenacity                 # Retry logic
tqdm                     # Progress bars
```

Install all at once:
```bash
pip install mysql-connector-python sqlalchemy pandas numpy requests \
            python-dotenv jsonschema pydantic tenacity tqdm
```