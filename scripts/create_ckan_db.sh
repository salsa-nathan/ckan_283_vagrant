#!/bin/bash

psql -c "CREATE USER ckan_default WITH PASSWORD 'ckan_default';"
psql -c "CREATE USER datastore_default WITH PASSWORD 'datastore_default';"
createdb -O ckan_default ckan_default -E utf-8
createdb -O ckan_default ckan_test -E utf-8
createdb -O ckan_default datastore_default -E utf-8
