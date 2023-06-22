import pandas as pd
from datetime import datetime
import csv
import os

# Crear una lista de fechas desde el 1 de enero de 1981 hasta el 31 de diciembre de 2021
fechas = pd.date_range(start='1981-01-01', end='2021-12-31', freq='D')

# Crear un DataFrame con las columnas 'day', 'month' y 'year'
df = pd.DataFrame({'day': fechas.day, 'month': fechas.month, 'year': fechas.year})

# Directorio que contiene los archivos TSV
directorio = 'D:/forecast_process/USAID_Africa/ZAMBIA/data/'

def add_measure_value(measure):
    # Recorrer los archivos en el directorio
    for archivo in os.listdir(directorio):
        if archivo.endswith('.tsv'):  # Solo procesar archivos TSV
            ruta_archivo = os.path.join(directorio, archivo)
            
            # Abrir el archivo TSV y leer los datos, ignorando las dos primeras filas
            with open(ruta_archivo, 'r') as archivo_tsv:
                lector = csv.reader(archivo_tsv, delimiter='\t')
                
                # Omitir las dos primeras filas
                next(lector)
                next(lector)
                
                # Leer las filas restantes del archivo TSV
                for fila in lector:
                    date = fila[0].split(' ')
                    value = fila[1]

                    numero_mes = datetime.strptime(date[1], '%b').month

                    # Buscar la fila correspondiente a la fecha especificada y asignar el valor en la columna 'valor'
                    df.loc[(df['day'] == int(date[0])) & (df['month'] == int(numero_mes)) & (df['year'] == int(date[2])), measure] = value
                    

add_measure_value("t_max")
add_measure_value("t_min")
df.to_csv('D:/forecast_process/USAID_Africa/ZAMBIA/data/archivo.csv', index=False)