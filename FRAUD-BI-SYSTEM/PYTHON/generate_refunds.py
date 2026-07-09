from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

refund_reasons = [
    "Duplicate Payment",
    "Customer Request",
    "Fraudulent Transaction",
    "Order Cancelled",
    "Technical Error",
    "Payment Failed"
]

refund_statuses = [
    "Processed",
    "Pending",
    "Rejected"
]

query = """
INSERT INTO refunds
(transaction_id, refund_date, refund_amount, refund_reason, refund_status)
VALUES (%s, %s, %s, %s, %s)
"""

# Pick 3000 unique transactions for refunds
transaction_ids = random.sample(range(1, 50001), 3000)

data = []

for transaction_id in transaction_ids:

    refund_amount = round(random.uniform(100, 50000), 2)

    values = (
        transaction_id,
        fake.date_between(start_date="-2y", end_date="today"),
        refund_amount,
        random.choice(refund_reasons),
        random.choices(
            refund_statuses,
            weights=[80, 15, 5]
        )[0]
    )

    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("3000 refunds inserted successfully!")

cursor.close()
conn.close()