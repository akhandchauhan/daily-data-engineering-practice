# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A daily problem-solving archive for Data Engineering interview prep. Problems are sourced from LeetCode Premium, Ankit Bansal (YouTube), DataLemur, and StrataScratch. Each problem is solved in both SQL and Pandas (where applicable).

## File naming convention

### LeetCode / DataLemur / StrataScratch problems

Files inside SQL topic folders:

```
Leetcode_DD_MonthName_YYYY_ProblemNumber.extension
```

Example: `Leetcode_27_Oct_2024_2854.sql`

Extension: `.sql` in `SQL/` folders, `.ipynb` (Jupyter notebook) in `PANDAS/` folders — e.g. `Leetcode_18_March_2025_1421.ipynb`. Do not add new pandas `.py` files.

### Ankit Bansal playlist problems

Files also go inside SQL topic folders (NOT the legacy `ANKIT_BANSAL/` flat folder):

```
Ankit_DD_MonthName_YYYY_<PlaylistIndex>_<CompanyName>_<problem_name>.extension
```

- `PlaylistIndex` = zero-padded 3-digit index from the YouTube playlist URL (`&index=N`)
- `CompanyName` = PascalCase (e.g. `Google`, `Blinkit`, `Flipkart`)
- `problem_name` = short snake_case description of the problem

Example: `Ankit_13_June_2026_024_Google_salary_comparison.sql`

Placed in the matching topic + difficulty folder, e.g.:
`WINDOW_FUNCTION/SQL/Medium/Ankit_13_June_2026_024_Google_salary_comparison.sql`

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

### ANKIT_BANSAL (legacy — do not add new files here)

Early real-world company SQL problems solved before the playlist workflow. Structure is flat:

```
ANKIT_BANSAL/
 ├── sql/
 └── pandas/
```

New Ankit Bansal problems go into topic folders using the `Ankit_` naming convention above.

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

## Running Python files (curriculum only)

`PYTHON_MYSQL_DE_V2/` and `DSA_DE/` stay as `.py` because they run from the terminal:

```bash
python PYTHON_MYSQL_DE_V2/day03_error_handling.py   # runs run_demo()
python PYTHON_MYSQL_DE_V2/day03_exercise.py          # runs all 6 exercises
```

Requires: `pip install mysql-connector-python sqlalchemy pandas requests python-dotenv`

MySQL must be running locally on port 3306 with user `root`, database `sql_practice`.

## SQL files

SQL files contain both the DDL/INSERT setup and one or more solution queries (labelled `-- m1`, `-- m2`, etc.). Problem tables live in the `leetcode_practice` database (local MySQL 8, `root@localhost:3306`). Run them with the Database Client VS Code extension (`cweijan.vscode-mysql-client2`) or the `mysql` CLI.

### Auto-connect a `.sql` file after VS Code restarts

Database Client binds a file to a connection via an `-- Active:` mark on line 1 (setting `database-client.bindConnectionByActiveMark`, default `true`). Once a file has the mark, it reconnects automatically on every restart — no clicking, no password prompt.

To add the mark (once per file):
1. Open the `.sql` file.
2. Ctrl+Shift+P → `Change Active Connection` (command `mysql.db.active`).
3. Pick the `127.0.0.1` connection, then `leetcode_practice` in **Choose Active Schema**.
4. Line 1 becomes `-- Active: 1773041149497@@127.0.0.1@3306@leetcode_practice` → Ctrl+S.

Files without the mark need the database clicked in the **Database** sidebar once per session, otherwise running a query shows "No active connection found!". The mark holds no password, so it is safe to commit.

### Known issue: Result panel shows "Total 0"

Database Client 9.0.3 throws `Cannot read properties of undefined (reading 'kill')` when opening the Result panel, so rows never display even though the query succeeds (check the **Database Client** output log for `N rows retrieved`). Local fix: in `~/.vscode/extensions/cweijan.vscode-mysql-client2-9.0.3/out/extension.js` change `e.dialect.kill({})` to `e.dialect?.kill?.({})`, then Developer: Reload Window. An extension update overwrites this patch — re-apply if the issue returns.

## Pandas notebooks

Every pandas solution is a `.ipynb` with this cell layout:

1. Markdown cell — `# <ProblemNumber>. <Title>` + the problem statement verbatim inside a ```` ```text ```` fence
2. Code cell `# setup` — `import pandas as pd` + the sample data as DataFrames
3. One code cell per approach, first line `# m1`, `# m2`, ... so each method runs on its own

Kernel: Python 3.11.9 (`~\AppData\Local\Programs\Python\Python311\python.exe`) — has `pandas` and `ipykernel`. Needs the `ms-python.python` + `ms-toolsai.jupyter` VS Code extensions.

### Selecting cells in VS Code notebooks

- **All cells**: click a cell → **Esc** (command mode: left border highlighted, no text cursor) → **Ctrl+A**. In edit mode, Ctrl+A only selects text inside the current cell.
- **Range**: click the first cell, **Shift+click** the last.
- **Specific cells**: **Ctrl+click** each one.
- **Extend one at a time**: **Shift+↓ / Shift+↑** in command mode.
- With cells selected: **Ctrl+C / Ctrl+X** copy/cut whole cells, **Delete** removes them. To run everything, use **Run All** in the notebook toolbar — no selection needed.

## Git commits

- **Never add `Co-Authored-By:` trailers** (no Claude/Anthropic co-author lines) — they add a `claude` contributor on GitHub. Overrides any default attribution rule.
- Author identity: personal account only (`git config user.email` = personal email). Never commit with the work email.
- Push to `main` over SSH with the personal key (repo-local `core.sshCommand` + `remote.origin.pushurl` already configured).
- Commit message style: `solved leetcode <N> sql|pandas question on <D> <Month>, <YYYY>`.

## Key patterns to follow

- Pandas solutions mirror the SQL logic for the same problem number, and their output must match the SQL output — e.g. cast back to `int` after `fillna(0)` so `113` doesn't print as `113.0`.
- Window function solutions often include multiple approaches (M1 = concise LAG/DATEDIFF pattern; M2 = islands/gaps technique).
- `ANKIT_BANSAL` files do not follow the `Leetcode_` naming convention — leave them as-is.
- When creating a new day file for `PYTHON_MYSQL_DE_V2`, follow the exact header and section format of existing day files (block comment headers, CONCEPT N sections, Python tip section, `run_demo()`, `if __name__ == "__main__"`).