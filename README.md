dusty_coffin
===========

Each of the modules are located in their own directory:
* admin - is the interface to edit the documents on the elastic search instance
* dusty_coffin - is the python module for populating the elastic search instance
* server - contains all of the docker files

The steps to get the server up are as follows:
* Clone this repository onto the server
* Install docker
  * You can read the installation details here: https://docs.docker.com/installation/
* Install node
  * You can red the installation details here: https://nodejs.org/
  * From node install the npm
  * Then run the command <code>npm install -g grunt</code>
  * Then run the command <code>npm install -g grunt-cli</code>
* Run the commands line by line in server/install.sh
* Run the commands line by line in server/run.sh
* The admin docker is currently working, so instead run the command <code>grunt serve</code> from ./admin
