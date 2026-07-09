from faker import Faker
import random
from db_connection import get_connection

fake = Faker("en_IN")

conn = get_connection()
cursor = conn.cursor()

device_types = ["Mobile", "Laptop", "Tablet", "Desktop"]
os_list = ["Android", "iOS", "Windows", "macOS", "Linux"]
browsers = ["Chrome", "Firefox", "Safari", "Edge"]
app_versions = ["5.2.1", "5.1.0", "4.9.8", "6.0.0"]

query = """
INSERT INTO devices
(customer_id, device_type, os, browser, ip_address, app_version)
VALUES (%s, %s, %s, %s, %s, %s)
"""

data = []

for i in range(6000):
    values = (
        random.randint(1, 5000),
        random.choice(device_types),
        random.choice(os_list),
        random.choice(browsers),
        fake.ipv4_public(),
        random.choice(app_versions)
    )
    data.append(values)

cursor.executemany(query, data)
conn.commit()

print("6000 devices inserted successfully!")

cursor.close()
conn.close()