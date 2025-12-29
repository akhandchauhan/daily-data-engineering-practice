
# -- Funnel Flow:
# -- Visit Portal (Website, e.g., myperfectresume.com)
# --   -> Register on Portal (Website, e.g., myperfectresume.com)
# --       -> Create a Resume
# --           -> Purchase subscription to download resume
# --               -> Can create/edit more resumes



import pandas as pd
from datetime import datetime

# Create portal table
portal = pd.DataFrame({
    'portal_id': [1, 2, 3, 4, 5, 6],
    'portal_code': ['MPR', 'RN', 'ZETY', 'LC', 'GEN', 'HELP'],
    'portal_name': ['My Perfect Resume', 'Resume Now', 'Zety', 'Live Career', 'Resume Genius', 'Resume Help']
})

# Create user_registration table
user_registration = pd.DataFrame({
    'user_id': [1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015],
    'portal_id': [2, 3, 2, 4, 3, 1, 2, 4, 2, 3, 5, 1, 2, 5, 2],
    'registration_datetime': pd.to_datetime([
        '2024-01-05 09:27:44', '2024-02-15 14:07:11', '2024-03-10 08:00:00', '2024-05-19 09:45:00',
        '2024-12-10 12:00:00', '2024-07-01 11:00:00', '2024-12-31 23:59:59', '2024-03-15 23:59:59',
        '2025-01-15 23:59:59', '2024-02-10 14:00:00', '2024-03-01 00:00:00', '2024-04-01 09:30:00',
        '2024-07-05 14:00:00', '2024-08-10 18:00:00', '2024-01-20 23:59:59'
    ]),
    'subscription_flag': ['Y', 'Y', 'N', 'Y', 'Y', 'Y', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'N', 'Y', 'Y'],
    'subscription_datetime': pd.to_datetime([
        '2024-01-06 10:00:00', '2024-02-15 15:30:00', None, '2024-05-20 10:00:00',
        '2024-12-15 12:00:00', '2024-07-02 09:00:00', '2025-01-01 00:15:00', None,
        '2025-02-01 00:15:00', None, '2024-03-02 09:00:00', None,
        None, '2024-08-11 08:00:00', '2025-01-01 00:15:00'
    ])
})

# Create resume_doc table
resume_doc = pd.DataFrame({
    'resume_id': [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012],
    'user_id': [1001, 1001, 1002, 1002, 1004, 1005, 1005, 1006, 1006, 1007, 1001, 1001],
    'date_created': pd.to_datetime([
        '2024-01-07 11:00:00', '2024-02-12 12:00:00', '2024-02-16 10:00:00', '2024-03-05 12:00:00',
        '2024-05-21 11:00:00', '2024-06-15 09:00:00', '2024-06-20 10:00:00', '2024-07-01 15:00:00',
        '2024-08-12 19:00:00', '2025-01-02 10:00:00', '2025-01-07 11:00:00', '2025-01-08 11:00:00'
    ]),
    'experience_years': [2, 3, 5, 7, 12, 0, 1, 8, 9, 20, 3, 3]
})

# # Display the dataframes
# print("Portal Table:")
# print(portal)
# print("\nUser Registration Table:")
# print(user_registration)
# print("\nResume Doc Table:")
# print(resume_doc)



# #  q1 = count of registration every month on resume now portal for 2024


# df = pd.merge(portal, user_registration, how ='inner', on ='portal_id')
# df = df[(df['portal_name'] == 'Resume Now') & (df['registration_datetime'].dt.year == 2024)]
# df['registration_month'] = df['registration_datetime'].dt.month
# df = df.groupby('registration_month', as_index = False)['user_id'].count().rename(columns = {'user_id' :'cnt'})
# print(df)


# # m2 
# result = (user_registration
#           .merge(portal, on='portal_id')
#           .query("portal_name == 'Resume Now' and registration_datetime.dt.year == 2024")
#           .assign(month=lambda x: x['registration_datetime'].dt.month)
#           .groupby('month', as_index=False)
#           .agg(registration_count=('user_id', 'count')))


##################################################################################################################################


#  Question 2:
# Which portal has the highest subscription rate for users registered in the last 30 days?
# Subscription rate = Total Subscriptions / Total Registrations

# from datetime import datetime, timedelta

# reference_date = pd.Timestamp.now()
# days_ago_30 = reference_date - timedelta(days=30)

# df = pd.merge(portal, user_registration, on = 'portal_id').query('registration_datetime >= @days_ago_30')
# df = (df.groupby('portal_name').agg
#       (total_registrations = ('registration_datetime','count'),
#        total_subscriptions = ('subscription_datetime','count')
#        )
#       .reset_index()
#       )
# df['subscription_rate'] = df['total_subscriptions']/ df['total_registrations']
# df = df.sort_values(by = 'subscription_rate', ascending = False)[['portal_name','subscription_rate']].head(1)
# print(df)


##############################################################################################


# -- q3
#-- how many registered users created less than 3 resumes


# df = pd.merge(user_registration, resume_doc, how ='left', on = 'user_id')
#df['resume_id'] = df['resume_id'].fillna(0)
# df = df.groupby('user_id')['resume_id'].count().reset_index()
# df = df[df['registration_datetime'] < 3].rename(columns= {'registration_datetime':'cnt'})
# df = df.shape[0]
# print(df)



# -- q4
# -- Create a list of users who subscribed in 2024 on the 'Zety' portal and get
# -- the experience_years on their first resume


# df = pd.merge(portal, user_registration, on = 'portal_id')
# df = pd.merge(df,resume_doc, on ='user_id')
# df = df[(df['portal_name'] == 'Zety') & (df['subscription_datetime'].dt.year == 2024)]
# df = df.sort_values(by = 'date_created')
# df['rnk'] = df.groupby('user_id')['date_created'].rank(method = 'dense')
# df = df[(df['rnk'] == 1 ) & (df['experience_years'] > 0)]
# print(df[['user_id','experience_years']])
