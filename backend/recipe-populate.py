import random
from fractions import Fraction
import string
import psycopg2
import psycopg2.extras
import json
import pymongo
from pymongo import MongoClient

client = MongoClient('3.234.30.163', 27017)
db = client.grocery_list
recipes = db.recipes4
conn = psycopg2.connect(dbname='postgres', user='postgres', password='alawini411', host='cs411-project.cm2xo0osnz3p.us-east-1.rds.amazonaws.com', port='5432')
conn.autocommit = True
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
cur.execute("select ingredient_id, ingredient_name from ingredients2")
all_ingredients = cur.fetchall()
for ing in all_ingredients:
    ing[1] = ing[1].lower()

with open('./recipes2.json') as json_file:
    data = json.load(json_file)
    for recipe in data['data']:
        try:
#            instructions = recipe['instructions']
#            instructions = instructions.lower().split()
#            th = 0
#            tm = 0
#            for i in range(len(instructions)):
#                word = instructions[i]
#                if 'hour' in word:
#                    try:
#                        th += Fraction(instructions[i-1])
#                    except:
#                        pass
#                if 'minute' in word:
#                    try:
#                        tm += Fraction(instructions[i-1])
#                    except:
#                        pass
#            total = float(th) * 60 + float(tm)
#
            ingredients = recipe['ingredients']
            ids = []
            for ing1 in ingredients:
                ing1 = ing1.lower()
                choices = []
                choice_id = []
                for ing2 in all_ingredients:
                    ing3 = ing2[1]
                    if ing3 in ing1:
                        choices.append(ing3)
                        choice_id.append(ing2[0])
                ids.append(choice_id[choices.index(max(choices, key=len))])
            print (recipe['title'], ids)
            recipes.insert_one({"time": recipe['total_time'], "ingredient_ids": ids, "recipe": recipe})
        except Exception as e:
           print(e)
