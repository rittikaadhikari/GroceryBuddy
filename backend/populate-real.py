import random
import string
import psycopg2
import psycopg2.extras
import json

conn = psycopg2.connect(dbname='postgres', user='postgres', password='alawini411', host='cs411-project.cm2xo0osnz3p.us-east-1.rds.amazonaws.com', port='5432')
conn.autocommit = True
cur = conn.cursor()

def randomstring(stringlength=10):
    """generate a random string of fixed length """
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringlength))

#for i in range(400):
    #cur.execute("insert into recipe_to_ingredients(recipe_id, ingredient_id) values (%s, %s)", (random.randint(1, 40),random.randint(1, 70)))

meats = ['meat', 'egg', 'beef', 'pork', 'lamb', 'mutton', 'veal', 'chicken', 'turkey', 'goat', 'duck', 'goose', 'bacon', 'ham', 'venison', 'liver', 'chuck']
dairy = ['dairy', 'milk', 'yogurt', 'cheese', 'cream', 'butter', 'casein', 'custard', 'ice cream']
vegetables = [
        'vegetable',
        "acorn squash",
        "alfalfa sprout",
        "amaranth",
        "anise",
        "artichoke",
        "arugula",
        "asparagus",
        "aubergine",
        "azuki bean",
        "banana squash",
        "basil",
        "bean sprout",
        "beet",
        "black bean",
        "black-eyed pea",
        "bok choy",
        "borlotti bean",
        "broad beans",
        "broccoflower",
        "broccoli",
        "brussels sprout",
        "butternut squash",
        "cabbage",
        "calabrese",
        "caraway",
        "carrot",
        "cauliflower",
        "cayenne pepper",
        "celeriac",
        "celery",
        "chamomile",
        "chard",
        "chayote",
        "chickpea",
        "chives",
        "cilantro",
        "collard green",
        "corn",
        "corn salad",
        "courgette",
        "cucumber",
        "daikon",
        "delicata",
        "dill",
        "eggplant",
        "endive",
        "fennel",
        "fiddlehead",
        "frisee",
        "garlic",
        "gem squash",
        "ginger",
        "green bean",
        "green pepper",
        "habanero",
        "herbs and spice",
        "horseradish",
        "hubbard squash",
        "jalapeno",
        "jerusalem artichoke",
        "jicama",
        "kale",
        "kidney bean",
        "kohlrabi",
        "lavender",
        "leek ",
        "legume",
        "lemon grass",
        "lentils",
        "lettuce",
        "lima bean",
        "mamey",
        "mangetout",
        "marjoram",
        "mung bean",
        "mushroom",
        "mustard green",
        "navy bean",
        "new zealand spinach",
        "nopale",
        "okra",
        "onion",
        "oregano",
        "paprika",
        "parsley",
        "parsnip",
        "patty pan",
        "pea",
        "pinto bean",
        "potato",
        "pumpkin",
        "radicchio",
        "radish",
        "rhubarb",
        "rosemary",
        "runner bean",
        "rutabaga",
        "sage",
        "scallion",
        "shallot",
        "skirret",
        "snap pea",
        "soy bean",
        "spaghetti squash",
        "spinach",
        "squash ",
        "sweet potato",
        "tabasco pepper",
        "taro",
        "tat soi",
        "thyme",
        "topinambur",
        "tubers",
        "turnip",
        "wasabi",
        "water chestnut",
        "watercress",
        "white radish",
        "yam",
        "zucchini"
    ]
fruits = [
        'fruit',
        "apple",
        "apricot",
        "avocado",
        "banana",
        "bell pepper",
        "bilberry",
        "blackberry",
        "blackcurrant",
        "blood orange",
        "blueberry",
        "boysenberry",
        "breadfruit",
        "canary melon",
        "cantaloupe",
        "cherimoya",
        "cherry",
        "chili pepper",
        "clementine",
        "cloudberry",
        "coconut",
        "cranberry",
        "cucumber",
        "currant",
        "damson",
        "date",
        "dragonfruit",
        "durian",
        "eggplant",
        "elderberry",
        "feijoa",
        "fig",
        "goji berry",
        "gooseberry",
        "grape",
        "grapefruit",
        "guava",
        "honeydew",
        "huckleberry",
        "jackfruit",
        "jambul",
        "jujube",
        "kiwi fruit",
        "kumquat",
        "lemon",
        "lime",
        "loquat",
        "lychee",
        "mandarine",
        "mango",
        "mulberry",
        "nectarine",
        "nut",
        "olive",
        "orange",
        "pamelo",
        "papaya",
        "passionfruit",
        "peach",
        "pear",
        "persimmon",
        "physalis",
        "pineapple",
        "plum",
        "pomegranate",
        "pomelo",
        "purple mangosteen",
        "quince",
        "raisin",
        "rambutan",
        "raspberry",
        "redcurrant",
        "rock melon",
        "salal berry",
        "satsuma",
        "star fruit",
        "strawberry",
        "tamarillo",
        "tangerine",
        "tomato",
        "ugli fruit",
        "watermelon"
    ]

alcohols = ['alcohol', "rum", 'vodka', 'gin', 'tequila', 'brandy', 'sake', 'beer']

seasonings = [
                'powder',
		"angelica",
                "seasoning",
		"basil",
		"holy basil",
		"thai basil",
		"bay leaf",
		"indian bay leaf",
		"boldo",
		"borage",
		"chervil",
		"chives",
		"garlic chives",
		"cicely",
		"coriander leaf",
		"cilantro",
		"bolivian coriander",
		"vietnamese coriander",
		"culantro",
		"cress",
		"curry leaf",
		"dill",
		"epazote",
		"hemp",
		"hoja santa",
		"houttuynia cordata",
		"hyssop",
		"jimbu",
		"kinh gioi",
		"lavender",
		"lemon balm",
		"lemon grass",
		"lemon myrtle",
		"lemon verbena",
		"limnophila aromatica",
		"lovage",
		"marjoram",
		"mint",
		"mugwort",
		"mitsuba",
		"oregano",
		"parsley",
		"perilla",
		"rosemary",
		"rue",
		"sage",
		"savory",
		"sansho",
		"shiso",
		"sorrel",
		"tarragon",
		"thyme",
		"woodruff",
		"aonori",
		"ajwain",
		"allspice",
		"amchoor",
		"anise",
		"star anise",
		"asafoetida",
		"camphor",
		"caraway",
		"cardamom",
		"black cardamom",
		"cassia",
		"celery powder",
		"celery seed",
		"charoli",
		"chenpi",
		"cinnamon",
		"clove",
		"coriander seed",
		"cubeb",
		"cumin",
		"nigella sativa",
		"bunium persicum",
		"dill",
		"dill seed",
		"fennel",
		"fenugreek",
		"fingerroot",
		"greater galangal",
		"lesser galangal",
		"garlic",
		"ginger",
		"aromatic ginger",
		"golpar",
		"grains of paradise",
		"grains of selim",
		"horseradish",
		"juniper berry",
		"kokum",
		"korarima",
		"dried lime",
		"liquorice",
		"litsea cubeba",
		"mace",
		"mango-ginger",
		"mastic",
		"mahlab",
		"black mustard",
		"brown mustard",
		"white mustard",
		"nigella",
		"njangsa",
		"nutmeg",
		"alligator pepper",
		"brazilian pepper",
		"chili pepper",
		"cayenne pepper",
		"paprika",
		"long pepper",
		"peruvian pepper",
		"east asian pepper",
		"sichuan pepper",
		"sansho",
		"tasmanian pepper",
		"black peppercorn",
		"green peppercorn",
		"white peppercorn",
		"pomegranate seed",
		"poppy seed",
		"radhuni",
		"rose",
		"saffron",
		"salt",
		"sarsaparilla",
		"sassafras",
		"sesame",
		"shiso",
		"sumac",
		"tamarind",
		"tonka bean",
		"turmeric",
		"uzazi",
		"vanilla",
		"voatsiperifery",
		"wasabi",
		"yuzu",
		"zedoary",
		"zereshk",
		"zest",
                "adjika",
		"advieh",
		"baharat",
		"beau monde seasoning",
		"berbere",
		"bouquet garni",
		"buknu",
		"chaat masala",
		"chaunk",
		"chili powder",
		"crab boil",
		"curry powder",
		"doubanjiang",
		"douchi",
		"duqqa",
		"fines herbes",
		"five-spice powder",
		"garam masala",
		"garlic powder",
		"garlic salt",
		"gochujang",
		"harissa",
		"hawaij",
		"herbes de provence",
		"idli podi",
		"jamaican jerk spice",
		"khmeli suneli",
		"lemon pepper",
		"mitmita",
		"mixed spice",
		"montreal steak seasoning",
		"mulling spices",
		"old bay seasoning",
		"onion powder",
		"panch phoron",
		"persillade",
		"powder-douce",
		"pumpkin pie spice",
		"qâlat daqqa",
		"quatre épices",
		"ras el hanout",
		"recado rojo",
		"sharena sol",
		"shichimi",
		"tabil",
		"tandoori masala",
		"vadouvan",
		"yuzukosho",
		"za'atar",
                'oil',
                'sugar',
                'salt',
                'spice',
                'seasoning',
                'powder',
                'water',
                'baking soda'
	]

grains = ['wheat', 'bread', 'millet', 'barley', 'grain', 'quinoa', 'sorghum', 'oat', 'rice', 'maize', 'corn', 'flour']



with open('ingredient-list.json', 'r') as json_file:
    data = json.load(json_file)
    for i in data:
        ingredient = i['term']
        inserted = False
        for j in meats:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'meat'))
                inserted = True
                break
        if inserted:
            continue

        for j in grains:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'grains'))
                inserted = True
                break
        if inserted:
            continue

        for j in vegetables:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'vegetables'))
                inserted = True
                break
        if inserted:
            continue

        for j in fruits:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'fruits'))
                inserted = True
                break
        if inserted:
            continue

        for j in dairy:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'dairy'))
                inserted = True
                break
        if inserted:
            continue

        for j in alcohols:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'alcohol'))
                inserted = True
                break
        if inserted:
            continue

        for j in seasonings:
            if ingredient in j or j in ingredient:
                cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,'seasonings'))
                inserted = True
                break
        if inserted:
            continue

        if not inserted:
            cur.execute("insert into ingredients2(ingredient_name, ingredient_category) values (%s, %s)", (ingredient,"unknown"))


