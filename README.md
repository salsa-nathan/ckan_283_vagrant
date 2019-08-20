# dataqld_ckan
A local development setup for the Data.Qld project

## Local Setup

1. Clone this repository

2. Copy the `development.template.ini` to `development.ini` and adjust per you local setup.

        cd dataqld_ckan
        cp etc/default/development.ini etc/default/development.template.ini


3. Install vagrant, https://www.vagrantup.com/docs/installation/

4. Install some vagrant extensions, run this on your CLI

        vagrant plugin install vagrant-hostmanager
        vagrant plugin install vagrant-cachier
        vagrant plugin install vagrant-vbguest

5. Install any git submodules (if required)

        cd dataqld_ckan
        git submodule init
        git submodule update

6. Launch the Vagrantfile for the desired box (currently only Ubuntu - Centos 6 to come):

        cd vagrant.ubuntu
        vagrant up

7. SSH into the Vagrant box and launch the CKAN instance:

        vagrant ssh
        . /usr/lib/ckan/default/bin/activate
        paster serve --reload /etc/ckan/default/development.ini
  
8. Browse your local CKAN instance:

        http://dataqld.loc:5000

## Additional Configuration & Setup

### YTP Comments

Requires these additional `.ini` file settings:

        # YTP Comments
        ckan.comments.moderation = False
        ckan.comments.moderation.first_only = False
        ckan.comments.threaded_comments = True
        ckan.comments.users_can_edit = False
        ckan.comments.check_for_profanity = True
        ckan.comments.bad_words_file = /usr/lib/ckan/default/src/ckanext-ytp-comments/ckanext/ytp/comments/bad_words.txt

Also, requires initialising the `comments` database tables:

        paster --plugin=ckanext-ytp-comments initdb --config=/etc/ckan/default/development.ini
