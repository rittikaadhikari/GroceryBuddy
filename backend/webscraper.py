from recipe_scrapers import scrape_me
from bs4 import BeautifulSoup
from urllib.request import Request, urlopen
import json 

recipe_links = set()

for i in range(49):
    if i == 0:
        base_page = 'https://www.simplyrecipes.com/recipes/course/dinner'
    else: 
        base_page = 'https://www.simplyrecipes.com/recipes/course/dinner/page/' + str(i + 1) + '/'
    
    req = Request(base_page, headers={'User-Agent': 'Mozilla/5.0'})
    webpage = urlopen(req).read()
    soup = BeautifulSoup(webpage, 'html.parser')
    for link in soup.findAll('a'):
        website = link.get('href')
        if website is not None:
            split_website = website.split('https://www.simplyrecipes.com/recipes/')
            if len(split_website) == 2:
                if len(split_website[1].split('/')) == 2: 
                    recipe_links.add(website)

recipe_links = list(recipe_links)
recipe_jsons = list()
for recipe in recipe_links:
    scraper = scrape_me(recipe)
    recipe_json = dict()
    recipe_json['title'] = scraper.title()
    recipe_json['total_time'] = scraper.total_time()
    recipe_json['ingredients'] = scraper.ingredients()
    recipe_json['instructions'] = scraper.instructions()
    recipe_jsons.append(recipe_json)

data = {} 
data['data'] = recipe_jsons
with open("recipes.json", "w") as write_file:
    json.dump(data, write_file)
