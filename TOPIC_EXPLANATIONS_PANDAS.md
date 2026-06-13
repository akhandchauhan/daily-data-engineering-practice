# Topic Explanations Series — Pandas

---

## 1. `.dt` Accessor vs `import datetime as dt`

### What is the difference?

`import datetime as dt` gives you Python's standard toolkit for building and manipulating **individual** date objects. `.dt` is a pandas **accessor** that lets you extract date parts from an **entire column** at once.

---

### The Two Things That Look the Same

| Syntax | What it actually is |
|---|---|
| `import datetime as dt` | Python standard library module; `dt` is just your alias for it |
| `df['col'].dt.year` | Pandas built-in accessor for `datetime64` Series — no relation to the import above |

---

### Step-by-Step: How They Work Differently

**Step 1** — `import datetime as dt` loads Python's built-in `datetime` module. You use it to create or manipulate **one date object at a time**: `dt.datetime(2024, 6, 1)`, `dt.timedelta(days=7)`.

**Step 2** — When you have a pandas column of dates, using the datetime module requires a `.apply()` loop — slow, and verbose for large datasets.

**Step 3** — Pandas stores datetime columns as `datetime64[ns]` (a NumPy type). The `.dt` accessor is a **gateway** into the datetime properties of that dtype.

**Step 4** — Calling `df['col'].dt.year` returns a brand new Series of just the year values for **every row at once** — no loop, NumPy speed under the hood.

**Step 5** — `.dt` only works after the column is cast to `datetime64`. If it's a plain string, run `pd.to_datetime(df['col'])` first. After that, `.dt` becomes available.

---

### Simple Analogy

`import datetime as dt` is like a **single calculator** — you hand it one date and it does math on that one date.

`.dt` accessor is like a **formula applied to the whole column** — you ask pandas "give me the year from every row at once," and it does it in one shot, like Excel's column formula.

---

### The Fix Pattern (Converting + Using `.dt`)

```python
import datetime as dt   # Python module — for creating individual date objects
import pandas as pd

# ❌ Using datetime module on a whole column (loop approach — slow)
df['year'] = df['date'].apply(lambda x: dt.datetime.strptime(x, '%Y-%m-%d').year)

# ✅ Using .dt accessor (vectorized — fast)
df['date']     = pd.to_datetime(df['date'])   # cast to datetime64 first
df['year']     = df['date'].dt.year
df['month']    = df['date'].dt.month
df['day_name'] = df['date'].dt.day_name()     # e.g., "Monday", "Tuesday"
```

---

### Common `.dt` Properties Cheat Sheet

| Property / Method | Returns |
|---|---|
| `dt.year` | Year as integer |
| `dt.month` | Month as integer (1–12) |
| `dt.day` | Day of month |
| `dt.hour` / `dt.minute` / `dt.second` | Time components |
| `dt.day_name()` | "Monday", "Tuesday", etc. |
| `dt.month_name()` | "January", "February", etc. |
| `dt.weekday` | 0 = Monday … 6 = Sunday |
| `dt.quarter` | 1–4 |
| `dt.date` | Just the date part (no time) |
| `dt.dayofyear` | Day number in the year (1–365) |

---

### Key Rules to Remember

| Rule | Example |
|------|---------|
| Cast column first | `pd.to_datetime(df['col'])` before using `.dt` |
| `.dt` is a pandas accessor, not related to your import alias | `import datetime as xyz` — `.dt` still works the same |
| `.dt` only works on `datetime64` dtype | Will error on string or object dtype |
| `.dt.year` etc. return a **Series**, not a scalar | Can be assigned directly as a new column |

---
