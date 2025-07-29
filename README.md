Deploying WMS PL/SQL code using AI

Description:
Use a Large Language Model to intelligently analyse an existing PL/SQL package and insert an appropriate UPDATE statement in the correct section, 
based on user input such as table name, column names, and conditions

Modules to be created 

Code generation and updation module
Code deployment module 
Code validation module



Prompt used:

*Code generation and updation module

1. Can you generate single script of PL/SQL package and associated components creation
 for order management process in WMS application
   
2. I need to add a update statement to change the order status as "Allocated" in the PL/SQL package by comparing the inventory table. I need to  check the fields in inventory where
qty_on_hand should not be equal to zero , qty_allocated should be zero and 
unlocked_status should not be locked.

3. when I say run code generation and updation module You should create 2 scripts for initial pl sql package creation and updated PL/sql package creation based on the requirements provided from me.


*Code deployment module( In progress)

I need to create a new Oracle database version to run the PL SQL package ,so create and run the database connection and give me as a one time prompt and you should not store the connection details.


*Code validation module 


Synthetic data:

1. Can you use a python script using faker library and refer the tables from the above sql package script and provide me the sql insert statement from the python script outcome
