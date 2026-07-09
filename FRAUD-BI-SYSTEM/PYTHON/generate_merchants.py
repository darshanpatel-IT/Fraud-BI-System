from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

categories = [
    "Electronics", "Grocery", "Fashion", "Travel",
    "Healthcare", "Food Delivery", "Fuel", "Entertainment",
    "Education", "Hotel"
]

merchant_statuses = ["Active", "Suspended"]

query = """
INSERT INTO merchants
(merchant_name, category, city, state, onboard_date, merchant_status)
VALUES (%s, %s, %s, %s, %s, %s)
"""

data = []

for i in range(500):
    values = (
        fake.company(),
        random.choice(categories),
        fake.city(),
        fake.state(),
        fake.date_between(start_date="-4y", end_date="today"),
        random.choices(merchant_statuses, weights=[90, 10])[0]
    )
    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("500 merchants inserted successfully!")

cursor.close()
conn.close()