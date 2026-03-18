import datetime as dt
import pandas as pd

def user_activity(df : pd.DataFrame) -> pd.DataFrame:
    
    df['activity_date'] = pd.to_datetime(df['activity_date'])

    df = (
        df[df['activity'] == 'login']
        .groupby('user_id')['activity_date']
        .min()
        .reset_index()
    )

    start_date = pd.to_datetime('2019-06-30') - dt.timedelta(days = 90)
    end_date = pd.to_datetime('2019-06-30')

    df = (
        df[df['activity_date'].between(start_date,end_date)]
        .groupby('activity_date')['user_id']
        .count()
        .reset_index()
        .rename(columns = {"user_id" :"user_count", "activity_date":"login_date"})
        .sort_values(by = 'login_date')
    )
    
    return df


data = {
    'user_id': [1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5],
    'activity': ['login', 'homepage', 'logout', 'login', 'logout', 'login', 'jobs', 'logout', 'login', 
                 'groups', 'logout', 'login', 'logout', 'login'],
    'activity_date': ['2019-05-01', '2019-05-01', '2019-05-01', '2019-06-21', '2019-06-21', 
                      '2019-01-01', '2019-01-01', '2019-01-01', '2019-06-21', '2019-06-21', 
                       '2019-06-21', '2019-03-01', '2019-03-01', '2019-06-21']
}

df = pd.DataFrame(data)
print(user_activity(df))