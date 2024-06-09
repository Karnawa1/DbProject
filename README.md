>#### Prerequisites

Ensure you have PostgreSQL installed and access to a database management system like pgAdmin or command-line tools like psql.

#### 1. Creating the Databases

To get started, you need to create two separate databases: one for the OLTP system and another for the OLAP system. Use the following commands to create these databases:

`-- Create OLTP Database
CREATE DATABASE Porsche;

-- Create OLAP Database
CREATE DATABASE DimPorsche;`

#### 2. Creating Tables and Relationships

Once the databases are created, you will need to set up tables and their relationships.

-   For the OLTP database, run the script stored in `oltp.sql`. This script contains all necessary table creation commands and the relationships between them.
-   For the OLAP database, use the `olap.sql` script.

You can run these scripts via pgAdmin or another DBMS of your choice by opening the query tool, loading the SQL file, and executing it.

#### 3. Loading Initial Data

To load initial data into the OLTP system, use the script provided in the `first_csv/oltp_first_load.sql` file. Before running the script, ensure to adjust the file paths in the script to point to your CSV files correctly. This script loads data into the OLTP tables.

Similarly, for the OLAP system, adjust and execute the script in `second_csv/olap_first_load.sql`.

#### 4. Transferring Data from OLTP to OLAP

To transfer data from the OLTP system (Porsche) to the OLAP system (DimPorsche), use the ETL script provided in the `ETL2.sql` file. Before executing this script, make sure to change the database connection details, including the password, to match your environment settings.

#### 5. Running the Scripts

All scripts should be executed through a DBMS like pgAdmin. Follow these steps for each script:

-   Open pgAdmin and connect to your PostgreSQL server.
-   Select the appropriate database (Porsche for OLTP and DimPorsche for OLAP).
-   Open the SQL Editor from the toolbar.
-   Load the .sql file or copy the SQL command into the editor.
-   Execute the script by clicking the 'Run' button or pressing F5.

### Important Notes

-   Always ensure that the PostgreSQL server is running before attempting to execute any scripts.
-   Verify that the paths to CSV files are correct in the data loading scripts to avoid errors during the data import process.
-   Regularly back up your databases before running large import operations or structural changes like those defined in the provided SQL scripts.

By following these instructions, you should be able to successfully set up and populate your OLTP and OLAP databases for further analysis and operations.
