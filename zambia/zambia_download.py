import urllib.request

# Importar las bibliotecas necesarias
import calendar

# Definir URLs
url_temperature = "http://41.72.104.142/SOURCES/.ZMD/.ENACTS/.temperature/.ALL/.daily/T/(1961)//YearStart/parameter/(2021)//YearEnd/parameter/RANGEEDGES/(1)//DayStart/parameter/(%20)/append/(Jul)//seasonStart/parameter/append/(%20-%20)/append/(30)//DayEnd/parameter/append/(%20)/append/(Sep)//seasonEnd/parameter/append/(0.)//hotThreshold/parameter/interp/(0.5)//minFrac/parameter/interp/(MeanTemp)//seasonalStat/parameter/(MinTemp)/eq/%7Bnip/3/-1/roll/.tmin/T/4/-2/roll/seasonalAverage%7Dif//seasonalStat/get_parameter/(MaxTemp)/eq/%7Bnip/3/-1/roll/.tmax/T/4/-2/roll/seasonalAverage%7Dif//seasonalStat/get_parameter/(MeanTemp)/eq/%7Bnip/3/-1/roll/.tmean/T/4/-2/roll/seasonalAverage%7Dif//seasonalStat/get_parameter/(CDD)/eq/%7B4/-1/roll/.tmean/3/-1/roll/sub/0/maskge/abs/3/-2/roll/flexseastotZeroFill//scale_symmetric/false/def//long_name/(Chilling%20Degree%20Days)/def%7Dif//seasonalStat/get_parameter/(GDD)/eq/%7B4/-1/roll/.tmean/3/-1/roll/sub/0/maskle/abs/3/-2/roll/flexseastotZeroFill//scale_symmetric/false/def//long_name/(Growing%20Degree%20Days)/def%7Dif//seasonalStat/get_parameter/(NumCD)/eq/%7B4/-1/roll/.tmean/4/-3/roll/flexseasonalfreqLT//scale_symmetric/false/def//long_name/(Cold%20Days)/def%7Dif//seasonalStat/get_parameter/(NumHD)/eq/%7B4/-1/roll/.tmean/4/-3/roll/flexseasonalfreqGT//scale_symmetric/false/def//long_name/(Hot%20Days)/def%7Dif/(bb%3A27%3A-13.0375%3A27.0375%3A-13%3Abb)//region/parameter/geoobject/%5BX/Y%5Dweighted-average//fullname%5Blong_name/(%20in)/append/units/cvntos%5Ddef/DATA/AUTO/AUTO/RANGE/T/exch/table:/2/:table/.tsv?region="
url_precipitation ="http://41.72.104.142/SOURCES/.ZMD/.ENACTS/.rainfall/.ALL/.daily/.rfe_merged/%28bb:27:-13.0375:27.0375:-13:bb%29//region/geoobject%5BX/Y%5Dweighted-average/T/%281981%29//YearStart/parameter/%282020%29//YearEnd/parameter/RANGE/%28TotRain%29//seasonalStat/parameter/%28PerDA%29eq/%7Bdataflag%7Dif/%281%29//DayStart/parameter/%28%20%29append/%28Jan%29//seasonStart/parameter/append/%28%20-%20%29append/%2831%29//DayEnd/parameter/append/%28%20%29append/%28Mar%29//seasonEnd/parameter/append/%285%29//spellThreshold/parameter/interp/%281%29//wetThreshold/parameter/interp/0.0//seasonalStat/get_parameter/%28TotRain%29eq/%7Bnip/nip/flexseastotAvgFill//units//mm/def/precip_colors%7Dif//seasonalStat/get_parameter/%28NumWD%29eq/%7B3/-1/roll/pop/flexseasonalfreqGT//long_name/%28Number%20of%20Wet%20Days%29def/wetday_freq_colors%7Dif//seasonalStat/get_parameter/%28NumDD%29eq/%7B3/-1/roll/pop/flexseasonalfreqLT//long_name/%28Number%20of%20Dry%20Days%29def/wetday_freq_colors%7Dif//seasonalStat/get_parameter/%28RainInt%29eq/%7B3/-1/roll/pop/flexseasonalmeandailyvalueGT//long_name/%28Rainfall%20Intensity%29def/prcp_hrlyrate_colors%7Dif//seasonalStat/get_parameter/%28NumDS%29eq/%7BflexseasonalnonoverlapDSfreq//long_name/%28Number%20of%20Dry%20Spells%29def/cmorph_dekad_colors%7Dif//seasonalStat/get_parameter/%28NumWS%29eq/%7BflexseasonalnonoverlapWSfreq//long_name/%28Number%20of%20Wet%20Spells%29def/wetday_freq_colors%7Dif//seasonalStat/get_parameter/%28PerDA%29eq/%7Bpop/pop/pop/T/exch/0.0/seasonalAverage%7Dif//fullname%5Blong_name/%28%20in%29append/units/cvntos%5Ddef/DATA/AUTO/AUTO/RANGE/T/exch/table:/2/:table/.tsv?region="

# Crear un diccionario con el número de días por mes
dias_por_mes = {
    "Jan": 31,
    "Feb": 28,  # Los años bisiestos tienen 29 días en febrero
    "Mar": 31,
    "Apr": 30,
    "May": 31,
    "Jun": 30,
    "Jul": 31,
    "Aug": 31,
    "Sep": 30,
    "Oct": 31,
    "Nov": 30,
    "Dec": 31
}

def download_daily_temperature(coord, type_tmp):
    
# Recorrer cada mes y día para el año actual
    for mes in calendar.month_abbr[1:]:
        num_dias = dias_por_mes[mes]
        
        # Recorrer cada día del mes actual y hacer algo con la URL
        for dia in range(1, num_dias + 1):
            # Crear la URL con los parámetros actualizados
            url = f"{url_temperature}bb%3A27.58125%3A{coord[0]}%3A27.618750000000002%3A{coord[1]}%3Abb&YearStart=1981&seasonStart={mes}&seasonEnd={mes}&DayStart={dia}&DayEnd={dia}&seasonalStat={type_tmp}"
            urllib.request.urlretrieve(url, f"D:/forecast_process/USAID_Africa/ZAMBIA/data/archivo_{dia}{mes}.tsv")

def download_daily_temperature_feb_29(coord, type_tmp):
     dia=29
     mes="Feb"
     url = f"{url_temperature}bb%3A27.58125%3A{coord[0]}%3A27.618750000000002%3A{coord[1]}%3Abb&YearStart=1981&seasonStart={mes}&seasonEnd={mes}&DayStart={dia}&DayEnd={dia}&seasonalStat={type_tmp}"
     urllib.request.urlretrieve(url, f"D:/forecast_process/USAID_Africa/ZAMBIA/data/archivo_{dia}{mes}.tsv")

def download_daily_precipitation(coord, type_tmp):
    
# Recorrer cada mes y día para el año actual
    for mes in calendar.month_abbr[1:]:
        num_dias = dias_por_mes[mes]
        
        # Recorrer cada día del mes actual y hacer algo con la URL
        for dia in range(1, num_dias + 1):
            # Crear la URL con los parámetros actualizados
            url = f"{url_precipitation}bb:26.793750000000003:{coord[0]}:{coord[1]}:bb&seasonStart={mes}&seasonEnd={mes}&DayStart={dia}&DayEnd={dia}"
            urllib.request.urlretrieve(url, f"D:/forecast_process/USAID_Africa/ZAMBIA/data/archivo_{dia}{mes}.tsv")

def download_daily_precipitation_feb_29(coord, type_tmp):
     dia=29
     mes="Feb"
     url = f"{url_precipitation}bb:26.793750000000003:{coord[0]}:{coord[1]}:bb&seasonStart={mes}&seasonEnd={mes}&DayStart={dia}&DayEnd={dia}"
     urllib.request.urlretrieve(url, f"D:/forecast_process/USAID_Africa/ZAMBIA/data/archivo_{dia}{mes}.tsv")





download_daily_temperature_feb_29(coord=(-12.95625,-12.918750000000001), type_tmp="MinTemp")
download_daily_temperature_feb_29(coord=(-12.95625,-12.918750000000001), type_tmp="MaxTemp")

download_daily_temperature(coord=(-12.95625,-12.918750000000001), type_tmp="MinTemp")
download_daily_temperature(coord=(-12.95625,-12.918750000000001), type_tmp="MaxTemp")
