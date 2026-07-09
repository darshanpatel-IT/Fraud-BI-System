import random
from db_connection import get_connection

conn = get_connection()
cursor = conn.cursor()

fraud_types = [
    "Card Testing",
    "Account Takeover",
    "Refund Abuse",
    "Fake Merchant",
    "High Risk Transaction",
    "Multiple Failed Attempts"
]

risk_levels = ["Low", "Medium", "High", "Critical"]
fraud_statuses = ["Confirmed Fraud", "Under Review", "Investigating"]
investigation_statuses = ["Open", "Under Review", "Closed"]

cursor.execute("""
SELECT transaction_id, transaction_date, risk_score
FROM transactions
WHERE risk_score >= 75
ORDER BY risk_score DESC
LIMIT 1500
""")

high_risk_transactions = cursor.fetchall()

query = """
INSERT INTO fraud_cases
(transaction_id, fraud_type, risk_level, detected_date, fraud_status,
 investigation_status, resolved_date)
VALUES (%s, %s, %s, %s, %s, %s, %s)
"""

data = []

for transaction_id, transaction_date, risk_score in high_risk_transactions:

    if risk_score >= 90:
        risk_level = "Critical"
    elif risk_score >= 80:
        risk_level = "High"
    elif risk_score >= 70:
        risk_level = "Medium"
    else:
        risk_level = "Low"

    investigation_status = random.choices(
        investigation_statuses,
        weights=[35, 40, 25]
    )[0]

    detected_date = transaction_date.date()

    resolved_date = None
    if investigation_status == "Closed":
        resolved_date = detected_date

    values = (
        transaction_id,
        random.choice(fraud_types),
        risk_level,
        detected_date,
        random.choice(fraud_statuses),
        investigation_status,
        resolved_date
    )

    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("1500 fraud cases inserted successfully!")

cursor.close()
conn.close()