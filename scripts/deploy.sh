#!/usr/bin/env bash

. /usr/lib/ckan/default/bin/activate

pip install setuptools==36.1

pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.8.3#egg=ckan'

pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt

cd /usr/lib/ckan/default/src/ckan

python setup.py develop

pip install flask_debugtoolbar --upgrade

deactivate
