# ===============================================================
# 📊 Olist E-commerce Dashboard | Streamlit + SQL Server + Plotly
# Author: Mohammad Elbassal
# ===============================================================

import streamlit as st
import pandas as pd
import pyodbc
import plotly.express as px

st.set_page_config(page_title="Olist E-commerce Dashboard", page_icon="📦", layout="wide")

# ------------------ Custom CSS ------------------
st.markdown("""
<style>
.metric-card {
    text-align:center; background:#f9fafc; padding:18px; border-radius:12px;
    box-shadow:1px 1px 6px rgba(0,0,0,0.1); margin:4px;
}
.metric-label { color:#1f77b4; font-weight:bold; font-size:20px; }
.metric-value { color:#000; font-weight:700; font-size:26px; margin-top:6px; }
</style>
""", unsafe_allow_html=True)

st.title("📦 Olist E-commerce Interactive Dashboard")
st.markdown("### Powered by SQL Server • Built with Streamlit & Plotly 💡")
st.markdown("---")

# ------------------ Load Data ------------------
@st.cache_data
def load_data():
    try:
        conn = pyodbc.connect(
            'DRIVER={SQL Server};'
            'SERVER=SasakiKojiro;'
            'DATABASE=Olist_Ecommerce;'
            'Trusted_Connection=yes;'
        )
    except Exception as e:
        st.error(f"❌ Could not connect to SQL Server: {e}")
        return [None]*6

    df_orders = pd.read_sql("""
        SELECT order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date
        FROM orders_dataset
    """, conn)
    df_items = pd.read_sql("""
        SELECT order_id, product_id, seller_id, price, freight_value
        FROM order_items_dataset
    """, conn)
    df_customers = pd.read_sql("""
        SELECT customer_id, customer_unique_id, customer_state, customer_city
        FROM customers_dataset
    """, conn)
    df_products = pd.read_sql("""
        SELECT product_id, product_category_name
        FROM products_dataset
    """, conn)
    df_reviews = pd.read_sql("""
        SELECT order_id, review_score
        FROM order_reviews_dataset
    """, conn)
    df_payments = pd.read_sql("""
        SELECT order_id, payment_type
        FROM order_payments_dataset
    """, conn)

    conn.close()
    return df_orders, df_items, df_customers, df_products, df_reviews, df_payments

df_orders, df_items, df_customers, df_products, df_reviews, df_payments = load_data()
if df_orders is None:
    st.stop()
st.success("✅ Data loaded successfully from SQL Server!")

# ------------------ Preprocessing ------------------
df_orders['order_purchase_timestamp'] = pd.to_datetime(df_orders['order_purchase_timestamp'], errors='coerce')
df_orders['order_delivered_customer_date'] = pd.to_datetime(df_orders['order_delivered_customer_date'], errors='coerce')

# ------------------ KPIs ------------------
total_orders = df_orders['order_id'].nunique()
total_revenue = (df_items['price'].fillna(0) + df_items['freight_value'].fillna(0)).sum()
unique_customers = df_customers['customer_unique_id'].nunique()
avg_review = df_reviews['review_score'].mean()

st.subheader("✨ Key Performance Indicators")
col1, col2, col3, col4 = st.columns(4)
col1.markdown(f"<div class='metric-card'><div class='metric-label'>🛒 Total Orders</div><div class='metric-value'>{total_orders:,}</div></div>", unsafe_allow_html=True)
col2.markdown(f"<div class='metric-card'><div class='metric-label'>💰 Total Revenue</div><div class='metric-value'>${total_revenue:,.0f}</div></div>", unsafe_allow_html=True)
col3.markdown(f"<div class='metric-card'><div class='metric-label'>👥 Unique Customers</div><div class='metric-value'>{unique_customers:,}</div></div>", unsafe_allow_html=True)
col4.markdown(f"<div class='metric-card'><div class='metric-label'>⭐ Average Rating</div><div class='metric-value'>{avg_review:.2f}</div></div>", unsafe_allow_html=True)

st.markdown("---")

# ------------------ Slicers (single select only) ------------------
st.sidebar.header("🔍 Filter Options")
status_filter = st.sidebar.selectbox("Order Status", options=["All"] + sorted(df_orders['order_status'].dropna().unique()))
category_filter = st.sidebar.selectbox("Category", options=["All"] + sorted(df_products['product_category_name'].dropna().unique()))
state_filter = st.sidebar.selectbox("Customer State", options=["All"] + sorted(df_customers['customer_state'].dropna().unique()))

# ------------------ Merge for Filters ------------------
merged_all = (
    df_items
    .merge(df_orders, on="order_id", how="left")
    .merge(df_customers, on="customer_id", how="left")
    .merge(df_products, on="product_id", how="left")
)
merged_all["Total_Revenue"] = merged_all["price"].fillna(0) + merged_all["freight_value"].fillna(0)

if status_filter != "All":
    merged_all = merged_all[merged_all["order_status"] == status_filter]
if category_filter != "All":
    merged_all = merged_all[merged_all["product_category_name"] == category_filter]
if state_filter != "All":
    merged_all = merged_all[merged_all["customer_state"] == state_filter]

# ------------------ Charts ------------------

# Sales Trend
st.subheader("📆 Sales Trend Over Time")
monthly = merged_all.copy()
monthly["month"] = pd.to_datetime(monthly["order_purchase_timestamp"], errors="coerce").dt.to_period("M")
monthly_sales = monthly.groupby("month").size().reset_index(name="Orders")
monthly_sales["month"] = monthly_sales["month"].dt.to_timestamp()
fig_trend = px.line(monthly_sales, x="month", y="Orders", markers=True,
                    title="Monthly Orders Trend", line_shape="spline",
                    color_discrete_sequence=["#1f77b4"])
st.plotly_chart(fig_trend, use_container_width=True, key="trend")

st.markdown("---")

# Top Product Categories
st.subheader("🏆 Top 10 Product Categories by Revenue")
top_categories = (
    merged_all.groupby("product_category_name")["Total_Revenue"]
    .sum().reset_index()
    .sort_values(by="Total_Revenue", ascending=False)
    .head(10)
)
fig_cat = px.bar(top_categories, x="product_category_name", y="Total_Revenue",
                 color="Total_Revenue", color_continuous_scale="Blues",
                 title="Top 10 Categories by Revenue")
fig_cat.update_layout(xaxis_tickangle=-45)
st.plotly_chart(fig_cat, use_container_width=True, key="cat")

st.markdown("---")

#  Average Revenue per Customer by State
st.subheader("💵 Average Revenue per Customer by State")

# حساب الإيراد الإجمالي وعدد العملاء لكل ولاية
state_customer_revenue = (
    merged_all.groupby("customer_state")
    .agg(
        Total_Revenue=("Total_Revenue", "sum"),
        Unique_Customers=("customer_unique_id", "nunique")
    )
    .reset_index()
)
state_customer_revenue["Avg_Revenue_per_Customer"] = (
    state_customer_revenue["Total_Revenue"] / state_customer_revenue["Unique_Customers"]
)


fig_avg_rev = px.bar(
    state_customer_revenue.sort_values("Avg_Revenue_per_Customer", ascending=True),
    x="Avg_Revenue_per_Customer",
    y="customer_state",
    orientation="h",
    text=state_customer_revenue["Avg_Revenue_per_Customer"].round(2),
    color="Avg_Revenue_per_Customer",
    color_continuous_scale="Blues",
    title="Average Revenue per Customer by State"
)


fig_avg_rev.update_traces(textposition="outside")
fig_avg_rev.update_layout(
    xaxis_title="Average Revenue (USD)",
    yaxis_title="State",
    plot_bgcolor="rgba(0,0,0,0)",
    paper_bgcolor="rgba(0,0,0,0)",
    showlegend=False
)

st.plotly_chart(fig_avg_rev, use_container_width=True, key="avg_revenue_state")



# Payment Methods
st.subheader("💳 Payment Method Distribution")
payment_filtered = df_payments[df_payments["order_id"].isin(merged_all["order_id"])]
payment_counts = payment_filtered["payment_type"].value_counts().reset_index()
payment_counts.columns = ["Payment Type", "Count"]
fig_payment = px.pie(payment_counts, names="Payment Type", values="Count", hole=0.4,
                     color_discrete_sequence=px.colors.qualitative.Set2,
                     title="Payment Methods Breakdown")
fig_payment.update_traces(textinfo="percent+label")
st.plotly_chart(fig_payment, use_container_width=True, key="payment")

st.markdown("---")

# 5️⃣ Reviews
st.subheader("⭐ Customer Review Ratings")
review_dist = df_reviews['review_score'].value_counts().reset_index()
review_dist.columns = ['Review Score', 'Count']
fig_reviews = px.bar(
    review_dist.sort_values('Review Score'),
    x='Review Score', y='Count',
    color='Review Score',
    color_continuous_scale=['#ff4b4b','#fbc531','#44bd32'],
    text='Count',
    title="Customer Ratings Distribution"
)
fig_reviews.update_traces(textposition='outside')
st.plotly_chart(fig_reviews, use_container_width=True, key="review")

# ------------------ Footer ------------------
st.markdown("---")
st.markdown("""
**Developed by [Mohammad Elbassal](https://www.linkedin.com/in/mohammad-elbassal/)**  
💡 Built using Streamlit • SQL Server • Plotly Express  
📅 Project: Olist E-commerce Analytics Dashboard
""")
