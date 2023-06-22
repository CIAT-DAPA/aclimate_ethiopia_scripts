# Install dependencies

# Create virtual env
``` bash
python -m venv zambia_process
```

## Windows
``` bash
importing\Scripts\activate.bat
```

## Linux
``` bash
source importing/lib/activate
```

# Install libraries
``` bash
pip install pandas
```

# Description

## zambia_download.py
This script allows to download daily data of maximum, minimum temperature and precipitation for a coordinate. Each of these three data must go in a separate folder.

## zambia_daily_data_process.py
This script allows to convert the data downloaded by the previous script in a daily data format