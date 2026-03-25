# 1369. Get the Second Most Recent Activity
# SQL Schema 
# Table: UserActivity
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | username      | varchar |
# | activity      | varchar |
# | startDate     | Date    |
# | endDate       | Date    |
# +---------------+---------+
# This table does not contain primary key.
# This table contain information about the activity performed of each user in a period of time.
# A person with username performed a activity from startDate to endDate.
# Write an  SQL query to show the second most recent activity of each user.
# If the user only has one activity, return that one. 
# A user can't perform more than one activity at the same time. Return the result table in any order.
# The query result format is in the following example:
# UserActivity table:
# +------------+--------------+-------------+-------------+
# | username   | activity     | startDate   | endDate     |
# +------------+--------------+-------------+-------------+
# | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
# | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
# | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
# | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
# +------------+--------------+-------------+-------------+
# Result table:
# +------------+--------------+-------------+-------------+
# | username   | activity     | startDate   | endDate     |
# +------------+--------------+-------------+-------------+
# | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
# | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
# +------------+--------------+-------------+-------------+

# The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
# Bob only has one record, we just take that one.

import pandas as pd

user_activity = pd.DataFrame({
    "username": ["Alice", "Alice", "Alice", "Bob"],
    "activity": ["Travel", "Dancing", "Travel", "Travel"],
    "startDate": ["2020-02-12", "2020-02-21", "2020-02-24", "2020-02-11"],
    "endDate": ["2020-02-20", "2020-02-23", "2020-02-28", "2020-02-18"]
})

user_activity["startDate"] = pd.to_datetime(user_activity["startDate"])
user_activity["endDate"] = pd.to_datetime(user_activity["endDate"])


user_activity['rnk'] = (user_activity.groupby('username')['startDate']
                        .rank(method = 'dense', ascending = False)
)

user_activity['user_cnt'] = (user_activity.groupby('username')['startDate']
                        .transform('count')
)

user_activity = user_activity.query("rnk ==2 or user_cnt == 1")[['username','activity','startDate','endDate']]
print(user_activity)
