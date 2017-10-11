from lxml import html
import requests
import csv

products = []
products_page = requests.get('https://www.homelegance.com/youth/')
product_tree = html.fromstring(products_page.content)
products_on_page = len(product_tree.xpath('//*[@id="catList"]')[0])
product_paths = []
for index in range(1,products_on_page + 1):
    product_path = product_tree.xpath('//*[@id="catList"]/li[{0}]/a/@href'.format(index))[0]
    product_paths.append(product_path)

for index in range(2,9):
    products_page = requests.get('https://www.homelegance.com/youth/page/{0}/'.format(index))
    product_tree = html.fromstring(products_page.content)
    products_on_page = len(product_tree.xpath('//*[@id="catList"]')[0])
    for index in range(1,products_on_page + 1):
        product_path = product_tree.xpath('//*[@id="catList"]/li[{0}]/a/@href'.format(index))[0]
        product_paths.append(product_path)

for path in product_paths:
    page = requests.get(path)
    tree = html.fromstring(page.content)
    product = {}
    #Splits the name and number into separate values
    name_number = tree.xpath('//*[@id="picBox"]/h1')[0].text
    split = name_number.split(' ')
    number = split[0]
    if len(split) > 1:
        name = ""
        for index in range(1,len(split)):
            name = name + split[index] + " "
    else:
        name = split[0]

    if tree.xpath('//*[@id="tabProdInfo"]/p[1]')[0].text != None:
        description = tree.xpath('//*[@id="tabProdInfo"]/p[1]')[0].text.encode("utf-8")
    else:
        description = tree.xpath('//*[@id="tabProdInfo"]/p[2]')[0].text.encode("utf-8")

    image = tree.xpath('//*[@id="pic"]/img/@src')[0]

    product = {'name': name, 'number': number, 'description': description, 'image': image}

    products.append(product)

fieldnames = products[0].keys()
with open('youth.csv', "wb") as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames)

    writer.writeheader()
    writer.writerows(products)
