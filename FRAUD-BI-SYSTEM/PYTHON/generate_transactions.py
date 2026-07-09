from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

statuses = ["success", "failed", "pending"]
payment_methods = ["UPI", "Credit Card", "Debit Card", "Net Banking", "Wallet"]
channels = ["Mobile", "Web", "POS"]

query = """
INSERT INTO transactions
(customer_id, merchant_id, device_id, transaction_date, transaction_amount,
 transaction_status, payment_method, transaction_channel, risk_score)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

data = []

for i in range(50000):
    amount = round(random.uniform(100, 100000), 2)

    status = random.choices(
        statuses,
        weights=[90, 8, 2]
    )[0]

    if status == "failed":
        risk_score = random.randint(65, 95)
    elif amount >= 50000:
        risk_score = random.randint(55, 90)
    else:
        risk_score = random.randint(10, 50)

    values = (
        random.randint(1, 5000),
        random.randint(1, 500),
        random.randint(1, 6000),
        fake.date_time_between(start_date="-2y", end_date="now"),
        amount,
        status,
        random.choice(payment_methods),
        random.choice(channels),
        risk_score
    )

    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("50000 transactions inserted successfully!")

cursor.close()
conn.close()