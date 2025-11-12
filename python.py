import mysql.connector

db = mysql.connector.connect(
    host="13.201.42.101",
    user="root",
    password="root123",
    database="testdb"
)

print("✅ Connected successfully!")


cursor = db.cursor()
cursor.execute("CREATE DATABASE IF NOT EXISTS company;")
cursor.execute("USE company;")

# Create a table
cursor.execute("""
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary INT
);
""")

# Insert dummy data
cursor.executemany("""
INSERT INTO employees (name, department, salary)
VALUES (%s, %s, %s);
""", [
    ("vijay", "IT", 70000),
    ("siva", "Engineering", 65000),
    ("srikanth", "Sales", 55000)
])

db.commit()
print("✅ Data inserted successfully!")
db.close()
