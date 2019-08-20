#!/bin/bash

sudo service jetty8 stop

sudo service jetty8 start

. /usr/lib/ckan/default/bin/activate

paster serve /etc/ckan/default/development.ini
