import folium
import pandas

data = pandas.read_csv("cities.txt")


lat = list(data["LAT"])
lon = list(data["LON"])
population = list(data["POPULATION"])
city = list(data["CITY"])
print(lon)

def populationArrangeMarker(numOfPeople):
    if numOfPeople > 300000:
        return 'red'
    elif numOfPeople > 100000 :
        return 'blue'
    else:
        return 'green'

map = folium.Map(location = [32.0804174,34.7314436], zoom_start = 10, tiles = "Mapbox Bright")

featureGrCities = folium.FeatureGroup(name = "Israel Cities Population")
featureGrWorld = folium.FeatureGroup(name = "World Population")

featureGrWorld.add_child(folium.GeoJson(data = open("world.json", "r", encoding = "utf-8-sig").read(), style_function =lambda x: {'fillColor':'green' if x['properties']['POP2005'] > 2000000 else 'orange' if x['properties']['POP2005'] > 7000000 else 'red'}))


for lt, ln, people, cityIsrael in zip(lat,lon, population, city):

    markerColor = populationArrangeMarker(people)

    featureGrCities.add_child(folium.CircleMarker(location = [lt,ln], radius = 6, fill_color = markerColor, color = 'grey',fill_apacity = 0.9, popup = (str(people) + " " + cityIsrael)))


map.add_child(featureGrCities)
map.add_child(featureGrWorld)


map.add_child(folium.LayerControl())

map.save("Map.html")
