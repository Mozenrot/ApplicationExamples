import requests
import pandas
from bs4 import BeautifulSoup

data_frame = pandas.DataFrame()

r = requests.get("http://www.pyclass.com/real-estate/rock-springs-wy/LCWYROCKSPRINGS/", headers={'User-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'})
content = r.content
soap = BeautifulSoup(content)
# print(soap)


propertyDivs = soap.find_all("div", {"class":"propertyRow"})
list_of_data = []
for item in propertyDivs:
    data_dictionary = {}
    data_dictionary["Price"] = item.find("h4", {"class":"propPrice"}).text.replace(" ", "").replace("\n","")
    address1 = item.find_all("span", {"class":"propAddressCollapse"})[0].text
    address2 = item.find_all("span", {"class":"propAddressCollapse"})[1].text
    data_dictionary["Address"] = address1 + " " + address2
    try:
        numOfBed = item.find("span", {"class":"infoBed"}).find("b").text
    except:
        numOfBed = "None"

    data_dictionary["Num Of Bed"] = numOfBed
    for column_group in item.find_all("div",{"class":"columnGroup"}):
        for feature_group, feature_name in zip(column_group.find_all("span",{"class":"featureGroup"}),column_group.find_all("span",{"class":"featureName"})):
            if "Lot Size" in feature_group.text:
                data_dictionary["Lot Size"] = feature_name.text

    list_of_data.append(data_dictionary)


data_frame = pandas.DataFrame(list_of_data)
data_frame.to_csv("DataRealEstate.csv")
print(data_frame)


# base_url = "http://www.pyclass.com/real-estate/rock-springs-wy/LCWYROCKSPRINGS/t=0&s="
#
# for page in range(0,30,10):
#     pageUrl = base_url + str(page)
#     r = requests.get(pageUrl), headers={'User-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'})
#
