import pandas as pd

df = pd.read_csv('dataset/Chocolate Sales.csv')

# unique_sp = df['Sales Person'].drop_duplicates().sort_values().reset_index(drop=True)

# unique_sp = pd.DataFrame({
#     'Sales Person ID': range(1, len(unique_sp) + 1),
#     'Sales Person': unique_sp
# })

# unique_pd = df['Product'].drop_duplicates().sort_values().reset_index(drop=True)

# unique_pd = pd.DataFrame({
#     'Product ID': range(1, len(unique_pd) + 1),
#     'Product': unique_pd
# })

# df = df.merge(unique_sp, on='Sales Person', how='inner') \
#     .merge(unique_pd, on='Product', how='inner')

# df = df[[
#     'Sales Person ID',
#     'Sales Person',
#     'Country',
#     'Product ID',
#     'Product',
#     'Date',
#     'Amount',
#     'Boxes Shipped'
# ]]

df.columns = [c.replace(' ', '_') for c in df.columns]

df.to_csv('Chocolate Sales.csv', index=False)