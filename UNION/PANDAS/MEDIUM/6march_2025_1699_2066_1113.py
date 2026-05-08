# -- 1699. Number of Calls Between Two Persons
# -- Description
# -- Table: Calls
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | from_id     | int     |
# -- | to_id       | int     |
# -- | duration    | int     |
# -- +-------------+---------+
# -- This table does not have a primary key (column with unique values), it may contain duplicates.
# -- This table contains the duration of a phone call between from_id and to_id.
# -- from_id != to_id
# -- Write a solution to report the number of  calls and the total  call duration 
# --between each pair of distinct persons (person1, person2) where person1 < person2.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Calls table:
# -- +---------+-------+----------+
# -- | from_id | to_id | duration |
# -- +---------+-------+----------+
# -- | 1       | 2     | 59       |
# -- | 2       | 1     | 11       |
# -- | 1       | 3     | 20       |
# -- | 3       | 4     | 100      |
# -- | 3       | 4     | 200      |
# -- | 3       | 4     | 200      |
# -- | 4       | 3     | 499      |
# -- +---------+-------+----------+
# -- Output: 
# -- +---------+---------+------------+----------------+
# -- | person1 | person2 | call_count | total_duration |
# -- +---------+---------+------------+----------------+
# -- | 1       | 2       | 2          | 70             |
# -- | 1       | 3       | 1          | 20             |
# -- | 3       | 4       | 4          | 999            |
# -- +---------+---------+------------+----------------+
# -- Explanation: 
# -- Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
# -- Users 1 and 3 had 1 call and the total duration is 20.
# -- Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).


import pandas as pd
data = {
    "from_id": [1, 2, 1, 3, 3, 3, 4],
    "to_id": [2, 1, 3, 4, 4, 4, 3],
    "duration": [59, 11, 20, 100, 200, 200, 499]
}

calls_df = pd.DataFrame(data)


calls_df['person1'] = calls_df.apply(lambda x: x['from_id'] if x['from_id'] < x['to_id'] else x['to_id'], axis=1)
calls_df['person2'] = calls_df.apply(lambda x: x['to_id'] if x['from_id'] < x['to_id'] else x['from_id'], axis=1)

# print(calls_df)
df  = calls_df.groupby(['person1','person2'])['duration'].sum().reset_index()
#print(df)


# m2
df1 = calls_df[['from_id', 'to_id', 'duration']].rename(columns={'from_id': 'person1', 'to_id': 'person2'})
df2 = calls_df[['to_id', 'from_id', 'duration']].rename(columns={'to_id': 'person1', 'from_id': 'person2'})

merged_df = pd.concat([df1, df2])
result_df = merged_df.groupby(['person1', 'person2'], as_index=False)['duration'].sum()
result_df = result_df.query('person1<person2')
#print(result_df)



# -- 2066. Account Balance
# -- Description
# -- Table: Transactions
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | account_id  | int  |
# -- | day         | date |
# -- | type        | ENUM |
# -- | amount      | int  |
# -- +-------------+------+
# -- (account_id, day) is the primary key for this table.
# -- Each row contains information about one transaction, including the transaction type, the day
# -- it occurred on, and the amount.
# -- type is an ENUM of the type ('Deposit','Withdraw') 
# -- Write an  SQL query to report the balance of each user after each transaction. 
# -- You may assume that the balance of each account before any transaction is 0 and that
# -- the balance will never be below 0 at any moment.
# -- Return the result table in ascending order by account_id, then by day in case of a tie.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Transactions table:
# -- +------------+------------+----------+--------+
# -- | account_id | day        | type     | amount |
# -- +------------+------------+----------+--------+
# -- | 1          | 2021-11-07 | Deposit  | 2000   |
# -- | 1          | 2021-11-09 | Withdraw | 1000   |
# -- | 1          | 2021-11-11 | Deposit  | 3000   |
# -- | 2          | 2021-12-07 | Deposit  | 7000   |
# -- | 2          | 2021-12-12 | Withdraw | 7000   |
# -- +------------+------------+----------+--------+
# -- Output: 
# -- +------------+------------+---------+
# -- | account_id | day        | balance |
# -- +------------+------------+---------+
# -- | 1          | 2021-11-07 | 2000    |
# -- | 1          | 2021-11-09 | 1000    |
# -- | 1          | 2021-11-11 | 4000    |
# -- | 2          | 2021-12-07 | 7000    |
# -- | 2          | 2021-12-12 | 0       |
# -- +------------+------------+---------+

import pandas as pd

data = {
    "account_id": [1, 1, 1, 2, 2],
    "day": ["2021-11-07", "2021-11-09", "2021-11-11", "2021-12-07", "2021-12-12"],
    "type": ["Deposit", "Withdraw", "Deposit", "Deposit", "Withdraw"],
    "amount": [2000, 1000, 3000, 7000, 7000]
}

transactions_df = pd.DataFrame(data)
transactions_df['day'] = pd.to_datetime(transactions_df['day'])

transactions_df['act_amt'] = transactions_df.apply(lambda x: -1* x['amount'] if x['type'] == 'Withdraw' else x['amount'],axis = 1)

transactions_df['balance'] = transactions_df.groupby('account_id')['act_amt'].transform('cumsum')
transactions_df = transactions_df[['account_id','day','balance']]
#print(transactions_df)



# -- 1113. Reported Posts
# -- Description
# -- Table: Actions
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | user_id       | int     |
# -- | post_id       | int     |
# -- | action_date   | date    | 
# -- | action        | enum    |
# -- | extra         | varchar |
# -- +---------------+---------+
# -- This table may have duplicate rows.
# -- The action column is an ENUM (category) type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
# -- The extra column has optional information about the action, such as a reason for the report or a type of reaction.
# -- extra is never NULL.
# -- Write a solution to report the number of posts reported yesterday for each report reason.
# -- Assume today is 2019-07-05.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Actions table:
# -- +---------+---------+-------------+--------+--------+
# -- | user_id | post_id | action_date | action | extra  |
# -- +---------+---------+-------------+--------+--------+
# -- | 1       | 1       | 2019-07-01  | view   | null   |
# -- | 1       | 1       | 2019-07-01  | like   | null   |
# -- | 1       | 1       | 2019-07-01  | share  | null   |
# -- | 2       | 4       | 2019-07-04  | view   | null   |
# -- | 2       | 4       | 2019-07-04  | report | spam   |
# -- | 3       | 4       | 2019-07-04  | view   | null   |
# -- | 3       | 4       | 2019-07-04  | report | spam   |
# -- | 4       | 3       | 2019-07-02  | view   | null   |
# -- | 4       | 3       | 2019-07-02  | report | spam   |
# -- | 5       | 2       | 2019-07-04  | view   | null   |
# -- | 5       | 2       | 2019-07-04  | report | racism |
# -- | 5       | 5       | 2019-07-04  | view   | null   |
# -- | 5       | 5       | 2019-07-04  | report | racism |
# -- +---------+---------+-------------+--------+--------+
# -- Output: 
# -- +---------------+--------------+
# -- | report_reason | report_count |
# -- +---------------+--------------+
# -- | spam          | 1            |
# -- | racism        | 2            |
# -- +---------------+--------------+
# -- Explanation: Note that we only care about report reasons with non-zero number of reports.


import pandas as pd
data = {
    "user_id": [1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5],
    "post_id": [1, 1, 1, 4, 4, 4, 4, 3, 3, 2, 2, 5, 5],
    "action_date": ["2019-07-01", "2019-07-01", "2019-07-01", "2019-07-04", "2019-07-04", 
                    "2019-07-04", "2019-07-04", "2019-07-02", "2019-07-02", "2019-07-04", 
                    "2019-07-04", "2019-07-04", "2019-07-04"],
    "action": ["view", "like", "share", "view", "report", "view", "report", "view", "report", 
               "view", "report", "view", "report"],
    "extra": [None, None, None, None, "spam", None, "spam", None, "spam", None, "racism", None, "racism"]
}
yesterday = pd.Timestamp("2019-07-04")
actions_df = pd.DataFrame(data)
actions_df['action_date'] = pd.to_datetime(actions_df['action_date'])
reported_df = actions_df[(actions_df["action"] == "report") & (actions_df["action_date"] == yesterday)]

result_df = reported_df.groupby("extra")["post_id"].nunique().reset_index()

result_df.columns = ["report_reason", "report_count"]

print(result_df)