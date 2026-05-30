# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A daily problem-solving archive for Data Engineering interview prep. Problems are sourced from LeetCode Premium, Ankit Bansal (YouTube), DataLemur, and StrataScratch. Each problem is solved in both SQL and Pandas (where applicable).

## File naming convention

All `.sql` and `.py` files inside SQL topic folders follow this format:

```
Leetcode_DD_MonthName_YYYY_ProblemNumber.extension
```

Example: `Leetcode_27_Oct_2024_2854.sql`

**ANKIT_BANSAL** is excluded from this convention — files there use free-form names.

## Folder structure

### SQL topic folders (standard template)

Each SQL topic folder uses this structure:

```
TOPIC/
 ├── PANDAS/
 │    ├── Easy/
 │    ├── Medium/
 │    └── Hard/
 └── SQL/
      ├── Easy/
      ├── Medium/
      └── Hard/
```

Current SQL topics: `CASE WHEN`, `DATE_TIME`, `FRIENDSHIP`, `GROUPBY`, `JOIN`, `MISC`, `PIVOT`, `RECURSIVE_CTE`, `STRING`, `UNION`, `UNPIVOT`, `WHERE`, `WINDOW_FUNCTION`

`JOIN` has sub-type folders (`INNER`, `LEFT`, `CROSS`, `FULL-OUTER-JOIN`, `NON-EQUI`, `CAPACITY_VS_CUM_COUNT`) — each containing their own `PANDAS/` and `SQL/` with difficulty subdirs.

`WINDOW_FUNCTION` has sub-type folders (`RANKING`, `LAG_LEAD`, `SUM`, `MAXIMUM`, `AVERAGE`, `CONTINUOUS_FINDING`) — same structure.

### ANKIT_BANSAL

Real-world company SQL problems (Blinkit, Naukri, LinkedIn, Vyapar, etc.). Structure is flat:

```
ANKIT_BANSAL/
 ├── sql/
 └── pandas/
```

### PYTHON_MYSQL_DE_V2

A 30-day Python + MySQL curriculum for Data Engineering. See `PYTHON_MYSQL_DE_V2/CURRICULUM.md` for the full day-by-day breakdown.

Each day has two files:
- `dayXX_topic.py` — concept file with explanations, examples, and a `run_demo()` function
- `dayXX_exercise.py` — 6 exercises with `pass` stubs; `if __name__ == "__main__"` runs all

DB config used throughout:
```python
DB_CONFIG = {"host": "localhost", "port": 3306, "user": "root", "password": "asd123", "database": "sql_practice"}
```

Days completed: 01–03. Thread map: Days 01–05 Connection & Setup → 06–12 Cursors & SELECT → 13–18 CRUD + Safe Writes → 19–22 Transactions → 23–26 Context Managers + Streaming → 27–30 Batch Inserts + Capstone.

## Running Python files

```bash
python PYTHON_MYSQL_DE_V2/day03_error_handling.py   # runs run_demo()
python PYTHON_MYSQL_DE_V2/day03_exercise.py          # runs all 6 exercises
```

Requires: `pip install mysql-connector-python sqlalchemy pandas requests python-dotenv`

MySQL must be running locally on port 3306 with user `root`, database `sql_practice`.

## SQL files

SQL files contain both the DDL/INSERT setup and one or more solution queries (labelled `-- m1`, `-- m2`, etc.). Run them in any MySQL client against the `sql_practice` database.

## Key patterns to follow

- Pandas solutions mirror the SQL logic for the same problem number.
- Window function solutions often include multiple approaches (M1 = concise LAG/DATEDIFF pattern; M2 = islands/gaps technique).
- `ANKIT_BANSAL` files do not follow the `Leetcode_` naming convention — leave them as-is.
- When creating a new day file for `PYTHON_MYSQL_DE_V2`, follow the exact header and section format of existing day files (block comment headers, CONCEPT N sections, Python tip section, `run_demo()`, `if __name__ == "__main__"`).