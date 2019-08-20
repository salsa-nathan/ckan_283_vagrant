#!/bin/bash

. /usr/lib/ckan/default/bin/activate

paster serve /etc/ckan/default/development.ini
