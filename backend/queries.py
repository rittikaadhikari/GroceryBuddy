import psycopg2
import psycopg2.extras
import pymongo
from pymongo import MongoClient
import pprint

client = MongoClient('3.234.30.163', 27017)
db = client.grocery_list
grocery_list = db.grocery_list
fridge = db.fridge
recipes = db.recipes3
conn = psycopg2.connect(dbname='postgres', user='postgres', password='alawini411', host='cs411-project.cm2xo0osnz3p.us-east-1.rds.amazonaws.com', port='5432')
conn.autocommit = True
cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)


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
    print(username)
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
    query = """INSERT INTO ingredients(ingredient_name, ingredient_category) values (%s, %s) returning *"""
    params = (ingredient_name, ingredient_category)
    return get_dict_resultset(query, params)


def get_ingredient(ingredient_name):
    query = """SELECT * FROM ingredients where ingredient_name = %s"""
    params = (ingredient_name,)
    return get_dict_resultset(query, params)

def get_ingredient_by_category(ingredient_category):
    query = """SELECT * FROM ingredients where ingredient_category = %s"""
    params = (ingredient_category,)
    return get_dict_resultset(query, params)

def update_ingredient(oingredient, ningredient, ncategory):
    query = """UPDATE ingredients set ingredient_name = %s, ingredient_category = %s where ingredient_name = %s returning *"""
    params = (ningredient, ncategory, oingredient)
    return get_dict_resultset(query, params)

def delete_ingredient(ingredient):
    query = """DELETE FROM ingredients where ingredient_name = %s returning *"""
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

    query = """select ingredient_id from ingredients where ingredient_name ilike %s"""
    params = (ingredient, )
    cur.execute(query, params)
    ans = cur.fetchone()
    if not ans:
        query = """insert into ingredients(ingredient_name, ingredient_category) values (%s, 'unknown') returning ingredient_id"""
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
    print(res)
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
    query = """select ingredient_id from ingredients where ingredient_name ilike %s"""
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
    res = recipes.find()
    return res

def get_recipe_by_id(recipe_id):
    res = recipes.find_one({"recipe_id":recipe_id})
    return res

def get_recipes_by_ingredients(ingredient_ids):
    res = recipes.find({"ingredients": {"$all": ingredient_ids}})
    return res

def scheduler(username, week):
    #query = """SELECT * FROM ingredients2"""
    #ingredients = get_dict_resultset(query, None)
    #res = list(recipes.find())
    #return res[0]
   
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
    print(user_fridge) 

    ## get all recipe candidates (recipes that use ingredients only available from the fridge)
    user_recipes = recipes.find({"$expr": {"$setIsSubset": ["$ingredient_ids", user_fridge]}})
    for recipe in user_recipes:
        print(recipe['ingredient_ids'], recipe['recipe']['title'])
    
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

    ## maximization problem

scheduler('joker', 1)
