import random
import string
import psycopg2
import psycopg2.extras

conn = psycopg2.connect(dbname='postgres', user='postgres', password='alawini411', host='cs411-project.cm2xo0osnz3p.us-east-1.rds.amazonaws.com', port='5432')
conn.autocommit = True
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

def randomString(stringLength=10):
    """Generate a random string of fixed length """
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))

for i in range(400):
    cur.execute("insert into recipe_to_ingredients(recipe_id, ingredient_id) values (%s, %s)", (random.randint(1, 40),random.randint(1, 70)))
