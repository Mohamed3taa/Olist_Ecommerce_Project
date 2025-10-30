import os
import pyodbc
import pandas as pd

# --------------------------------------------
# 1️⃣ إعداد الاتصال بـ SQL Server
# --------------------------------------------
conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=SasakiKojiro;'  
    'DATABASE=Olist_Ecommerce;'  
    'Trusted_Connection=yes;'
)

# --------------------------------------------
# --------------------------------------------
output_folder = r"D:\Data Analysis\Final\Cleaned_Data"
os.makedirs(output_folder, exist_ok=True)


# --------------------------------------------
views = [
    "VW_Cleaned_Products",
    "vw_customers_cleaned",
    "vw_geolocation_cleaned",
    "vw_product_category_translation_cleaned",
    "vw_order_items_cleaned",
    "vw_order_payments_cleaned",
    "vw_sellers_cleaned",
    "vw_order_reviews_cleaned",
    "vw_orders_cleaned"
]


# --------------------------------------------
for view in views:
    query = f"SELECT * FROM {view}"
    try:
        df = pd.read_sql(query, conn)
        csv_path = os.path.join(output_folder, f"{view}.csv")
        df.to_csv(csv_path, index=False, encoding="utf-8-sig")
        print(f"✅ Saved: {csv_path}")
    except Exception as e:
        print(f"Error exporting {view}: {e}")
# --------------------------------------------
conn.close()
print("\n All cleaned views exported successfully to CSV!")
