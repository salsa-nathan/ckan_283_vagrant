# ckan_283_vagrant
A Vagrant based local development setup for CKAN 2.8.3

## Local Setup

1. Clone this repository

1. Install vagrant, https://www.vagrantup.com/docs/installation/

1. Install some vagrant extensions, run this on your CLI

        vagrant plugin install vagrant-hostmanager
        vagrant plugin install vagrant-cachier
        vagrant plugin install vagrant-vbguest

1. Install any git submodules (if required)

        git submodule init
        git submodule update

6. Launch the Vagrant box:

        cd vagrant
        vagrant up

7. SSH into the Vagrant box and launch the CKAN instance:

        vagrant ssh
        . /usr/lib/ckan/default/bin/activate
        paster serve --reload /etc/ckan/default/development.ini
  
8. Browse your local CKAN instance:

        http://ckan283.loc:5000

## Test database

The `setup_ckan` script imports a CKAN database with some test data setup:

1. test organisation

1. test dataset

1. test users (all p/w: password):

    - admin
    - org_admin
    - org_editor
    - org_member
    - test_user (no affiliations)

1. test groups

    - Group 1
    - Group 2

## Bash aliases

After `vagrant ssh` you can use the following commands:

`serve` - stop & start Solr, then serve CKAN

`reserve` - serve CKAN without stopping & starting Solr.

`jobworker` - start the CKAN Job Worker.
