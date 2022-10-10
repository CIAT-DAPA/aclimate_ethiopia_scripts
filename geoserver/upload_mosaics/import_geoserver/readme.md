# Install dependencies

# Create virtual env
``` bash
python -m venv importing
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

## Download dependencies (optional)
``` bash
git clone https://github.com/dimitri-justeau/gsconfig-py3.git
```
## Install
``` bash
cd gsconfig-py3
python setup.py install
```

# Set enviromentals vars
## Windows
``` bash
set GEO_USER=xxx
set GEO_PWD=xxx
set GEO_WORKSPACE=xxx
```

## Linux
``` bash
export GEO_USER=xxx
export GEO_PWD=xxx
export GEO_WORKSPACE=xxx
```
