import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


file_path = "data/Coffee Shop Sales.xlsx"
df = pd.read_excel(file_path)

# print("Data Shape", df.shape)
# print(df.head())
# print(df.columns.tolist())
# print("Missing value", df.isnull().sum())
# print(df.dtypes)

df["transaction_Date"] = pd.to_datetime(df["transaction_date"])
df["Revenue"] = df["transaction_qty"] * df["unit_price"] 

df["Month"] = df["transaction_date"].dt.month_name()
df["Day_Name"] = df["transaction_date"].dt.day_name()

# print(df.head())

#Sales Analysis
total_transactions = df["transaction_id"].unique()
total_units_sold = df["transaction_qty"].sum()
total_revenue = df["Revenue"].sum()
average_transaction_value = df.groupby("transaction_id")["Revenue"].sum().mean()

#Summary
# print("Total Transaction", total_transactions)
# print(" Total Units Sold" , total_units_sold)
# print("Total Revenue", round(total_revenue), 2)
# print("ACg Transactions Value", round(average_transaction_value, 2))


#Category Wise Revenue
category_sales = df.groupby("product_category")["Revenue"].sum()
category_sales = category_sales.sort_values(ascending=False)

# print(category_sales)

#======Data Validation
# print("Total rows", len(df))
# print("Unique Transactions",
#     df["transaction_id"].unique()
#     )
# print("Duplicated tracnsaction ids",
#     df["transaction_id"].duplicated().sum()
# )
# print("Total revenue",
#     round(df["Revenue"].sum(), 2)
# )
# print("Missing value",
#     df.isnull().sum().sum()
# )

#========== Store - wise sales analysis
store_sales = df.groupby("store_location").agg(
    total_revenue = ("Revenue", "sum"),
    total_units = ("transaction_qty", "sum"),
    total_transactions = ("transaction_id", "nunique")
)
store_sales = store_sales.sort_values(
    by = "total_revenue",
    ascending=False
)

# print(store_sales.round(2))
best_store = store_sales["total_revenue"].idxmax()
best_revenue = store_sales.loc[best_store, "total_revenue"]

# print(best_store)
# print(round(best_revenue, 2))

#============== Monthly sales analysis
monthly_sales = df.groupby("Month").agg(
    total_revenue = ("Revenue", "sum"),
    total_units = ("transaction_qty", "sum"),
    total_transactions = ("transaction_id", "nunique")
)

#arrange months in calendar order
month_order = ["January", "February", "March",
               "April", "May", "June"]
monthly_sales = monthly_sales.reindex(month_order)
# print(monthly_sales.round(2))

#=======Best month===
best_month = monthly_sales["total_revenue"].idxmax() 
best_revenue = monthly_sales.loc[best_month, "total_revenue"]

# print(best_month)
# print("Revenue", round(monthly_sales.loc[best_month, "total_revenue"], 2))

#=================== Monthly sales visualization
df["Month"] = df["transaction_Date"].dt.month_name()
monthly_sales["total_revenue"].plot(
    kind="bar",
    figsize=(10, 5),
    title= "Monthly Coffee Shop Revenue"
)
plt.figure(figsize=(10, 5))
plt.bar(
    monthly_sales.index,
    monthly_sales["total_revenue"]
)
plt.xlabel("Month")
plt.ylabel("Revenue ($)")
plt.xticks(rotation = 45)
plt.tight_layout()

plt.savefig("Monthly_revenue.png", dpi = 300)
plt.close()


#================ PRODUCT PERFORMANCE ANALYSIS
product_sales = df.groupby("product_category").agg(
    total_revenue = ("Revenue", "sum"),
    total_units = ("transaction_qty", "sum"),
    total_transactions = ("transaction_id", "nunique")
)
product_sales = product_sales.sort_values(
    by = "total_revenue",
    ascending= False
)

# print("Product category performance", product_sales.round(2))

# #top 5 categories by revenue
# print(product_sales.head(5).round(2))

# #best selling category by units
# best_category = product_sales["total_units"].idxmax()
# print(best_category)
# print(
#     "Unit Sold:", int(product_sales.loc[best_category, "total_units"])
# )

#=================== DAY-WISE SALES ANALYSIS=====
df["Day_Name"] = df["transaction_date"].dt.day_name()
day_order = ["Monday", "Tuesday", "Wednesday", 
             "Thursday", "Friday", "Saturday", "Sunday"]

daily_sales = df.groupby("Day_Name").agg(
    total_revenue = ("Revenue", "sum"),
    total_units = ("transaction_qty", "sum"),
    total_transactions = ("transaction_id", "nunique")
)
daily_sales = daily_sales.reindex(day_order)
best_day = daily_sales["total_revenue"].idxmax()

# print(daily_sales.round(2))
# print("Highest revenue day", best_day)
# print(
#     "Revenue :" , round(daily_sales.loc[best_day, "total_revenue"], 2)
# )



#---------========== Monthly Revenue Trend=======
plt.figure(figsize=(10, 5))

plt.plot(
    monthly_sales.index,
    monthly_sales["total_revenue"],
    marker = "o"
)

plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue ($)")
plt.xticks(rotation = 45)
plt.grid(True, alpha = 0.3)
plt.tight_layout()
plt.savefig("monthly_revenue.png", dpi =300)
plt.close()


#---------========== Store-wise Revenue=======
plt.figure(figsize=(8, 5))

store_sales["total_revenue"].plot(kind="bar")

plt.title("Revenue By Store")
plt.xlabel("Store")
plt.ylabel("Revenue ($)")
plt.xticks(rotation = 30)
plt.tight_layout()
plt.savefig("store_revenue.png", dpi =300)
plt.close()


#---------========== Top 5 Product Categories=======
plt.figure(figsize=(9,5))

product_sales.head(5)["total_revenue"].plot(kind="bar")

plt.title("Top 5 product Categories by Revenue")
plt.xlabel("Product Category")
plt.ylabel("Revenue ($)")
plt.xticks(rotation = 30)
plt.tight_layout()
plt.savefig("top_categories.png", dpi =300)
plt.close()

print(df.columns.to_list())