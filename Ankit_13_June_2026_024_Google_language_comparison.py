# find companies who have atleast 2 users who speaks both
# english and german

import pandas as pd
pd.set_option("display.max_columns", None)

company_users = pd.DataFrame({
    "company_id": [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2],
    "user_id":    [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 6, 7],
    "language":   ['English', 'German', 'English', 'German', 'English', 'English',
                   'English', 'German', 'Spanish', 'German', 'Spanish', 'English']
})

df = (  # ❌ too generic; name it 'result' or 'qualifying_companies'
    company_users[company_users['language'].isin(['English','German'])]  
    .groupby(['company_id','user_id'], as_index=False)['language']  # ❌ prefer .agg() to skip the rename below
    .nunique()
    .rename(columns={'language': 'count'})  # ❌ 'count' shadows pd.DataFrame.count(); use 'lang_count'
    .loc[lambda d: d['count'] == 2]       
    .groupby('company_id', as_index=False)['user_id']
    .count()
    .rename(columns={'user_id': 'user_count'})
    .loc[lambda d: d['user_count'] >= 2]
    [["company_id"]]  # ❌ missing .reset_index(drop=True); index is non-sequential when filtered rows aren't at 0
)

print(df)


##################################################################################
# m2

english = (company_users[company_users['language'] == 'English']
           [['company_id', 'user_id']].drop_duplicates())

german  = (company_users[company_users['language'] == 'German']
           [['company_id', 'user_id']].drop_duplicates())

result = (
    english.merge(german, on=['company_id', 'user_id'])
    .groupby('company_id')
    .agg(bilingual_count=('user_id', 'count'))
    .reset_index()
    .query('bilingual_count >= 2')
    [['company_id']]
    .reset_index(drop=True)
)
