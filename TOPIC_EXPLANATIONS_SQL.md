# Topic Explanations Series

---

## 1. MySQL Collation Mismatch Error

### What is a Collation?

A **collation** is a set of rules that tells MySQL **how to compare and sort text**.

For example:
- Should `'A'` == `'a'`? (case sensitivity)
- Should `'e'` == `'é'`? (accent sensitivity)

Different collations have different answers to these questions.

---

### The Two Collations in Your Error

| Collation | Where it comes from |
|---|---|
| `utf8mb4_unicode_ci` | Your `spending` table's `platform` column |
| `utf8mb4_0900_ai_ci` | MySQL's default for string literals like `'both'` |

---

### Step-by-Step: How the Error Happens

**Step 1** — Your `spending` table was created with `platform` column using `utf8mb4_unicode_ci`.

**Step 2** — In your query, you write `SELECT 'both'`. MySQL assigns this literal the **server's default collation**: `utf8mb4_0900_ai_ci`.

**Step 3** — In the final `LEFT JOIN`, MySQL tries to run this comparison:
```
ci.platform = fsi.platform
```
One side came from the `spending` table (`unicode_ci`), the other side has the literal `'both'` (`0900_ai_ci`).

**Step 4** — MySQL says:
> "I have two strings with **different rule sets**. I don't know which rules to use for this comparison. I refuse to guess."

That is the error.

---

### Simple Analogy

Imagine two judges scoring a competition — one using **American rules**, one using **British rules**. When they need to agree on a winner, they argue: *"Which rulebook do we use?"* MySQL does the same thing and just throws an error instead of picking.

---

### The Fix (One Line)

Tell MySQL to use the same collation for your string literals:

```sql
SELECT 'both' COLLATE utf8mb4_unicode_ci
-- and
THEN 'both' COLLATE utf8mb4_unicode_ci
```

Now both sides of the `=` comparison use the same rules, so MySQL is happy.

---

## 2. Subqueries in FROM + CROSS JOIN — From Basics

---

### Step 1: A normal SELECT

```sql
SELECT * FROM spending;
```
Reads rows directly from a real table.

---

### Step 2: A subquery (derived table)

You can use a `SELECT` result **as if it were a table**:

```sql
SELECT * 
FROM (
    SELECT DISTINCT spend_date FROM spending
) AS a;
```

The inner query runs first, produces a temporary result, and the outer query reads from it. The alias `AS a` is **required** — MySQL needs a name for that temporary table.

---

### Step 3: Why `AS a` alone throws an error

```sql
(SELECT DISTINCT spend_date FROM spending) AS a   -- ERROR
```

This is like writing:

```sql
employees AS e   -- ERROR — you need SELECT * FROM employees AS e
```

A subquery in `FROM` **must be inside a full SELECT statement**. You can't just float it standalone.

---

### Step 4: CROSS JOIN

CROSS JOIN combines **every row** from table A with **every row** from table B.

```
A has 3 rows  →  spend_date: Jan, Feb, Mar
B has 3 rows  →  platform:   mobile, desktop, both

Result: 3 × 3 = 9 rows (every date paired with every platform)
```

---

### Step 5: Putting it together

```sql
SELECT *
FROM (
    SELECT DISTINCT spend_date FROM spending   -- all unique dates
) AS a
CROSS JOIN (
    SELECT DISTINCT platform FROM spending     -- mobile, desktop
    UNION
    SELECT 'both'                              -- + manually add 'both'
) AS b;
```

**What this builds:**

| spend_date | platform |
|------------|----------|
| 2019-01-01 | mobile   |
| 2019-01-01 | desktop  |
| 2019-01-01 | both     |
| 2019-01-02 | mobile   |
| 2019-01-02 | desktop  |
| 2019-01-02 | both     |

This is a **skeleton of all possible combinations** — commonly used in reporting problems so you have every date-platform pair even if some have no data.

---

### Key rules to remember

| Rule | Example |
|------|---------|
| Subquery in FROM needs outer SELECT | `SELECT * FROM (...) AS x` |
| Alias is mandatory | `AS a`, `AS b` — can't omit |
| CROSS JOIN = cartesian product | M rows × N rows = M×N rows |
| UNION adds rows vertically | Stacks `'both'` onto existing platforms |

---