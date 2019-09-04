#!/bin/bash

. /usr/lib/ckan/default/bin/activate

cd /usr/lib/ckan/default/src/ckan

paster jobs worker -c /etc/ckan/default/development.ini
