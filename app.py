import bottle
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import pandas as pd
from langchain.agents import create_pandas_dataframe_agent
from langchain.llms import AzureOpenAI
import os
from datetime import datetime
from sqlalchemy import create_engine
import urllib.parse
import sqlalchemy

# Set up SQLAlchemy connection string
conn_str = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=lovekush.database.windows.net;DATABASE=Student;UID=kush;PWD=Abc@12345"

# Create SQLAlchemy engine
quoted_conn_str = urllib.parse.quote_plus(conn_str)
engine = create_engine(f'mssql+pyodbc:///?odbc_connect={quoted_conn_str}')

# Execute SQL query and fetch data into a DataFrame
query = 'SELECT * FROM T1'
df = pd.read_sql(query, engine)

# Set up OpenAI environment variables
os.environ["OPENAI_API_TYPE"] = "azure"
os.environ["OPENAI_API_KEY"] = "a4a5739f06fa4fffbeb19b3d35b4ece9"
os.environ["OPENAI_API_BASE"] = "https://pbiaoi.openai.azure.com/"
os.environ["OPENAI_API_VERSION"] = "2022-12-01"

# Create an instance of AzureOpenAI language model
llm = AzureOpenAI(
    deployment_name="PBIdavinci",
    model_name="text-gpt-3.5-turbo",
    openai_api_key="a4a5739f06fa4fffbeb19b3d35b4ece9",
    model_kwargs={
        "api_type": "azure",
        "api_version": "2022-12-01"
    }
)


# Create the agent
agent = create_pandas_dataframe_agent(llm, df)

# Initialize Bottle app
app = bottle.Bottle()

@app.route('/')
def home():
    #return bottle.template('index.html')
    return bottle.template('index.tpl')


@app.route('/chat', method='POST')
def ask_question():
    question = bottle.request.forms.get('question').strip()
    if not question:
        return "Please enter a question."
    try:
        response = agent.run(question)
        return response
    except Exception as e:
        return str(e)

# Set up static file directory
app_dir = os.path.dirname(os.path.abspath(__file__))
static_dir = os.path.join(app_dir, 'static')
app.mount('/static', bottle.static_file(static_dir, root=static_dir))

# Start the Bottle web server
if __name__ == '__main__':
    bottle.run(app, host='localhost', port=8080)   #Working
    #bottle.run(app, host='localhost', port=443)

    #bottle.run(app, host='https://mydemochatbot.azurewebsites.net', port=80)

