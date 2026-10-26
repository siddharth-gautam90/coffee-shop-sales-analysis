import mysql.connector as sq
connection =  sq.connect(
    host = "localhost",
    user = "root", 
    password = "password",
    database = "coffee_shop_analysis"
)
if connection.is_connected():
    print("My sql connection successful")
connection.close()