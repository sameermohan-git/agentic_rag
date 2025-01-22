import os
from dotenv import load_dotenv
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.tools import tool
import logging

# Load environment variables
print("Environment variables are loaded:", load_dotenv())

# Logging setup
logging.basicConfig(level=logging.INFO)

def _set_env():
    openai_key = os.environ["OPENAI_API_KEY"]
    logging.debug("OpenAI API Key:", openai_key)

def connect_postgres_from_uri():
    try:
        #Set Search Path to schema to connect
        uri = "postgresql+psycopg2://postgres:postgres@localhost:5432/employees?options=-c%20search_path=employees"
        db = SQLDatabase.from_uri(uri)

        logging.debug("connect_postgres_from_uri(): Available Tables: %s", db.get_usable_table_names())
        
        return db
    except Exception as e:
        logging.error("connect_postgres_from_uri(): Error connecting to database: %s", e)
        raise

@tool
def db_query_tool(query: str) -> str:
    """
    Execute a SQL query against the database and get back the result.
    """
    try:
        db = connect_postgres_from_uri()
        logging.info("db_query_tool(): Running query: %s", query)

        result = db.run_no_throw(query)
        if not result:
            return "Error: db_query_tool(): Query failed. Please rewrite your query and try again."
        return result
    except Exception as e:
        logging.error("db_query_tool(): Error running query: %s", e)
        return "Error: Unable to process the query."

def run_sql_tools():
    logging.info("run_sql_tools(): Running SQL tools")
    db = connect_postgres_from_uri()

    toolkit = SQLDatabaseToolkit(db=db, llm=ChatOpenAI(model="gpt-4o-mini"))
    tools = toolkit.get_tools()

    list_tables_tool = next(tool for tool in tools if tool.name == "sql_db_list_tables")
    get_schema_tool = next(tool for tool in tools if tool.name == "sql_db_schema")

    logging.info("run_sql_tools(): List Tables Tool Output: %s", list_tables_tool.invoke(""))
    logging.info("run_sql_tools(): Get Schema Tool Output: %s", get_schema_tool.invoke("department"))

def check_query_by_sql_agent(query: str) -> str:
    logging.info("check_query_by_sql_agent(): Checking query: %s", query)

    query_check_system = """You are a SQL expert with a strong attention to detail.
    Double check the PostgreSQL query for common mistakes, including:
    - Using NOT IN with NULL values
    - Using UNION when UNION ALL should have been used
    - Using BETWEEN for exclusive ranges
    - Data type mismatch in predicates
    - Properly quoting identifiers
    - Using the correct number of arguments for functions
    - Casting to the correct data type
    - Using the proper columns for joins

    If there are any of the above mistakes, rewrite the query. If there are no mistakes, just reproduce the original query.

    You will call the appropriate tool to execute the query after running this check."""

    query_check_prompt = ChatPromptTemplate.from_messages(
        [("system", query_check_system), ("placeholder", "{messages}")]
    )
    query_check = query_check_prompt | ChatOpenAI(model="gpt-4o-mini", temperature=0).bind_tools(
        [db_query_tool], tool_choice="required"
    )

    logging.info("check_query_by_sql_agent(): Query Check Tool Output: %s", query_check.invoke({"messages": [("user", query)]}))
    return

# Main execution
if __name__ == "__main__":
    _set_env()
    #run_sql_tools()
    query = "SELECT * FROM employees.department LIMITT 10;"
    #db_query_tool(query)
    check_query_by_sql_agent(query)
