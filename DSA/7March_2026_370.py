# 370. Range Addition
# Assume you have an array of length n initialized with all 0's and are given k update operations.

# Each operation is represented as a triplet: [startIndex, endIndex, inc] which increments 
# each element of subarray A[startIndex ... endIndex] (startIndex and endIndex inclusive) with inc.

# Return the modified array after all k operations were executed.
# Example:
# Input: length = 5, updates = [[1,3,2],[2,4,3],[0,2,-2]]
# Output: [-2,0,3,5,3]
# Explanation:

# Initial state:
# [0,0,0,0,0]

# After applying operation [1,3,2]:
# [0,2,2,2,0]

# After applying operation [2,4,3]:
# [0,2,5,5,3]

# After applying operation [0,2,-2]:
# [-2,0,3,5,3]

# m1 
def apply_op(lenght: int, updates:list) -> list:
    
    ans = [0] * length
    
    for traverse in updates:
        start_index = traverse[0]
        end_index = traverse[1]
        inc = traverse[2]
        
        ans[start_index] += inc
        if end_index + 1 < length: 
            ans[end_index + 1] -= inc
        
    prefix = ans[0]
    for i in range(1, length):
        ans[i] += prefix 
        prefix = ans[i]    
    
    return ans

length = 5
updates = [[1,3,2],[2,4,3],[0,2,-2]]
print(apply_op(length, updates))


###########################################################################################################

# m2 

def apply_op(length: int, updates: list) -> list:
    
    arr = [0] * length
    
    for start, end, inc in updates:
        arr[start] += inc
        
        if end + 1 < length:
            arr[end + 1] -= inc
    
    for i in range(1, length):
        arr[i] += arr[i - 1]
    
    return arr


length = 5
updates = [[1,3,2],[2,4,3],[0,2,-2]]

print(apply_op(length, updates))