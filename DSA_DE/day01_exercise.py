# =============================================================================
# DAY 1 — EXERCISES
# Topic  : List Indexing & Slicing + In-place vs Copy
# Instructions: Solve each exercise without running the concept file first.
#               Expected outputs are given — verify by running this file.
# =============================================================================


# =============================================================================
# EXERCISE 1 — Indexing practice
# =============================================================================
# Given:
data = [5, 12, 7, 3, 19, 8, 14]
#
# Without using len(), print:
#   a. The first element
#   b. The last element using negative indexing
#   c. The third element
#   d. The second-to-last element
#
# Expected output:
#   5
#   14
#   7
#   8
# =============================================================================

def exercise_1():
    pass   # replace with your code


# =============================================================================
# EXERCISE 2 — Slicing practice
# =============================================================================
# Given:
prices = [100, 200, 300, 400, 500, 600, 700]
#
# Using slicing only (no loops), produce:
#   a. First 3 elements              → [100, 200, 300]
#   b. Last 3 elements               → [500, 600, 700]
#   c. Elements from index 2 to 4    → [300, 400, 500]
#   d. Every other element           → [100, 300, 500, 700]
#   e. The entire list reversed      → [700, 600, 500, 400, 300, 200, 100]
#
# Print each result on its own line.
# =============================================================================

def exercise_2():
    pass   # replace with your code


# =============================================================================
# EXERCISE 3 — Spot the mutation bug
# =============================================================================
# The function below is supposed to return a sorted copy of the input
# while leaving the original unchanged. It has a bug.
# Fix it so that original is NOT modified.
#
# After your fix:
#   original = [4, 2, 7, 1]
#   result   = [1, 2, 4, 7]
#   original = [4, 2, 7, 1]   ← must stay unsorted
# =============================================================================

def sort_copy_buggy(lst):
    lst.sort()       # bug is here — fix this function
    return lst

def exercise_3():
    original = [4, 2, 7, 1]
    result = sort_copy_buggy(original)
    print(f"result:   {result}")
    print(f"original: {original}")   # should still be [4, 2, 7, 1]


# =============================================================================
# EXERCISE 4 — Reverse a list two ways
# =============================================================================
# Given:
events = ["login", "click", "purchase", "logout"]
#
# a. Reverse it using slicing → store in reversed_slice
# b. Reverse it using .reverse() → store in reversed_inplace
#
# Print both results.
# Then print whether events itself was changed after each operation.
#
# Key question to answer in a comment: which method modifies the original?
# =============================================================================

def exercise_4():
    pass   # replace with your code


# =============================================================================
# EXERCISE 5 — Extract middle chunk
# =============================================================================
# Write a function called middle_chunk(lst, k) that:
#   - Returns the middle k elements of lst using slicing.
#   - If the list has fewer than k elements, return the whole list.
#   - Assume k is always odd and len(lst) is always odd for simplicity.
#
# Example:
#   middle_chunk([1,2,3,4,5,6,7], 3) → [3, 4, 5]
#   middle_chunk([10,20,30,40,50], 1) → [30]
#
# Hint: find the center index, then slice k//2 left and k//2 right of it.
# =============================================================================

def middle_chunk(lst, k):
    pass   # replace with your code

def exercise_5():
    print(middle_chunk([1, 2, 3, 4, 5, 6, 7], 3))   # [3, 4, 5]
    print(middle_chunk([10, 20, 30, 40, 50], 1))      # [30]
    print(middle_chunk([1, 2, 3], 5))                 # [1, 2, 3]  (k > len)


# =============================================================================
# EXERCISE 6 — DE scenario: safe row transformation
# =============================================================================
# You receive a batch of rows (list of lists). Each row is:
#   [user_id, event, timestamp, value]
#
# Write a function called extract_values(batch) that:
#   a. Creates a copy of the batch (do NOT mutate the original)
#   b. From each row, extracts only [user_id, value] (index 0 and 3)
#   c. Returns the list of [user_id, value] pairs
#
# After calling it, the original batch must be unchanged.
#
# Example:
#   batch = [
#       [1, "click",    "2024-01-01", 5.0],
#       [2, "purchase", "2024-01-02", 99.9],
#       [3, "login",    "2024-01-03", 0.0],
#   ]
#   extract_values(batch) → [[1, 5.0], [2, 99.9], [3, 0.0]]
# =============================================================================

def extract_values(batch):
    pass   # replace with your code

def exercise_6():
    batch = [
        [1, "click",    "2024-01-01", 5.0],
        [2, "purchase", "2024-01-02", 99.9],
        [3, "login",    "2024-01-03", 0.0],
    ]
    result = extract_values(batch)
    print(f"result: {result}")
    print(f"batch unchanged: {batch}")


# =============================================================================
# RUN ALL
# =============================================================================

if __name__ == "__main__":
    print("=" * 50)
    print("EXERCISE 1 — Indexing")
    print("=" * 50)
    exercise_1()

    print("\n" + "=" * 50)
    print("EXERCISE 2 — Slicing")
    print("=" * 50)
    exercise_2()

    print("\n" + "=" * 50)
    print("EXERCISE 3 — Mutation bug fix")
    print("=" * 50)
    exercise_3()

    print("\n" + "=" * 50)
    print("EXERCISE 4 — Reverse two ways")
    print("=" * 50)
    exercise_4()

    print("\n" + "=" * 50)
    print("EXERCISE 5 — Middle chunk")
    print("=" * 50)
    exercise_5()

    print("\n" + "=" * 50)
    print("EXERCISE 6 — DE: safe row transformation")
    print("=" * 50)
    exercise_6()
