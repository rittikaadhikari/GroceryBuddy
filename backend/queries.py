import psycopg2
import psycopg2.extras
import pymongo
from pymongo import MongoClient
client = MongoClient('3.234.30.163', 27017)
db = client.grocery_list
grocery_list = db.grocery_list
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
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.update({"user_id":user_id}, {"$push": {"user_ingredients": ingredient}})
    return res

def delete_from_grocery_list(username, ingredient):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.update({"user_id":user_id}, {"$pull": {"user_ingredients": ingredient}})
    return res

def get_grocery_list(username):
    query = """select user_id from users where username = %s"""
    params = (username, )
    cur.execute(query, params)
    ans = cur.fetchone()
    ans = dict(ans)
    user_id = ans.get("user_id")
    res = grocery_list.find_one({"user_id":user_id}, {"user_ingredients": 1, "_id": 0})
    return res

def edit_ingredient_in_grocery_list(username, old_ingredient, new_ingredient):
    res1 = delete_from_grocery_list(username, old_ingredient)
    res2 = insert_into_grocery_list(username, new_ingredient)
    return res2
    

