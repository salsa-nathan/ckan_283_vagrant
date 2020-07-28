#!/usr/bin/env bash

. /usr/lib/ckan/default/bin/activate

pip install setuptools==36.1

cd /usr/lib/ckan/default/src/ckan

pip install -r requirements.txt

python setup.py develop

pip install flask_debugtoolbar --upgrade

deactivate
