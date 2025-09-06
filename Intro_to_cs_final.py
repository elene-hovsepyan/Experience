import csv
import matplotlib.pyplot as plt
import pandas as pd
import io
import matplotlib.dates as mdates
import base64


# Reading the CSV file
file_path = "/Users/elene/Downloads/sales_data_sample.csv"
data_set = []
with open(file_path, 'r', encoding='latin1') as file:
    data = csv.reader(file)
    for row in data:
        data_set.append(row)

# Extracting header and data
header = data_set[0]
data = data_set[1:]

# Converting to pandas DataFrame for additional analyses
sales_data = pd.DataFrame(data[1:], columns=header)
sales_data['ORDERDATE'] = pd.to_datetime(sales_data['ORDERDATE'], format='%m/%d/%Y %H:%M')
sales_data['SALES'] = pd.to_numeric(sales_data['SALES'])
sales_data['QUANTITYORDERED'] = pd.to_numeric(sales_data['QUANTITYORDERED'])
sales_data['CUSTOMER_NAME'] = sales_data['CONTACTLASTNAME'] + " " + sales_data['CONTACTFIRSTNAME']
sales_data['MONTH'] = sales_data['ORDERDATE'].dt.to_period('M')


def generate_report():
    # Key Statistics
    stats = pd.DataFrame({
        'Metric': ['Total Sales', 'Average Sales per Order', 'Total Unique Customers', 'Average Sales per Customer'],
        'Value': [
            sales_data['SALES'].sum(),
            sales_data['SALES'].mean(),
            sales_data['CUSTOMER_NAME'].nunique(),
            sales_data.groupby('CUSTOMER_NAME')['SALES'].sum().mean()
        ]
    })

    # Creating a buffer to save image data
    buf = io.BytesIO()

    # Visualizing Monthly Sales Over Time
    monthly_sales = sales_data.groupby('MONTH')['SALES'].sum().reset_index()
    monthly_sales['MONTH'] = monthly_sales['MONTH'].dt.to_timestamp()

    plt.figure(figsize=(12, 6))
    plt.plot(monthly_sales['MONTH'], monthly_sales['SALES'], marker='o', linestyle='-', color='b')
    plt.title('Monthly Sales Over Time')
    plt.xlabel('Month')
    plt.ylabel('Total Sales')
    plt.tight_layout()
    plt.savefig(buf, format='png')
    plt.close()

    # Embedding the plot into the HTML
    buf.seek(0)
    plot_url = 'data:image/png;base64,' + base64.b64encode(buf.read()).decode()

    # Generating the HTML report
    with open('sales_report.html', 'w') as file:
        file.write('<html><head><title>Sales Report</title></head><body>')
        file.write('<h1>Sales Performance Report</h1>')
        file.write(stats.to_html(index=False))
        file.write(f'<img src="{plot_url}">')
        file.write('</body></html>')

    print("Report has been generated and saved as 'sales_report.html'.")


# Functions for pie charts and other analyses
def country_by_price_pie_chart():
    sales_by_country = {}
    for row in data:
        country, sales = row[20], float(row[4])
        sales_by_country[country] = sales_by_country.get(country, 0) + sales

    # Creating a pie chart
    plt.figure(figsize=(10, 10))
    plt.pie(sales_by_country.values(), labels=sales_by_country.keys(), autopct='%1.1f%%', startangle=140)
    plt.title('Total Sales by Country')
    plt.show()


def product_distribution_pie_chart():
    df = pd.DataFrame(data[1:], columns=header)
    grouped_data = df.groupby(['COUNTRY', 'PRODUCTLINE']).size().reset_index(name='COUNT')
    pivot_table = grouped_data.pivot(index='COUNTRY', columns='PRODUCTLINE', values='COUNT').fillna(0)

    for country in pivot_table.index:
        plt.figure(figsize=(8, 8))
        plt.pie(pivot_table.loc[country], labels=pivot_table.columns, autopct='%1.1f%%', startangle=90)
        plt.title(f'Distribution of Products in {country}')
        plt.show()


def monthly_sales_line_chart():
    monthly_sales = sales_data.groupby('MONTH')['SALES'].sum().reset_index()
    monthly_sales['MONTH'] = monthly_sales['MONTH'].dt.to_timestamp()

    monthly_sales['MA'] = monthly_sales['SALES'].rolling(window=3).mean()

    plt.figure(figsize=(12, 6))
    plt.plot(monthly_sales['MONTH'], monthly_sales['SALES'], marker='o', linestyle='-', color='b', label='Actual Sales')
    plt.plot(monthly_sales['MONTH'], monthly_sales['MA'], linestyle='--', color='r', label='Moving Average')
    max_sales = monthly_sales['SALES'].max()
    min_sales = monthly_sales['SALES'].min()
    max_month = monthly_sales[monthly_sales['SALES'] == max_sales]['MONTH'].values[0]
    min_month = monthly_sales[monthly_sales['SALES'] == min_sales]['MONTH'].values[0]

    plt.annotate(f'Highest: {max_sales}', xy=(max_month, max_sales), xytext=(max_month, max_sales * 1.05),
                 arrowprops=dict(facecolor='green', shrink=0.05))
    plt.annotate(f'Lowest: {min_sales}', xy=(min_month, min_sales), xytext=(min_month, min_sales * 0.95),
                 arrowprops=dict(facecolor='red', shrink=0.05))

    plt.title('Monthly Sales Over Time')
    plt.xlabel('Month')
    plt.ylabel('Total Sales')
    plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
    plt.legend()
    plt.tight_layout()
    plt.show()


def perform_analyses():
    total_sales = sales_data['SALES'].sum()
    average_sales_per_order = sales_data['SALES'].mean()
    total_unique_customers = sales_data['CUSTOMER_NAME'].nunique()
    average_sales_per_customer = sales_data.groupby('CUSTOMER_NAME')['SALES'].sum().mean()
    total_quantity_ordered = sales_data['QUANTITYORDERED'].sum()
    conversion_rate_per_quantity = total_sales / total_quantity_ordered
    conversion_rate_per_order = total_sales / sales_data['ORDERNUMBER'].nunique()

    print("Profit Analysis:")
    print(f"Total Sales: {total_sales}")
    print(f"Average Sales per Order: {average_sales_per_order}\n")

    print("Customer Analysis:")
    print(f"Total Unique Customers: {total_unique_customers}")
    print(f"Average Sales per Customer: {average_sales_per_customer}\n")

    print("Conversion Rates Analysis:")
    print(f"Total Quantity Ordered: {total_quantity_ordered}")
    print(f"Conversion Rate per Quantity: {conversion_rate_per_quantity}")
    print(f"Conversion Rate per Order: {conversion_rate_per_order}\n")


# Main menu loop
while True:
    user_choice = input("""A - Determine total shipment price by country
    B - Determine shipment status
    C - Determine inventory turnover
    D - Perform Analyses
    E - Generate report       
    F - Monthly Sales Line Chart
    G - Pie Chart of Sales by Country
    H - Pie Chart of Product Distribution by Country                
    I - Exit\n""")
    if user_choice.upper() == 'A':
        sales_by_country = {}
        for row in data:
            country, sales = row[20], float(row[4])
            sales_by_country[country] = sales_by_country.get(country, 0) + sales
        for country, total_sales in sales_by_country.items():
            print(f"{country}: {round(total_sales, 2)}")
        print("")

    elif user_choice.upper() == 'B':
        shipment_status_count = {}
        for row in data:
            status = row[6]
            shipment_status_count[status] = shipment_status_count.get(status, 0) + 1
        for status, count in shipment_status_count.items():
            print(f"{status}: {count}")
        print("")

    elif user_choice.upper() == 'C':
        total_shipped_sales = sum(float(row[4]) for row in data if row[6] == 'Shipped')
        total_sales = sum(float(row[4]) for row in data)
        inventory_turnover = round((total_shipped_sales / total_sales * 100), 2)
        print(f"Shipped Sales: {total_shipped_sales}")
        print(f"Total Sales: {total_sales}")
        print(f"Inventory Turnover: {inventory_turnover} %")
        print("")

    elif user_choice.upper() == 'D':
        perform_analyses()

    elif user_choice.upper() == 'E':  # Assuming 'I' is the option for report generation
        generate_report()

    elif user_choice.upper() == 'F':
        monthly_sales_line_chart()

    elif user_choice.upper() == 'G':
        country_by_price_pie_chart()

    elif user_choice.upper() == 'H':
        product_distribution_pie_chart()

    elif user_choice.upper() == 'I':
        break

    else:
        print("Sorry, Your input does not match any letter mentioned above ")
        print("")
