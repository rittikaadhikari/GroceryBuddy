from flask import Flask, make_response
from flask import render_template, jsonify, request
from flask_cors import CORS
import queries as psql

app = Flask(__name__)
CORS(app)


def create_response(data, status, message):
    """Wraps response in a consistent format throughout the API.

    Format inspired by https://medium.com/@shazow/how-i-design-json-api-responses-71900f00f2db
    Modifications included:
    - make success a boolean since there's only 2 values
    - make message a single string since we will only use one message per response
    IMPORTANT: data must be a dictionary where:
    - the key is the name of the type of data
    - the value is the data itself
    :param data <str> optional data
    :param status <int> optional status code, defaults to 200
    :param message <str> optional message
    :returns tuple of Flask Response and int, which is what flask expects for a response
    """
    if type(data) is not dict and data is not None:
        raise TypeError("Data should be a dictionary")

    response = {
        "code": status,
        "success": 200 <= status < 300,
        "message": message,
        "result": data,
    }
    return jsonify(response), status

@app.route('/')
def home():
    return "Grocery App"

######################################################################################################

@app.route('/users', methods=['DELETE'])
def delete_user():
    data = request.args
    username = data.get("username")
    if not username:
        return create_response({}, 404, "Not Found")
    res = psql.delete_user(username)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/users', methods=['POST'])
def add_user():
    data = request.form
    fname = data.get("first_name")
    lname = data.get("last_name")
    username = data.get("username")
    password = data.get("password")

    res = psql.create_new_user(fname, lname, username, password)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/users', methods=['PUT'])
def update_user():
    data = request.form
    ouser = data.get("old_username")
    fname = data.get("first_name")
    lname = data.get("last_name")
    username = data.get("username")
    password = data.get("password")

    res = psql.update_user(ouser, fname, lname, username, password)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/users/<username>', methods=['GET'])
def get_user(username):
    res = psql.get_user_data(username)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

######################################################################################################

@app.route('/ingredients', methods=['GET'])
def get_ingredient(username):
    data = request.args
    ingredient_name = data.get("ingredient_name")
    ingredient_category = data.get("ingredient_category")
    if ingredient_name:
        res = psql.get_ingredient(ingredient_name)
    elif ingredient_category:
        res = psql.get_ingredient_by_category(ingredient_category)
    else:
        return create_response({}, 404, "Not Found")
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/autocomplete_ingredients', methods=['GET'])
def autocomplete_ingredient():
    data = request.args
    ingredient_name = data.get("ingredient_name")
    if ingredient_name:
        res = psql.autocomplete_ingredients(ingredient_name)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/allingredients', methods=['GET'])
def get_ingredients():
    res = psql.get_ingredients()
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/ingredients', methods=['POST'])
def add_ingredient():
    data = request.form
    ingredient_name = data.get("ingredient_name")
    ingredient_category = data.get("ingredient_category")

    res = psql.create_ingredient(ingredient_name, ingredient_category)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

######################################################################################################

@app.route('/fridge', methods=['POST'])
def add_ingredient_to_fridge():
    data = request.form
    username = data.get("username")
    ingredient = data.get("ingredient")

    res = psql.insert_into_fridge(username, ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/fridge', methods=['DELETE'])
def remove_ingredient_from_fridge():
    data = request.args
    username = data.get("username")
    ingredient = data.get("ingredient")

    res = psql.delete_from_fridge(username, ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/fridge/<username>', methods=['GET'])
def get_ingredients_from_fridge(username):
    res = psql.get_fridge(username)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/fridge', methods=['PUT'])
def change_ingredient_on_fridge():
    data = request.form
    username = data.get("username")
    old_ingredient = data.get("old_ingredient")
    new_ingredient = data.get("new_ingredient")

    res = psql.edit_ingredient_in_fridge(username, old_ingredient, new_ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

######################################################################################################

@app.route('/list', methods=['POST'])
def add_ingredient_to_list():
    data = request.form
    username = data.get("username")
    ingredient = data.get("ingredient")

    res = psql.insert_into_grocery_list(username, ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/list', methods=['DELETE'])
def remove_ingredient_from_list():
    data = request.args
    username = data.get("username")
    ingredient = data.get("ingredient")

    res = psql.delete_from_grocery_list(username, ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/list/<username>', methods=['GET'])
def get_ingredients_from_list(username):
    res = psql.get_grocery_list(username)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/list', methods=['PUT'])
def change_ingredient_on_list():
    data = request.form
    username = data.get("username")
    old_ingredient = data.get("old_ingredient")
    new_ingredient = data.get("new_ingredient")

    res = psql.edit_ingredient_in_grocery_list(username, old_ingredient, new_ingredient)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

######################################################################################################
@app.route('/recipes', methods=['GET'])
def get_recipes():
    res = psql.get_recipes()
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

######################################################################################################
@app.route('/schedule', methods=['POST'])
def add_schedule():
    data = request.form
    username = data.get("username")
    week = data.get("week")
    time_available = data.get("time_available")
    num_meals = data.get("num_meals")
    res = psql.add_schedule(username, week, time_available, num_meals)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/schedule', methods=['GET'])
def get_user_schedule():
    data = request.args
    username = data.get("username")
    res = psql.display_schedule(username)
    if res:
        return create_response(res, 200, "OK")
    return create_response({}, 404, "Not Found")

@app.route('/mealschedules', methods=['GET'])
def get_meal_schedule():
    data = request.args
    username = data.get("username")
    week = data.get("week")
    res = psql.get_meal_schedule(username, week)
    if res:
        return create_response(res, 200, "OK")
    return create_response(res, 404, "Not Found")

@app.route('/refreshschedule', methods=['GET'])
def refresh_meal_schedule():
    res = psql.refresh_schedule()
    if res:
        return create_response(res, 200, "OK")
    return create_response(res, 404, "Not Found")
######################################################################################################

if __name__ == '__main__':
    app.run(debug = True, host='0.0.0.0', port=80)

