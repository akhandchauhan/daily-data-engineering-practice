# =============================================================================
# DAY 1 — DSA for Data Engineering
# Topic  : List Indexing & Slicing + In-place vs Copy
# Goal   : Master the mechanics every array problem builds on
# =============================================================================

# =============================================================================
# CONCEPT 1 — Indexing, Negative Indexing, Slicing
# =============================================================================
# A Python list is an ordered, zero-indexed sequence.
# These three access patterns appear in virtually every array problem.
#
# INDEXING — access a single element
#   nums[0]   → first element
#   nums[-1]  → last element  (same as nums[len(nums)-1])
#   nums[-2]  → second from last
#
# SLICING — access a range of elements  →  nums[start : stop : step]
#   stop is EXCLUSIVE — nums[1:4] gives indices 1, 2, 3 (not 4)
#   omit start → defaults to 0
#   omit stop  → defaults to len(nums)
#   negative step → iterate backwards
#
# In DE: you slice log lines, partition date ranges, extract column ranges.
# =============================================================================

nums = [10, 20, 30, 40, 50]

print("=== Indexing ===")
print(nums[0])          # 10  — first
print(nums[-1])         # 50  — last
print(nums[-2])         # 40  — second from last

print("\n=== Slicing ===")
print(nums[1:4])        # [20, 30, 40]  — indices 1,2,3
print(nums[:3])         # [10, 20, 30]  — first 3
print(nums[2:])         # [30, 40, 50]  — from index 2 to end
print(nums[::2])        # [10, 30, 50]  — every other element
print(nums[::-1])       # [50, 40, 30, 20, 10]  — reversed

print("\n=== Useful patterns ===")
print(nums[len(nums)//2])   # middle element
print(nums[-3:])             # last 3 elements  → [30, 40, 50]
print(nums[::-1][0])         # last element via reverse (same as nums[-1])


# =============================================================================
# CONCEPT 2 — In-place Mutation vs Creating a Copy
# =============================================================================
# This is the most common silent bug in array problems.
#
# ASSIGNMENT  (=)  does NOT copy a list — both variables point to the SAME list.
#   b = a
#   b[0] = 99     ← also changes a[0] !
#
# SHALLOW COPY — creates a new list with the same elements.
#   Three equivalent ways:
#     b = a[:]          slice with no start/stop
#     b = a.copy()      list method
#     b = list(a)       list constructor
#
# IN-PLACE METHODS — modify the original list, return None.
#   list.sort()
#   list.reverse()
#   list.append(), list.pop(), list.insert()
#   Mistake: b = a.sort()  → b is None, a is sorted
#
# COPY-RETURNING FUNCTIONS — return a new list, original unchanged.
#   sorted(a)    → new sorted list
#   a + b        → new concatenated list
#   a[:]         → new copy
#
# In DE: a pipeline stage should not mutate its input — always copy first.
# =============================================================================

print("\n=== Assignment shares the same list ===")
a = [3, 1, 4, 1, 5]
b = a                   # b points to the SAME list
b[0] = 99
print(a)                # [99, 1, 4, 1, 5]  ← a was changed too!

print("\n=== Shallow copy isolates changes ===")
a = [3, 1, 4, 1, 5]
b = a[:]                # new list, independent copy
b[0] = 99
print(a)                # [3, 1, 4, 1, 5]  ← a is untouched
print(b)                # [99, 1, 4, 1, 5]

print("\n=== In-place sort returns None ===")
a = [3, 1, 4, 1, 5]
result = a.sort()       # sorts a in-place
print(result)           # None  ← common mistake: assigning the result
print(a)                # [1, 1, 3, 4, 5]

print("\n=== sorted() returns a new list ===")
a = [3, 1, 4, 1, 5]
b = sorted(a)           # a unchanged, b is new sorted list
print(a)                # [3, 1, 4, 1, 5]
print(b)                # [1, 1, 3, 4, 5]


# =============================================================================
# DE CONNECTION
# =============================================================================
# Imagine each row of a dataset is a list.
# When you process a batch of rows:
#   - If you mutate the input list in a loop, you corrupt the original data.
#   - Always work on a copy if downstream code still needs the original.
#   - sorted() is safer than sort() in pipelines for this reason.
# =============================================================================

if __name__ == "__main__":
    pass   # all demos run at module level above
