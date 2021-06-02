# Database Design and Development Project

## Project Goal
The project aims to build a database from scratch for a hiking orgarnization, demonstrating step-by-step process from user requirement analysis. We identify entities and relationships with assumptions about cardinality and participation, EER modeling, relational schema, normalization, indexing, and end with the CRUD for illustrating purposes. 
In addition, business queries are answered at the end, using advance SQL to generate reports.

## Methodologies and Tools:
- Relational Database with PostgreSQL
- ER and ERR Mapping with [diagrams.net](https://app.diagrams.net/?src=about)

## Workflow:
This project follows a [waterfall model](https://en.wikipedia.org/wiki/Waterfall_model), with the phases listed below.
1. Project Introduction
2. Requirements Gathering
3. Database Design
  2.1. Logical Design
  2.2. Physical Design 
4. Normalization
5. Data Types and Constraints
6. SQL DLL
7. SQL Indexing
8. Populating Tables
9. Dropping Tables
10. Business Inquiries with Advance PostgreSQL

## Directory
```
| - database-dev
|   -- CRUD                                 Includes all the CRUD operation
|       --- Create_Tables.sql               Includes queries to create tables
|       --- Drop_Tables.sql                 Includes queries to drop tables
|       --- Populate_Tables.sql             Includes queries to populate tables
|   -- SQL Queries                          Includes queries to generate reports
|       --- SQL_Commands.sql                Includes queries to answer business inquires
|   -- README.md                            Includes the project's overview
|   -- Database Development Report          Includes all the details about the project's development
```

## Future Development:
This database can be use in conjunction with internal software in order to provide better UI for users. 
