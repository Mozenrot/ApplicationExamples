import requests
from bs4 import BeautifulSoup


r = requests.get("http://www.pyclass.com/example.html", headers={'User-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'})
content = r.content
soup = BeautifulSoup(content)
# print(soup.prettify(),"html.parser")
allCities = soup.find_all("div",{"class":"cities"})

for i in allCities:
    city = i.find_all("h2")[0].text
    describe = i.find_all("p")[0].text

    print(city)
    print(describe)
# print(type(allCities))
