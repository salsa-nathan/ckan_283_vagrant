#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'
HIGHLIGHT='\e[105m'

sudo cp /vagrant_data/scripts/.bash_aliases /home/vagrant

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 1. Create the PostgreSQL database ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
sudo chmod +x /vagrant_data/scripts/create_ckan_db.sh
sudo runuser -l postgres "/vagrant_data/scripts/create_ckan_db.sh"

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 2. Install CKAN ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
sudo ln -sf /vagrant_data/etc/ /etc/ckan
sudo ln -sf /vagrant_data/ckan/ /usr/lib/
sudo mkdir -p /var/lib/ckan
sudo chown `whoami` /var/lib/ckan
sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default
virtualenv --no-site-packages /usr/lib/ckan/default
bash /vagrant_data/scripts/deploy.sh
. /usr/lib/ckan/default/bin/activate

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 3. Create the CKAN settings ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan/
sudo chown -R `whoami` /vagrant_data/etc/

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 4. Create the settings ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
# cd /usr/lib/ckan/default/src/ckan
# paster make-config ckan /etc/ckan/default/development.ini
# sudo sed -i -e 's/ckan_default:pass/ckan_default:ckan_default/g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/ckan_default:pass/datastore_default:datastore_default/g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/#ckan.datastore.write_url/ckan.datastore.write_url/g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/#ckan.datastore.read_url/ckan.datastore.read_url/g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/#solr_url/solr_url/g' /etc/ckan/default/development.ini
# #sudo sed -i -e 's/ckan.site_id\ =\ default/ckan.site_id\ =\ datavic/g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/ckan.site_url\ =/ckan.site_url\ =http\:\/\/dataqld.loc\ /g' /etc/ckan/default/development.ini
# sudo sed -i -e 's/ckan.site_url\ =/ckan.site_url\ =http\:\/\/dataqld.loc:5000\ /g' /etc/ckan/default/development.ini

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 5. Configure Solr ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
sudo service jetty8 stop && sleep 3
sudo sed -i -e 's/#JETTY_HOST=$(uname -n)/JETTY_HOST=127.0.0.1/g' /etc/default/jetty8
sudo sed -i -e 's/#JETTY_PORT=8080/JETTY_PORT=8983/g' /etc/default/jetty8
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
sudo service jetty8 restart && sleep 3

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 6. Link who.ini ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 7. Initialise the CKAN DB ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/development.ini

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 8. Setup Datastore ${NC} --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
paster --plugin=ckan datastore set-permissions -c /etc/ckan/default/development.ini | sudo -u postgres psql --set ON_ERROR_STOP=1

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 9. Create salsa as sysadmin user ${NC} --- "
echo -e "--- Username: salsa --- "
echo -e "--- Password: password --- "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"
#paster user add admin email=nathan@salsadigital.com.au password=password -c /etc/ckan/default/development.ini
#paster sysadmin add salsa -c /etc/ckan/default/development.ini

paster db clean -c /etc/ckan/default/development.ini
sudo -u postgres pg_restore --clean --if-exists -d ckan_default < /vagrant_data/db/ckan.dump

paster --plugin=ckan search-index rebuild -c /etc/ckan/default/development.ini

echo -e "${NC}${HIGHLIGHT} ##################################################################### ${NC}"
echo -e "--- ${HIGHLIGHT} 12. Run following commands to start CKAN ${NC} --- "
echo -e "    . /usr/lib/ckan/default/bin/activate "
echo -e "    paster serve --reload /etc/ckan/default/development.ini "
echo -e "    http://ckan284.loc:5000 "
echo -e "${HIGHLIGHT} ##################################################################### ${NC}"

