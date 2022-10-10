import os
import sys
from glob import glob
from tools import GeoserverClient


folder_root = "/cluster01/workspace/ANGOLARISKFINANCING/Data/Online_Platform/"
folder_data = os.path.join(folder_root, "data")
folder_layers = os.path.join(folder_data, "layers")
folder_properties = os.path.join(folder_data, "properties")
folder_tmp = os.path.join(folder_data, "tmp")
geo_url = "https://geo.aclimate.org/geoserver/rest/"
geo_user = os.environ['GEO_USER']
geo_pwd = os.environ['GEO_PWD']
workspace_name = os.environ['GEO_WORKSPACE']
#country_iso = workspace_name.split("_")[1]


stores_aclimate = [x.split(os.sep)[-1] for x in glob(os.path.join(folder_layers,"*"), recursive = True)]
#stores_aclimate = ["maize_dry_spells_duration","maize_number_dry_days","maize_number_dry_spells"]
#stores_aclimate = ["maize_dry_spells_duration"]


# Connecting
print("Connecting")
geoclient = GeoserverClient(geo_url, geo_user, geo_pwd)
geoclient.connect()
geoclient.get_workspace(workspace_name)
print("Connected")

for current_store in stores_aclimate:
    print("Working with",current_store)

    current_layer = os.path.join(folder_layers,current_store)

    store_name = current_store
    store = geoclient.get_store(store_name)

    if not store:
        print("Creating mosaic")
        geoclient.create_mosaic(store_name, current_layer, folder_properties, folder_tmp)
    else:
        print("Updating mosaic")
        geoclient.update_mosaic(store, current_layer, folder_properties, folder_tmp)

print("Process completed")