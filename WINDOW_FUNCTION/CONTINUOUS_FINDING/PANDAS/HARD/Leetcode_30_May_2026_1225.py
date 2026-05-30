# 1225. Report Contiguous Dates
# Table: Failed
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | fail_date    | date    |
# +--------------+---------+
# Primary key for this table is fail_date.
# Failed table contains the days of failed tasks.
# Table: Succeeded
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | success_date | date    |
# +--------------+---------+
# Primary key for this table is success_date.
# Succeeded table contains the days of succeeded tasks.
# A system is running one task every day. Every task is independent of the previous tasks.
# The tasks can fail or succeed.
# Write an SQL query to generate a report of period_state for each continuous interval
# of days in the period from 2019-01-01 to 2019-12-31.
# period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks succeeded.
# Interval of days are retrieved as start_date and end_date.
# Order result by start_date.
# The query result format is in the following example:
# Failed table:
# +------------+
# | fail_date  |
# +------------+
# | 2018-12-28 |
# | 2018-12-29 |
# | 2019-01-04 |
# | 2019-01-05 |
# +------------+
# Succeeded table:
# +--------------+
# | success_date |
# +--------------+
# | 2018-12-30   |
# | 2018-12-31   |
# | 2019-01-01   |
# | 2019-01-02   |
# | 2019-01-03   |
# | 2019-01-06   |
# +--------------+
# Result table:
# +--------------+------------+------------+
# | period_state | start_date | end_date   |
# +--------------+------------+------------+
# | succeeded    | 2019-01-01 | 2019-01-03 |
# | failed       | 2019-01-04 | 2019-01-05 |
# | succeeded    | 2019-01-06 | 2019-01-06 |
# +--------------+------------+------------+


import pandas as pd
pd.set_option('display.max_columns', None)
failed = pd.DataFrame({'fail_date': pd.to_datetime(
    ['2018-12-28', '2018-12-29', '2019-01-04', '2019-01-05'])})

succeeded = pd.DataFrame({'success_date': pd.to_datetime(
['2018-12-30', '2018-12-31', '2019-01-01', '2019-01-02', '2019-01-03', '2019-01-06'])})

failed_df = failed.copy()
failed_df['period_state'] = 'failed'
failed_df = failed_df.rename(columns = {'fail_date':'date'})

succeeded_df = succeeded.copy()
succeeded_df['period_state'] = 'succeeded'
succeeded_df = succeeded_df.rename(columns = {'success_date':'date'})

union_df = pd.concat([failed_df, succeeded_df])

df  = (
    union_df.sort_values(['date'])
    .loc[lambda d: (d['date'] >='2019-01-01') & (d['date'] < '2020-01-01')]
    .assign(
        state_rank = lambda d: d.groupby('period_state').cumcount()+1,
        streak = lambda d: d['date'] - pd.to_timedelta(d['state_rank'], unit ='D')
    )
    .groupby(['period_state','streak'], as_index = False)
    .agg(
        start_date = ('date','min'),
        end_date = ('date', 'max')
    )
    .sort_values('start_date')
    [['period_state','start_date','end_date']]
)
print(df)