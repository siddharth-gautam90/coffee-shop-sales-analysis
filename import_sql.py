import pandas as pd
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()


# Step 1: Read Excel file
df = pd.read_excel("data/Coffee Shop Sales.xlsx")

# Step 2: Connect to MySQL
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("MYSQL_PASSWORD"),
    database="coffee_shop_analysis"
)

cursor = connection.cursor()

# Step 3: Select original 11 columns
columns = [
    "transaction_id",
    "transaction_date",
    "transaction_time",
    "transaction_qty",
    "store_id",
    "store_location",
    "product_id",
    "unit_price",
    "product_category",
    "product_type",
    "product_detail"
]

df = df[columns]

# Step 4: Prepare SQL query
sql = """
INSERT INTO coffee_sales (
    transaction_id,
    transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail
)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

# Step 5: Convert data into tuples
data = [
    tuple(None if pd.isna(value) else value for value in row)
    for row in df.itertuples(index=False, name=None)
]

# Step 6: Insert data in batches
batch_size = 5000

for start in range(0, len(data), batch_size):
    batch = data[start:start + batch_size]
    cursor.executemany(sql, batch)
    connection.commit()

    print(f"Imported {min(start + batch_size, len(data))} / {len(data)} rows")

print("Data imported successfully!")

cursor.close()
connection.close()