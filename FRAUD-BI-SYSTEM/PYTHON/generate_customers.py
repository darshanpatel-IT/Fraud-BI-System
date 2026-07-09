from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

segments = ["Silver", "Gold", "Premium"]
kyc_statuses = ["Verified", "Pending", "Rejected"]

query = """
INSERT INTO customers
(customer_name, email, phone, city, state, signup_date, customer_segment, kyc_status)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
"""

for i in range(5000):
    values = (
        fake.name(),
        f"user{i+1}_{fake.email()}",
        fake.msisdn()[:10],
        fake.city(),
        fake.state(),
        fake.date_between(start_date="-3y", end_date="today"),
        random.choice(segments),
        random.choices(kyc_statuses, weights=[80, 15, 5])[0]
    )

    cursor.execute(query, values)

conn.commit()

print("5000 customers inserted successfully!")

cursor.close()
conn.close()