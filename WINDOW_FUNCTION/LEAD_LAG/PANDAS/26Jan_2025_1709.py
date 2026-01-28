# 1709. Biggest Window Between Visits
# SQL Schema 
# Table: UserVisits

# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | user_id     | int  |
# | visit_date  | date |
# +-------------+------+
# This table does not have a primary key.
# This table contains logs of the dates that users vistied a certain retailer.

# Assume today's date is '2021-1-1'.

# Write an SQL query that will, for each user_id, find out the largest window of days between each visit and 
# #the one right after it (or today if you are considering the last visit).

# Return the result table ordered by user_id.

# The query result format is in the following example:

# UserVisits table:
# +---------+------------+
# | user_id | visit_date |
# +---------+------------+
# | 1       | 2020-11-28 |
# | 1       | 2020-10-20 |
# | 1       | 2020-12-3  |
# | 2       | 2020-10-5  |
# | 2       | 2020-12-9  |
# | 3       | 2020-11-11 |
# +---------+------------+
# Result table:
# +---------+---------------+
# | user_id | biggest_window|
# +---------+---------------+
# | 1       | 39            |
# | 2       | 65            |
# | 3       | 51            |
# +---------+---------------+
# For the first user, the windows in question are between dates:
#     - 2020-10-20 and 2020-11-28 with a total of 39 days.
#     - 2020-11-28 and 2020-12-3 with a total of 5 days.
#     - 2020-12-3 and 2021-1-1 with a total of 29 days.
# Making the biggest window the one with 39 days.
# For the second user, the windows in question are between dates:
#     - 2020-10-5 and 2020-12-9 with a total of 65 days.
#     - 2020-12-9 and 2021-1-1 with a total of 23 days.
# Making the biggest window the one with 65 days.
# For the third user, the only window in question is between dates 2020-11-11 and 2021-1-1 with a total of 51 days.


import pandas as pd

# Create DataFrame
data = {
    "user_id": [1, 1, 1, 2, 2, 3],
    "visit_date": [
        "2020-11-28",
        "2020-10-20",
        "2020-12-03",
        "2020-10-05",
        "2020-12-09",
        "2020-11-11"
    ]
}

UserVisits = pd.DataFrame(data)
UserVisits["visit_date"] = pd.to_datetime(UserVisits["visit_date"])

# m1 using lead

# UserVisits = UserVisits.sort_values(['user_id','visit_date'])
# UserVisits['next_visit_date'] = UserVisits.groupby('user_id')['visit_date'].shift(-1)
# UserVisits['next_visit_date'] = UserVisits['next_visit_date'].fillna('2021-01-01')
# UserVisits['visit_date_diff'] = (UserVisits['next_visit_date'] - UserVisits['visit_date'])
# print(UserVisits)
# UserVisits = (
#                 UserVisits
#                 .groupby('user_id')['visit_date_diff']
#                 .max()
#                 .reset_index(name = 'biggest_window')
#                 .sort_values('user_id')
# )
# print(UserVisits)

#############################################################################################################################

#m2 refined using chatgpt

# print(
#         UserVisits
#         .sort_values(['user_id', 'visit_date'])
#         .assign(
#             next_visit_date=lambda d:
#                 d.groupby('user_id')['visit_date'].shift(-1)
#                 .fillna(pd.Timestamp('2021-01-01'))
#         )
#         .assign(
#             visit_date_diff=lambda d:
#                 (d['next_visit_date'] - d['visit_date']).dt.days
#         )
#         .groupby('user_id', as_index=False)
#         .agg(biggest_window=('visit_date_diff', 'max'))
#         .sort_values('user_id')
# )


#############################################################################################################################

def biggest_window_between_visits_ranking(df: pd.DataFrame) -> pd.DataFrame:
    # Sort and add ranking
    df_ranked = (
        df
        .sort_values(['user_id', 'visit_date'])
        .assign(rn=lambda d: d.groupby('user_id').cumcount() + 1)
    )
    
    # Create next visit by incrementing rank
    df_next = df_ranked.copy()
    df_next['rn'] = df_next['rn'] - 1  # Decrement so we can join current with next
    df_next = df_next.rename(columns={'visit_date': 'next_visit_date'})
    
    # Merge current visits with next visits
    paired = (
        df_ranked
        .merge(
            df_next[['user_id', 'rn', 'next_visit_date']],
            on=['user_id', 'rn'],
            how='left'
        )
        .assign(
            next_visit_date=lambda d: d['next_visit_date'].fillna(pd.Timestamp('2021-01-01'))
        )
        .assign(
            visit_date_diff=lambda d: (d['next_visit_date'] - d['visit_date']).dt.days
        )
    )
    
    # Get maximum window per user
    result = (
        paired
        .groupby('user_id', as_index=False)
        .agg(biggest_window=('visit_date_diff', 'max'))
        .sort_values('user_id')
    )
    
    return result




print(biggest_window_between_visits_ranking(UserVisits))