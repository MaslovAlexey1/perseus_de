import json
import psycopg2

conn = psycopg2.connect(
    host="postgres",
    port="5432",
    database="postgres",
    user="postgres",
    password="postgres")

with conn.cursor() as cur:
    with open('data/users.json') as my_file:
        data = json.load(my_file)
        query_sql = """ insert into users select * from json_populate_recordset(NULL::users, %s) """
        cur.execute(query_sql, (json.dumps(data),))
    with open('data/courses.json') as my_file:
        data = json.load(my_file)
        query_sql = """ insert into courses select * from json_populate_recordset(NULL::courses, %s) """
        cur.execute(query_sql, (json.dumps(data),))
    with open('data/certificates.json') as my_file:
        data = json.load(my_file)
        query_sql = """ insert into certificates select * from json_populate_recordset(NULL::certificates, %s) """
        cur.execute(query_sql, (json.dumps(data),))

conn.commit()
cur.close()