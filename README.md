Gaining valuable insights from intricate data is crucial for making informed decisions in the contemporary realm of data analytics. As a data analyst striving for thorough analysis, I opted to utilize Northwind's freely available and well-organized sample data, which facilitates a wide array of practical analyses.

In this article, I'll guide you through making the NorthWind API pipeline. Instead of the usual way of extracting, transforming, and loading data (ETL), we'll use a different approach called ELT (Extract, Load, Transform). We'll use Python to get data from the Northwind API, put it into a PostgreSQL database, transform it with DBT (Data Build Tool), and then show the results in Power BI.




Data Extraction:

First, I got the raw data from the Northwind API using Python. I used libraries like Requests, Pandas, and SQLalchemy. Requests helped me make requests to the Northwind API, Pandas helped handle the data, and SQLalchemy helped connect to a relational database.

Once I imported the libraries I needed, I made a PostgreSQL database called "raw_northwind" to keep the data I got from the Northwind API. Then, I made a config.ini file to keep my PostgreSQL details safe, like the host, database, user, password, and port. This keeps the connection smooth and secure. Finally, I wrote the code to extract the data and save it in the PostgreSQL database.

# Import necessary libraries
import requests  # to connect to API
import pandas as pd  # for data transformation
import configparser  # to create my configurations
from sqlalchemy import create_engine  # this helps me communicate with PostgreSQL


# Create configuration interface
config = configparser.ConfigParser()
config.read('config.ini')


# Start PostgreSQL engine
postgres_config = config['postgres']
engine = create_engine(
    f"postgresql://{postgres_config['user']}:{postgres_config['password']}@{postgres_config['host']}/{postgres_config['database']}")


# Create API requests
endpoint =  'https://demodata.grapecity.com/northwind/api/v1/Customers'
api_response = requests.get(endpoint)
json_data = api_response.json()


# Print the JSON response
print(json_data)


# load data into progres
df = pd.json_normalize(json_data)
df.to_sql('customers', engine, if_exists= 'replace', index=False)
engine.dispose()
 

Here’s an explanation of each part of the code:

Importing Libraries:
import requests  # interact with APIs
import pandas as pd  # data manipulation
from sqlalchemy import create_engine
import configparser
import urllib.parse
Requests: This lets Python talk to APIs. Here, it's used to ask the Northwind API for data.
Pandas: This helps play with data, especially in tables. Here, it turns the Northwind API's info into a DataFrame (df).
create_engine: A function from SQLAlchemy that links Python to a PostgreSQL database.
configparser: This handles configuration files. It reads stuff like my PostgreSQL details (config.ini).

2. Defining the ETL process function:

def etl_process():
    # load my credentials from my config
    config = configparser.ConfigParser(interpolation=None)
    config.read('config.ini')

    # Create postgres engine
    postgres_config = config['postgres']
    encoded_password = urllib.parse.quote(postgres_config['password'], safe='')

    engine = create_engine(
        f"postgresql://{postgres_config['user']}:{encoded_password}@{postgres_config['host']}:{postgres_config['port']}/{postgres_config['database']}"
    )
etl_process(): This function I made covers the whole ETL (Extract, Transform, Load) process.
configparser: It reads settings from my config.ini file, like my PostgreSQL database details.
create_engine: It sets up a connection to work with the PostgreSQL database, using the info from config.ini.

3. API Request:

# Northwind API request for Categories
endpoint = 'https://demodata.grapecity.com/northwind/api/v1/Categories'
response = requests.get(url)
data = response.json()
endpoint: This variable holds the Northwind API's Customers URL.
requests.get(url): This line executes an HTTP GET request to the provided URL to fetch data.
response.json(): It interprets the response content as JSON, transforming it into a Python dictionary named 'data'.




4. Loading Data into PostgreSQL:

# Load data into postgres
df = pd.json_normalize(data)
df.to_sql('categories_raw', engine, if_exists='replace', index=False)
engine.dispose()
pd.json_normalize(data): This converts the JSON data obtained from the API into a Pandas DataFrame (df).
df.to_sql(...): It writes the DataFrame (df) into a PostgreSQL table named 'categories_raw'.
engine.dispose(): It closes the connection to the PostgreSQL database, releasing resources.




5. Executing ETL_Process:

etl_process()

This line serves to invoke the function etl_process(), triggering the complete ETL process upon execution of the script.

The aforementioned procedure was reiterated to obtain the diverse datasets essential for this project. Adjustments were also implemented as required, given that each dataset possesses a distinct URL. Additional datasets extracted encompassed Products, Orders, Regions, Categories, Employees, Shippers, Suppliers, and OrderDetails datasets. This iterative method not only demonstrated the adaptability of the code but also facilitated the compilation of a comprehensive dataset for thorough analysis and exploration.

Once that was done, my extracted data was successfully loaded into my PostgreSQL database.



Data Transformation:

As I advanced into the transformation phase of the ELT process, I employed DBT (Data Build Tool), an open-source platform designed to streamline data transformation tasks, particularly in relational databases such as PostgreSQL. I specifically chose the dbt-postgres adapter for seamless integration, enabling me to craft SQL queries within dbt models tailored for the Postgres environment.


Following this setup, I initiated and configured the dbt project using the dbt init command, beginning with structuring the project. Below is an outline of the dbt project structure:

The project structure contains the following folders:

dbt_packages: This directory houses packages installed through the packages.yml file.
logs: Here you'll find log files created during the execution of dbt.
macros: This directory stores custom macros specific to the project.
In my dbt project, I leverage two specific model types:.

- Staging models: These models function as exact replicas of the raw data housed within my Postgres database. They serve as dependable foundations for subsequent analysis.
- Production models: These models represent the culminated, refined datasets, prepared for seamless visualization and analysis across platforms such as Power BI.

5. seeds: This section comprises CSV files containing initial data sets intended for loading into the database.




The profiles.yml file is a configuration file used by dbt to define different environments (called profiles) and their connection settings. In this example, two profiles are defined: dev and prod. Each profile specifies the connection settings for a PostgreSQL database.

profiles.yml file contents:

default: This setting configures which “profile” dbt uses for this project. It is basically the name of the DBT project
outputs: A dictionary containing the different profiles within the group.
dev: The development profile with the following connection settings:
type: The type of database being used (in this case, PostgreSQL).
threads: The number of concurrent threads dbt should use when executing queries.
host, port, user, password, databasename, schema: Connection settings for the PostgreSQL database (host, port, username, password, database name, and schema) in the development environment.

After setting up the dbt project successfully, I began constructing my staging models. These models were designed to mirror the raw data stored in my PostgreSQL database, enhancing data integrity. They served dual roles: firstly, they provided a structured and dynamic representation of the raw data, and secondly, they acted as a guide for creating my production models. Once the staging models were established, I executed them using the dbt run command within my dbt project.

Within my dbt_project.yml file, I configured the staging models to materialize as views instead of tables. I strategically chose views for flexibility and easy adaptability to changes in raw data without compromising the production models, which held the final SQL scripts tailored for analysis and visualization. Views are virtual representations of the source data, but it is important to note that while views offer the advantage of generating data dynamically upon query, they do not store the data themselves.

 staging:
      +materialized: view 

The next step was to create a series of my production models. These models were designed to generate metrics such as sales trends across different time frames, product and category analysis, , employee performance evaluations, customer lifetime value estimations, supplier and territory-based analyses aimed at unraveling deeper insights into the dataset.

Below is a brief overview of one of my tables:

top_selling_products.sql: Identifies and ranks the top-selling products based on sales.
SELECT
P."productName" AS Products,
SUM(ordd."quantity") AS Total_quantity_sold,
COUNT (ordd."orderID") AS Total_no_of_orders
FROM
{{ ref('StgProduct') }} AS P
LEFT JOIN
{{ ref('StgOrderDetail') }} AS ordd
ON
P."productId" = ordd."productID"
GROUP BY
1
ORDER BY
2 DESC
LIMIT 10

After finishing the data transformation, my focus shifted to crafting an engaging and interactive dashboard. I utilized the dynamic features of cards to present important metrics and KPIs, ensuring easy comprehension of key data points. This strategy enabled viewers to grasp essential insights at a glance. Carefully selecting charts and graphs, I showcased trends in sales over time with line graphs and facilitated clear comparisons between product performances using bar charts. To illustrate revenue variations across different locations, I employed an interactive map to visualize distribution across countries.

To summarize, this project showcases the procedure of retrieving data from an API to achieve a thorough comprehension of Northwind Company's operations. Through the utilization of tools like Python, PostgreSQL, DBT, and Power BI, one can extract, sanitize, and transform data from diverse origins, subsequently visualizing it in a manner that yields valuable insights.

