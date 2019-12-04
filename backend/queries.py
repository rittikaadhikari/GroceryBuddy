import psycopg2
import psycopg2.extras
from psycopg2.extensions import AsIs
import pymongo
from pymongo import MongoClient
from bson.json_util import dumps
import json
import itertools
import random

client = MongoClient('3.234.30.163', 27017)
db = client.grocery_list
grocery_list = db.grocery_list
fridge = db.fridge
recipes = db.recipes4
conn = psycopg2.connect(dbname='postgres', user='postgres', password='alawini411', host='cs411-project.cm2xo0osnz3p.us-east-1.rds.amazonaws.com', port='5432')
conn.autocommit = True
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
recipe_pos = 0
combo_meals = []
num_refreshes = 0

def get_dict_resultset(sql, params):
    cur.execute (sql, params)
    ans =cur.fetchall()
    if not ans:
        return None
    dict_result = []
    for row in ans:
        dict_result.append(dict(row))
    return {'result': dict_result}

def create_new_user(fname, lname, username, password):
    query = """INSERT INTO users(first_name, last_name, username, password) values (%s, %s, %s, %s) returning *"""
    params = (fname, lname, username, password)
    return get_dict_resultset(query, params)


def get_user_data(username):
    query = """SELECT * FROM users where username = %s"""
    params = (username,)
    return get_dict_resultset(query, params)

def update_user(ouser, fname, lname, username, password):
    if username:
        query = """UPDATE users set first_name = %s, last_name =  %s, username = %s, password = %s where username = %s returning *"""
        params = (fname, lname, username, password, ouser)
    else:
        query = """UPDATE users set first_name = %s, last_name =  %s, password = %s where username = %s returning *"""
        params = (fname, lname, password, ouser)
    return get_dict_resultset(query, params)

def delete_user(username):
    query = """DELETE FROM users where username = %s returning *"""
    params = (username, )
    return get_dict_resultset(query, params)

def insert_into_grocery_list(username, ingredient):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.update({"user_id":user_id}, {"$push": {"user_ingredients": ingredient}}, upsert=True)
    if res.get('upserted'):
        res.pop('upserted')
    return res

def delete_from_grocery_list(username, ingredient):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.update({"user_id":user_id}, {"$pull": {"user_ingredients": ingredient}})
    return res

def get_grocery_list(username):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.find_one({"user_id":user_id}, {"user_ingredients": 1, "_id": 0})
    return res

def edit_ingredient_in_grocery_list(username, old_ingredient, new_ingredient):
    res1 = delete_from_grocery_list(username, old_ingredient)
    res2 = insert_into_grocery_list(username, new_ingredient)
    return res2


def create_ingredient(ingredient_name, ingredient_category):
    query = """INSERT INTO ingredients2(ingredient_name, ingredient_category) values (%s, %s) returning *"""
    params = (ingredient_name, ingredient_category)
    return get_dict_resultset(query, params)


def get_ingredient(ingredient_name):
    query = """SELECT * FROM ingredients2 where ingredient_name = %s"""
    params = (ingredient_name,)
    return get_dict_resultset(query, params)

def get_ingredient_by_category(ingredient_category):
    query = """SELECT * FROM ingredients2 where ingredient_category = %s"""
    params = (ingredient_category,)
    return get_dict_resultset(query, params)

def autocomplete_ingredients(ingredient_name):
    query = """SELECT ingredients2.ingredient_name FROM ingredients2 where ingredients2.ingredient_name ilike %s"""
    params = (ingredient_name + "%", )
    return get_dict_resultset(query, params)

def update_ingredient(oingredient, ningredient, ncategory):
    query = """UPDATE ingredients2 set ingredient_name = %s, ingredient_category = %s where ingredient_name = %s returning *"""
    params = (ningredient, ncategory, oingredient)
    return get_dict_resultset(query, params)

def delete_ingredient(ingredient):
    query = """DELETE FROM ingredients2 where ingredient_name = %s returning *"""
    params = (ingredient, )
    return get_dict_resultset(query, params)

def insert_into_fridge(username, ingredient):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")

    query = """select ingredient_id from ingredients2 where ingredient_name ilike %s"""
    params = (ingredient, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        query = """insert into ingredients2(ingredient_name, ingredient_category) values (%s, 'unknown') returning ingredient_id"""
        params = (ingredient, )
        cur.execute(query, params)
        ans = cur.fetchone()
        ans = dict(ans)
        ingredient_id = ans.get("ingredient_id")
    else:
        ans = dict(ans)
        ingredient_id = ans.get("ingredient_id")
    res = fridge.update({"user_id":user_id}, {"$push": {"fridge": ingredient_id}}, upsert=True)
    if res.get('upserted'):
        res.pop('upserted')
    return res

def delete_from_fridge(username, ingredient):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")
    query = """select ingredient_id from ingredients2 where ingredient_name ilike %s"""
    params = (ingredient, )
    cur.execute(query, params)
    ans = cur.fetchone()
    ans = dict(ans)
    ingredient_id = ans.get("ingredient_id")
    res = fridge.update({"user_id":user_id}, {"$pull": {"fridge": ingredient_id}})
    return res

def get_fridge(username):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = fridge.find_one({"user_id":user_id}, {"fridge": 1, "_id": 0})
    if not res:
        return {"result" : []}


    query = """select ingredient_name from ingredients2 where ingredient_id in %s"""
    params = tuple(res['fridge'])
    res = get_dict_resultset(query, (params,))
    res2 = []
    for r in res['result']:
        res2.append(r['ingredient_name'])
    return {"result": res2}

def edit_ingredient_in_fridge(username, old_ingredient, new_ingredient):
    res1 = delete_from_fridge(username, old_ingredient)
    res2 = insert_into_fridge(username, new_ingredient)
    return res2

def get_recipes():
    global recipe_pos
    res = recipes.find().limit(15).skip(recipe_pos)
    recipe_pos += 15
    return {"result":json.loads(dumps(res))}

def get_recipe_by_id(recipe_id):
    res = recipes.find_one({"recipe_id":recipe_id})
    return res

def get_recipes_by_ingredients(ingredient_ids):
    res = recipes.find({"ingredients": {"$all": ingredient_ids}})
    return res

def add_schedule(username, week, time_available, num_meals):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")

    query = """DELETE FROM possible_schedules where user_id = %s returning *"""
    params = (user_id, )
    get_dict_resultset(query, params)

    query = """INSERT INTO possible_schedules(user_id, week, time_available, num_recipes) values (%s, %s, %s, %s) returning *"""
    params = (user_id, week, time_available, num_meals)

    return get_dict_resultset(query, params)

def display_schedule(username):
    query = """select U.first_name, U.last_name, S.week, S.time_available, S.num_recipes from users as U, possible_schedules as S where U.username = %s and S.user_id = U.user_id"""
    params = (username, )
    return get_dict_resultset(query, params)

def get_meal_schedule(username, week):
    ## find user
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        return None
    ans = dict(ans)
    user_id = ans.get("user_id")

    ## get user's fridge
    user_fridge = fridge.find_one({"user_id":user_id}, {"fridge": 1, "_id": 0})['fridge']

    ## create a view of recipes with ingredients without "seasoning" (working under the assumption that most people will have seasoning in their pantry)
    if 'without_seasoning' not in db.list_collection_names():
        ## get all pantry ingredient ids
        query = """select I.ingredient_id from ingredients2 as I where I.ingredient_category = 'seasonings'"""
        params = ()
        ans = get_dict_resultset(query, params)['result']
        pantry_ids = [dict_['ingredient_id'] for dict_ in ans]

        ## create a view
        db.command( { "create": "without_seasoning", "viewOn": "recipes4", "pipeline": [{"$unwind": "$ingredient_ids"}, {"$match": {"ingredient_ids": {"$nin": pantry_ids}}}, {"$group": {"_id": "$_id", "filtered_ingredients": {"$push": "$ingredient_ids"}}}]})

    ## get all recipe candidates (recipes that use ingredients only available from the fridge, while ignoring seasoning)
    recipe_candidate_ids = list(db.without_seasoning.find({"$expr": {"$setIsSubset": ["$filtered_ingredients", user_fridge]}}, {"_id": 1}))
    recipe_candidate_ids = [dict_['_id'] for dict_ in recipe_candidate_ids]
    user_recipes = recipes.find({"_id": {"$in": recipe_candidate_ids}})

    ## get user's schedule
    query = """select * from possible_schedules P where P.user_id = %s and P.week = %s"""
    params = (user_id, week)
    cur.execute(query, params)
    user_schedule = cur.fetchone()
    if not ans:
        return None
    user_schedule = dict(user_schedule)
    time_available = user_schedule['time_available']
    num_recipes = user_schedule['num_recipes']

    ## optimization problem: we want to maximize the number of ingredients used, while generating
    ## the number of meals required & minimizing the amount of time needed
    recipe_indices = [i for i in range(user_recipes.count())]
    recipe_combinations = list(itertools.combinations(recipe_indices, num_recipes))
    user_recipes_list = list(user_recipes)

    potential_combos = list()
    for combo in recipe_combinations:
        total_time = 0
        num_ingredients = 0
        ingredients_used = set()
        for i in list(combo):
            total_time += user_recipes_list[i]['time']
            ingredients_used.update(user_recipes_list[i]['ingredient_ids'])

        if total_time <= (60 * time_available):
            potential_combos.append((combo, total_time, len(ingredients_used)))

    potential_combos = sorted(potential_combos, key=lambda x: (-x[2], x[1]))
    print(potential_combos)
    global combo_meals, num_refreshes
    num_refreshes = 0
    combo_meals = [[user_recipes_list[i] for i in list(combo[0])] for combo in potential_combos]
    return {"result":json.loads(dumps(combo_meals[0]))}

def refresh_schedule():
    global combo_meals, num_refreshes
    num_refreshes += 1

    if num_refreshes >= len(combo_meals):
        num_refreshes = 0
        return {"result": "no more recipes :("}
    return {"result": json.loads(dumps(combo_meals[num_refreshes]))}

#print(get_meal_schedule('joker', 2))
#print(refresh_schedule())
#print(refresh_schedule())
#print(refresh_schedule())
