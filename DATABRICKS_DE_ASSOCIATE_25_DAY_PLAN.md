# 25-Day Study Plan — Databricks Certified Data Engineer Associate

## Context

You want to pass the **Databricks Certified Data Engineer Associate** exam in 25 days (target window: 2026-05-29 → 2026-06-23). You already have SQL, Python, PySpark fluency and basic Databricks notebook experience — so the gap is **Databricks-specific platform knowledge**, not general data engineering. The plan optimises for:

- **2–3 hrs/day** budget
- **~$30 Udemy spend** (one prep course + one practice-exam course)
- **Daily quizzes from me** after each topic, with a 3-day mock-exam blitz at the end

The current exam (May 2026 guide) is **45 scored questions / 90 minutes / $200**, valid 2 years. Weight distribution:

| Domain | Weight | Days allocated |
|---|---|---|
| Databricks Intelligence Platform | 10% | 2 |
| Development & Ingestion | 30% | 7 |
| Data Processing & Transformations | 31% | 7 |
| Productionizing Data Pipelines | 18% | 4 |
| Data Governance & Quality | 11% | 2 |
| Review + Mock exams | — | 3 |

---

## Resources to use (the only ones you need)

### Paid (~$30)
1. **Primary course** — [Databricks Certified Data Engineer Associate — Preparation (Udemy)](https://www.udemy.com/course/databricks-certified-data-engineer-associate/) by Derar Alhussein. The most popular and structured course for this exam — covers Lakehouse, Delta Lake, ETL with Spark SQL + PySpark, and production pipelines. Watch at 1.5× speed.
2. **Practice exams** — [Databricks Data Engineer Associate Practice Exam 2026 (Udemy)](https://www.udemy.com/course/pass-databricks-data-engineer-associate-practice-exams/) — 600+ MCQs aligned to the official blueprint. Use only in the last week.

### Free supplements
3. **Hands-on platform** — [Databricks Community Edition](https://community.cloud.databricks.com/) (free) — use for every notebook exercise. Do NOT just watch videos.
4. **Andrew Brown's freeCodeCamp 7.5-hr course** — [YouTube](https://www.youtube.com/watch?v=0Hd5vYqin7w) — use as a *gap-filler* only when Derar's explanation didn't click.
5. **Official Databricks Academy free overview** — [Catalog DB005a](https://www.databricks.com/learn/training/home) — the official exam-overview course; watch in Week 1.
6. **Official exam guide PDF** — linked from the [Databricks certification page](https://www.databricks.com/learn/certification/data-engineer-associate) — print it and tick off every objective by Day 22.

---

## Day-by-day breakdown

> **Note on "Section N" references:** these map to the chapter order in Derar Alhussein's Udemy course curriculum. Exact section numbers may shift slightly if Udemy reorders chapters — match by topic name, not number.

### Week 1 — Platform foundations + Ingestion (Days 1–7)

| Day | Date | Topic | Action |
|---|---|---|---|
| 1 | May 29 | Lakehouse architecture, workspace, clusters | Derar Section 1–2 + Databricks Academy DB005a overview |
| 2 | May 30 | Cluster types, pools, notebooks, Repos | Derar Section 3 + create free Community Edition account, run first notebook |
| 3 | May 31 | Delta Lake basics: ACID, transaction log, time travel | Derar Section 4 + hands-on: `CREATE TABLE … USING DELTA`, `DESCRIBE HISTORY` |
| 4 | Jun 1 | Delta Lake advanced: `OPTIMIZE`, `ZORDER`, `VACUUM`, generated columns | Derar Section 5 + run all commands in CE |
| 5 | Jun 2 | Data ingestion: COPY INTO, Auto Loader (cloudFiles) | Derar Section 6 + hands-on Auto Loader on sample S3-like path |
| 6 | Jun 3 | Reading multiple formats (CSV, JSON, Parquet), schema inference vs schema-on-read | Derar Section 7 + write `spark.read` variants |
| 7 | Jun 4 | **Recap day** — re-read official exam guide objectives 1–2, take a free topic quiz | I quiz you on 20 MCQs covering Days 1–6 |

### Week 2 — Transformations + Spark SQL/PySpark (Days 8–14)

| Day | Date | Topic | Action |
|---|---|---|---|
| 8 | Jun 5 | Spark SQL deep dive: DML, MERGE INTO, CTEs in Databricks SQL | Derar Section 8 + practice MERGE for SCD-1 |
| 9 | Jun 6 | PySpark DataFrame API: select, filter, withColumn, joins | Derar Section 9 |
| 10 | Jun 7 | Higher-order functions, complex types (struct/array/map), explode | Derar Section 10 |
| 11 | Jun 8 | Window functions in Spark, partitioning strategies | Derar Section 11 — connect this to your existing SQL window function knowledge |
| 12 | Jun 9 | UDFs (Python + SQL), Pandas UDFs, when NOT to use them | Derar Section 12 |
| 13 | Jun 10 | **Structured Streaming basics**: readStream, writeStream, checkpoint, triggers | Derar Section 13 + hands-on micro-batch on Delta source |
| 14 | Jun 11 | **Recap + quiz** — 25 MCQs on Days 8–13, focus on PySpark + streaming | I quiz you |

### Week 3 — Production + DLT + Governance (Days 15–22)

| Day | Date | Topic | Action |
|---|---|---|---|
| 15 | Jun 12 | **Lakeflow Declarative Pipelines (DLT)**: bronze/silver/gold, expectations | Derar Section 14 — *high-yield topic, expect 4–6 questions* |
| 16 | Jun 13 | DLT continued: CDC with APPLY CHANGES INTO, quality enforcement | Derar Section 15 + build a small DLT pipeline |
| 17 | Jun 14 | **Lakeflow Jobs (Workflows)**: tasks, dependencies, retries, schedules | Derar Section 16 + create a 3-task job in CE |
| 18 | Jun 15 | Job parameters, notifications, debugging failed runs | Derar Section 17 |
| 19 | Jun 16 | **Unity Catalog**: metastore, catalogs, schemas, volumes | Derar Section 18 — *new heavy-weight topic* |
| 20 | Jun 17 | Unity Catalog: GRANT/REVOKE, dynamic views, row/column masking | Derar Section 19 |
| 21 | Jun 18 | Data lineage, audit logs, system tables | Derar Section 20 |
| 22 | Jun 19 | **Full syllabus walkthrough** — open the official exam guide, tick every objective | I quiz you on weak areas you flag |

### Week 4 — Mock exams + revision (Days 23–25)

| Day | Date | Topic | Action |
|---|---|---|---|
| 23 | Jun 20 | **Mock Exam 1** (90 min timed) + review every wrong answer | Use Udemy practice course Set 1 |
| 24 | Jun 21 | **Mock Exam 2** (90 min timed) + targeted revision on weakest domain | Use Udemy practice course Set 2 |
| 25 | Jun 22 | **Mock Exam 3** (90 min timed) — must score 80%+. Light revision only. | Sleep early. Exam day: Jun 23. |

---

## My daily role

After each topic-study day, post one of:
- *"Quiz me on day N"* → I give 10 exam-style MCQs, grade them, explain every wrong answer with Databricks docs references
- *"Explain X"* → I give a 5-line crisp explanation tied to how it shows up on the exam
- *"Mock exam"* (Days 23–25) → I simulate 45 questions / 90 min, then break down score by domain

I'll also flag the **5 highest-yield topics** based on the exam blueprint (Delta Lake, DLT, Auto Loader, Unity Catalog grants, Structured Streaming) — these are where most failing candidates lose points.

---

## Verification — how you'll know you're ready

- [ ] Mock exam scores ≥ 80% on at least 2 of 3 attempts
- [ ] Every objective in the official exam guide ticked off by Day 22
- [ ] Hands-on completed in Community Edition for: Auto Loader, MERGE, DLT pipeline with expectations, multi-task Job, Unity Catalog GRANT
- [ ] Can explain in 30 seconds each: difference between DLT and Jobs, when to use Auto Loader vs COPY INTO, what `OPTIMIZE ZORDER` does, how Unity Catalog three-level namespace works

---

## Sources

- [Databricks Certified Data Engineer Associate (official)](https://www.databricks.com/learn/certification/data-engineer-associate)
- [Databricks Training & Certification](https://www.databricks.com/learn/training/home)
- [Free overview courses announcement](https://www.databricks.com/blog/getting-databricks-certified-now-easier-free-overview-courses)
- [Databricks Certified Data Engineer Associate — Preparation (Udemy)](https://www.udemy.com/course/databricks-certified-data-engineer-associate/)
- [Databricks Data Engineer Associate Practice Exam 2026 (Udemy)](https://www.udemy.com/course/pass-databricks-data-engineer-associate-practice-exams/)
- [Andrew Brown freeCodeCamp 7.5-hr course (YouTube)](https://www.youtube.com/watch?v=0Hd5vYqin7w)
- [Pass the Databricks DE Associate (freeCodeCamp article)](https://www.freecodecamp.org/news/prepare-for-the-databricks-data-engineer-associate-certification-exam-and-pass/)
- [Top 5 Udemy courses recap (Medium)](https://medium.com/javarevisited/i-tried-15-databricks-certified-data-engineer-associate-courses-on-udemy-here-are-my-top-5-764947e50e9c)
