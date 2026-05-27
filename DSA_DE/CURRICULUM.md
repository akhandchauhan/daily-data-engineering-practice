# DSA for Data Engineering Interviews — 60-Day Curriculum
**Target:** Google, Meta, Amazon DE roles
**Level:** Basic familiarity → Interview-ready
**Language:** Python
**Format:** 2 concepts/day | `dayXX_topic.py` (concept) + `dayXX_exercise.py` (6 exercises)

---

## THREAD MAP

```
Days 01–12   →  Arrays & Strings              (most tested, most time)
Days 13–21   →  Hash Tables & Sets            (deduplication, group-by, lookups)
Days 22–30   →  Sorting & Merging             (ETL patterns, merge sorted streams)
Days 31–38   →  Sliding Window & Two Pointers (time-series, windowed analytics)
Days 39–44   →  Binary Search & Recursion     (data partitioning)
Days 45–50   →  Stacks & Queues               (pipeline ordering, event streams)
Days 51–55   →  Trees                         (hierarchies, JSON nesting, DAGs)
Days 56–58   →  Graphs                        (pipeline lineage, dependency resolution)
Days 59–60   →  DE Capstone                   (deduplicate streams, merge files, windowed aggregation)
```

---

## ARRAYS & STRINGS  (Days 01–12)

### DAY 01 — List Indexing & Slicing + In-place vs Copy
**Files:** `day01_arrays_indexing.py` · `day01_exercise.py`
**Concepts:**
1. Indexing, negative indexing, slicing — the mechanics every problem relies on
2. In-place mutation vs creating a copy — the most common silent bug in array problems

---

### DAY 02 — Linear Search + Existence Checks
**Files:** `day02_linear_search.py` · `day02_exercise.py`
**Concepts:**
1. Linear search — iterating to find a value or index
2. `in` operator and `list.index()` — when to use each and their cost

---

### DAY 03 — Two Pointers: Opposite Ends
**Files:** `day03_two_pointers_opposite.py` · `day03_exercise.py`
**Concepts:**
1. Two-pointer pattern — left and right closing inward
2. Applications: palindrome check, reversing in-place, sum of two targets

---

### DAY 04 — Two Pointers: Same Direction (Fast & Slow)
**Files:** `day04_two_pointers_same.py` · `day04_exercise.py`
**Concepts:**
1. Fast/slow pointer pattern — two pointers moving the same direction at different speeds
2. Applications: remove duplicates in-place, move zeros to end

---

### DAY 05 — Prefix Sums
**Files:** `day05_prefix_sums.py` · `day05_exercise.py`
**Concepts:**
1. Building a prefix sum array — convert O(n) range queries to O(1)
2. Range sum query — sum of any subarray in constant time after O(n) setup

---

### DAY 06 — String Basics + Immutability
**Files:** `day06_string_basics.py` · `day06_exercise.py`
**Concepts:**
1. String immutability — why you can't modify a string in-place and what that costs
2. Slicing, `len()`, `in`, indexing — same mechanics as lists but read-only

---

### DAY 07 — String Methods for DE
**Files:** `day07_string_methods.py` · `day07_exercise.py`
**Concepts:**
1. `split()`, `join()`, `strip()`, `replace()` — the four methods used in 90% of DE string problems
2. `lower()`, `upper()`, `startswith()`, `endswith()` — normalization patterns

---

### DAY 08 — Character Frequency & Anagram Pattern
**Files:** `day08_char_frequency.py` · `day08_exercise.py`
**Concepts:**
1. Counting characters with a dict and with `collections.Counter`
2. Anagram check, frequency comparison — the hash-on-characters pattern

---

### DAY 09 — Kadane's Algorithm (Max Subarray)
**Files:** `day09_kadanes.py` · `day09_exercise.py`
**Concepts:**
1. Brute-force subarray sum — O(n²) baseline
2. Kadane's algorithm — O(n) running max, the classic DE time-series pattern

---

### DAY 10 — 2D Arrays (Matrices)
**Files:** `day10_matrices.py` · `day10_exercise.py`
**Concepts:**
1. 2D list creation and row/column traversal
2. Transpose and flatten — common data reshaping operations

---

### DAY 11 — DE Pattern: Parsing Structured Strings
**Files:** `day11_parsing_strings.py` · `day11_exercise.py`
**Concepts:**
1. Parsing CSV-like rows manually — tokenizing, handling quoted fields
2. Building structured records (list of dicts) from raw string lines

---

### DAY 12 — DE Pattern: Merging & Deduplicating Arrays
**Files:** `day12_merge_dedup.py` · `day12_exercise.py`
**Concepts:**
1. Merging two sorted arrays into one sorted array — the merge step of merge sort
2. Deduplicating a sorted array in-place — O(n) with two pointers

---

## HASH TABLES & SETS  (Days 13–21)

### DAY 13 — Dict Basics + O(1) Lookup
**Files:** `day13_dict_basics.py` · `day13_exercise.py`
**Concepts:**
1. Dict as a hash table — O(1) average insert, lookup, delete
2. Common dict patterns: counting, grouping, caching

---

### DAY 14 — defaultdict & Counter
**Files:** `day14_defaultdict_counter.py` · `day14_exercise.py`
**Concepts:**
1. `collections.defaultdict` — auto-initialize missing keys
2. `collections.Counter` — count elements, most_common(), arithmetic

---

### DAY 15 — Two-Sum & Complement Pattern
**Files:** `day15_two_sum.py` · `day15_exercise.py`
**Concepts:**
1. Two-sum problem — brute O(n²) vs hash O(n)
2. Complement pattern — store what you've seen, look up what you need

---

### DAY 16 — Grouping & Bucketing
**Files:** `day16_grouping.py` · `day16_exercise.py`
**Concepts:**
1. Group-by with a dict — replicate SQL GROUP BY in Python
2. Bucketing by key function — grouping anagrams, grouping by date/category

---

### DAY 17 — Set Basics + Set Operations
**Files:** `day17_sets.py` · `day17_exercise.py`
**Concepts:**
1. Set — O(1) membership test, automatic deduplication
2. Set operations: union, intersection, difference — direct DE use (reconciling datasets)

---

### DAY 18 — Deduplication Patterns
**Files:** `day18_deduplication.py` · `day18_exercise.py`
**Concepts:**
1. Deduplicating with a set — preserve order with seen set + list
2. Deduplicating records (list of dicts) by a key field — real pipeline pattern

---

### DAY 19 — Frequency Maps for DE
**Files:** `day19_frequency_maps.py` · `day19_exercise.py`
**Concepts:**
1. Word/event frequency count — building and querying frequency maps
2. Top-K most frequent elements — sort by value, use Counter.most_common()

---

### DAY 20 — Hashing for Joins
**Files:** `day20_hash_joins.py` · `day20_exercise.py`
**Concepts:**
1. Hash join pattern — replicate SQL JOIN using two dicts
2. Left join vs inner join — handle missing keys explicitly

---

### DAY 21 — DE Pattern: Detecting Duplicates in a Stream
**Files:** `day21_stream_dedup.py` · `day21_exercise.py`
**Concepts:**
1. Seen-set pattern — detect first duplicate as you iterate
2. Idempotency check — process a record only if its ID hasn't been seen

---

## SORTING & MERGING  (Days 22–30)

### DAY 22 — Python Sorting Basics
**Files:** `day22_sorting_basics.py` · `day22_exercise.py`
**Concepts:**
1. `list.sort()` vs `sorted()` — in-place vs new list, stability guarantee
2. Sorting by key — `key=lambda`, `key=itemgetter`, multi-key sort

---

### DAY 23 — Custom Sort + Sort by Multiple Keys
**Files:** `day23_custom_sort.py` · `day23_exercise.py`
**Concepts:**
1. Sorting records (list of dicts) by one or more fields
2. Reverse sort, tie-breaking — replicating ORDER BY col1 ASC, col2 DESC

---

### DAY 24 — Merge Sort Concept
**Files:** `day24_merge_sort.py` · `day24_exercise.py`
**Concepts:**
1. Divide-and-conquer — split, recurse, merge
2. Writing merge sort from scratch — understand why it's O(n log n)

---

### DAY 25 — Merge K Sorted Lists
**Files:** `day25_merge_k_sorted.py` · `day25_exercise.py`
**Concepts:**
1. Merging 2 sorted lists — two-pointer approach
2. Merging K sorted lists — extend to K sources (real ETL: merge K sorted files)

---

### DAY 26 — Interval Problems
**Files:** `day26_intervals.py` · `day26_exercise.py`
**Concepts:**
1. Sorting intervals by start time
2. Merging overlapping intervals — classic DE scheduling/time-range problem

---

### DAY 27 — Sort + Hash Combined Patterns
**Files:** `day27_sort_hash.py` · `day27_exercise.py`
**Concepts:**
1. Sort then binary search — when sorting enables faster lookups
2. Group then sort within groups — nested sorting for reports

---

### DAY 28 — Counting Sort & Bucket Sort (When to Use)
**Files:** `day28_counting_bucket_sort.py` · `day28_exercise.py`
**Concepts:**
1. Counting sort — O(n) for bounded integer ranges
2. Bucket sort — distributing data into ranges, useful for histogram problems

---

### DAY 29 — DE Pattern: Sorting Logs & Events by Timestamp
**Files:** `day29_sort_logs.py` · `day29_exercise.py`
**Concepts:**
1. Parsing and sorting log lines by timestamp
2. Detecting out-of-order events in a stream

---

### DAY 30 — DE Pattern: External Sort (Large File Sorting)
**Files:** `day30_external_sort.py` · `day30_exercise.py`
**Concepts:**
1. Why in-memory sort fails on large files — the external sort problem
2. Chunk-sort-merge pattern — sort chunks individually, then merge

---

## SLIDING WINDOW & TWO POINTERS  (Days 31–38)

### DAY 31 — Fixed-Size Sliding Window
**Files:** `day31_fixed_window.py` · `day31_exercise.py`
**Concepts:**
1. Fixed window — maintain a window of size K as you slide through the array
2. Window sum, window max — add right element, remove left element

---

### DAY 32 — Variable-Size Sliding Window
**Files:** `day32_variable_window.py` · `day32_exercise.py`
**Concepts:**
1. Expand right until condition breaks, shrink left to restore
2. Longest subarray with sum ≤ K, smallest subarray with sum ≥ K

---

### DAY 33 — Sliding Window on Strings
**Files:** `day33_window_strings.py` · `day33_exercise.py`
**Concepts:**
1. Frequency map inside a window — tracking character counts as window moves
2. Minimum window substring — classic interview problem

---

### DAY 34 — DE Pattern: Rolling Aggregations
**Files:** `day34_rolling_aggregations.py` · `day34_exercise.py`
**Concepts:**
1. Rolling sum, rolling average over a window — replicating SQL window functions
2. Rolling min/max — maintaining a deque for O(n) sliding window extremes

---

### DAY 35 — Two Pointers: Three-Sum Pattern
**Files:** `day35_three_sum.py` · `day35_exercise.py`
**Concepts:**
1. Reducing three-sum to two-sum with sorting + two pointers
2. Avoiding duplicates in multi-pointer problems

---

### DAY 36 — Two Pointers: Container / Partition Pattern
**Files:** `day36_partition.py` · `day36_exercise.py`
**Concepts:**
1. Partition array around a pivot — basis of quicksort
2. Dutch national flag — sort array of 3 values in one pass (O(n), O(1) space)

---

### DAY 37 — DE Pattern: Session Windows
**Files:** `day37_session_windows.py` · `day37_exercise.py`
**Concepts:**
1. Session window — group events where gap between consecutive events < threshold
2. Computing session duration and event count per session

---

### DAY 38 — DE Pattern: Rate Limiting / Throttle Check
**Files:** `day38_rate_limiting.py` · `day38_exercise.py`
**Concepts:**
1. Sliding window counter — count events in last N seconds
2. Fixed window vs sliding window rate limiting — trade-offs

---

## BINARY SEARCH & RECURSION  (Days 39–44)

### DAY 39 — Binary Search Basics
**Files:** `day39_binary_search.py` · `day39_exercise.py`
**Concepts:**
1. Binary search on a sorted array — O(log n) vs O(n) linear search
2. The off-by-one trap — `lo <= hi` vs `lo < hi`, when to use each

---

### DAY 40 — Binary Search Variants
**Files:** `day40_binary_search_variants.py` · `day40_exercise.py`
**Concepts:**
1. Find first/last occurrence — leftmost and rightmost binary search
2. Search in rotated sorted array

---

### DAY 41 — Recursion Basics
**Files:** `day41_recursion_basics.py` · `day41_exercise.py`
**Concepts:**
1. Base case + recursive case — the two-part structure of every recursive function
2. Call stack mental model — trace through factorial, sum of list

---

### DAY 42 — Recursion on Arrays
**Files:** `day42_recursion_arrays.py` · `day42_exercise.py`
**Concepts:**
1. Recursive binary search — write it recursively, understand the call stack
2. Flatten a nested list — recursion on unknown depth (real DE: nested JSON)

---

### DAY 43 — DE Pattern: Binary Search on Answer Space
**Files:** `day43_binary_search_answer.py` · `day43_exercise.py`
**Concepts:**
1. Searching the answer space — when the answer itself is a sorted range
2. Minimize max chunk size — split file into K parts, find smallest valid chunk size

---

### DAY 44 — DE Pattern: Recursive File/Directory Traversal
**Files:** `day44_recursive_traversal.py` · `day44_exercise.py`
**Concepts:**
1. Recursive traversal of a nested dict (simulating a directory/JSON tree)
2. Collecting all leaf values — flatten nested JSON to key-path: value pairs

---

## STACKS & QUEUES  (Days 45–50)

### DAY 45 — Stack Basics
**Files:** `day45_stack_basics.py` · `day45_exercise.py`
**Concepts:**
1. Stack — LIFO, implement with a list (append/pop)
2. Valid parentheses — the canonical stack interview problem

---

### DAY 46 — Monotonic Stack
**Files:** `day46_monotonic_stack.py` · `day46_exercise.py`
**Concepts:**
1. Monotonic stack — maintain increasing or decreasing order as you push
2. Next greater element — O(n) with monotonic stack vs O(n²) brute force

---

### DAY 47 — Queue Basics + Deque
**Files:** `day47_queue_deque.py` · `day47_exercise.py`
**Concepts:**
1. Queue — FIFO, use `collections.deque` (O(1) append and popleft)
2. Sliding window maximum using deque — O(n) solution

---

### DAY 48 — DE Pattern: Task Queue Simulation
**Files:** `day48_task_queue.py` · `day48_exercise.py`
**Concepts:**
1. Simulating a pipeline task queue — enqueue jobs, process in order
2. Priority processing — `heapq` for min-heap task ordering

---

### DAY 49 — DE Pattern: Expression / Formula Parsing
**Files:** `day49_expression_parsing.py` · `day49_exercise.py`
**Concepts:**
1. Evaluate arithmetic expressions using a stack
2. Parsing nested SQL-like expressions — bracket depth tracking

---

### DAY 50 — DE Pattern: Dependency Ordering (Topological via Queue)
**Files:** `day50_dependency_ordering.py` · `day50_exercise.py`
**Concepts:**
1. In-degree array — count how many tasks block each task
2. Kahn's algorithm (BFS topological sort) — schedule tasks respecting dependencies

---

## TREES  (Days 51–55)

### DAY 51 — Binary Tree Basics
**Files:** `day51_tree_basics.py` · `day51_exercise.py`
**Concepts:**
1. TreeNode class — build a tree manually, understand left/right pointers
2. Tree height, count nodes — simple recursive problems

---

### DAY 52 — Tree Traversals
**Files:** `day52_tree_traversals.py` · `day52_exercise.py`
**Concepts:**
1. Inorder, preorder, postorder — recursive implementations
2. Level-order (BFS) — using a queue, returns levels as lists

---

### DAY 53 — Binary Search Tree
**Files:** `day53_bst.py` · `day53_exercise.py`
**Concepts:**
1. BST property — left < node < right, O(log n) search on balanced tree
2. Insert and search in a BST

---

### DAY 54 — DE Pattern: Hierarchical Data (Org Charts, Categories)
**Files:** `day54_hierarchical_data.py` · `day54_exercise.py`
**Concepts:**
1. Representing a parent-child hierarchy as a tree
2. Find all descendants of a node — real DE problem (category trees, org charts)

---

### DAY 55 — DE Pattern: JSON Tree Traversal
**Files:** `day55_json_tree.py` · `day55_exercise.py`
**Concepts:**
1. Treating nested JSON as a tree — recursive DFS to extract all key-value pairs
2. Comparing two JSON trees — find added, removed, changed keys

---

## GRAPHS  (Days 56–58)

### DAY 56 — Graph Basics + BFS
**Files:** `day56_graph_bfs.py` · `day56_exercise.py`
**Concepts:**
1. Graph as adjacency list — dict of node → list of neighbors
2. BFS — level-by-level traversal, shortest path in unweighted graph

---

### DAY 57 — DFS + Cycle Detection
**Files:** `day57_graph_dfs.py` · `day57_exercise.py`
**Concepts:**
1. DFS — recursive traversal, visited set to avoid revisiting
2. Cycle detection — detect a cycle in a directed graph

---

### DAY 58 — DE Pattern: Pipeline DAG & Topological Sort
**Files:** `day58_pipeline_dag.py` · `day58_exercise.py`
**Concepts:**
1. DAG (directed acyclic graph) — model a data pipeline as a graph
2. Topological sort — find a valid execution order for pipeline stages

---

## DE CAPSTONE  (Days 59–60)

### DAY 59 — Capstone: Stream Deduplication + Windowed Aggregation
**Files:** `day59_capstone_stream.py` · `day59_exercise.py`
**Concepts:**
1. Deduplicate an event stream by ID using a seen set — idempotent ingestion
2. Windowed aggregation — count events per 5-minute window over a timestamp stream

---

### DAY 60 — Capstone: Merge Sorted Files + Rank Top-K
**Files:** `day60_capstone_merge.py` · `day60_exercise.py`
**Concepts:**
1. Merge K sorted files into one sorted output — heap-based K-way merge
2. Top-K records by metric — combine sort + heap for efficient ranking

---

## DIFFICULTY PROGRESSION

| Days | LeetCode Equivalent |
|---|---|
| 01–30 | Easy |
| 31–50 | Easy–Medium |
| 51–60 | Medium |

---

## DE RELEVANCE KEY

| Topic | Why it matters in DE interviews |
|---|---|
| Arrays & Strings | Data parsing, row processing, log analysis |
| Hash Tables & Sets | Deduplication, joins, group-by, idempotency |
| Sorting & Merging | ETL ordering, merging datasets, external sort |
| Sliding Window | Time-series aggregations, session windows |
| Binary Search | Partitioning, chunk sizing, sorted lookups |
| Stacks & Queues | Pipeline task ordering, event processing |
| Trees | Hierarchical data, JSON nesting, DAG concepts |
| Graphs | Pipeline lineage, dependency resolution |
