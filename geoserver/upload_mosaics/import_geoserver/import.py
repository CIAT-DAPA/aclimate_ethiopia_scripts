import os
import sys
from glob import glob
from tools import GeoserverClient


folder_root = "/forecast/usaid_procesos_interfaz/python/UploadMosaics/"
folder_data = os.path.join(folder_root, "data")
folder_layers = os.path.join(folder_data, "layers")
folder_properties = os.path.join(folder_data, "properties")
folder_tmp = os.path.join(folder_data, "tmp")
geo_url = "https://geo.aclimate.org/geoserver/rest/"
geo_user = os.environ['GEO_USER']
geo_pwd = os.environ['GEO_PWD']
workspace_name = os.environ['GEO_WORKSPACE']

stores_aclimate = [x.split(os.sep)[-1] for x in glob(os.path.join(folder_layers,"*"), recursive = True)]

# Connecting
print("Connecting")
geoclient = GeoserverClient(geo_url, geo_user, geo_pwd)
geoclient.connect()
geoclient.get_workspace(workspace_name)
print("Connected")

# This allows to upload multiple tiff files for one store
for current_store in stores_aclimate:
    
    try:
        current_rasters_folder = os.path.join(folder_layers, current_store)
        rasters_files = os.listdir(current_rasters_folder)

        store_name = current_store
        print("Importing")
        geoclient.connect()
        geoclient.get_workspace(workspace_name)

        for r in rasters_files:
            store = geoclient.get_store(store_name)
            layer = os.path.join(current_rasters_folder, r)
            if not store:
                print("Creating mosaic")
                geoclient.create_mosaic(
                    store_name, layer, folder_properties, folder_tmp)
            else:
                print("Updating mosaic")
                geoclient.update_mosaic(
                    store, layer, folder_properties, folder_tmp)
    except Exception as e:
        print(str(e))
        continue


print("Process completed")
