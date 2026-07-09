from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

payment_statuses = ["success", "failed", "pending"]
payment_gateways = ["Razorpay", "PayU", "Cashfree", "PhonePe", "BillDesk"]

query = """
INSERT INTO payments
(transaction_id, payment_date, payment_status, payment_gateway, gateway_fee)
VALUES (%s, %s, %s, %s, %s)
"""

data = []

for transaction_id in range(1, 50001):
    payment_status = random.choices(
        payment_statuses,
        weights=[90, 8, 2]
    )[0]

    gateway_fee = round(random.uniform(2, 50), 2)

    values = (
        transaction_id,
        fake.date_time_between(start_date="-2y", end_date="now"),
        payment_status,
        random.choice(payment_gateways),
        gateway_fee
    )

    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("50000 payments inserted successfully!")

cursor.close()
conn.close()