dusty_coffin
===========

Each of the modules are located in their own directory:
* admin - is the interface to edit the documents on the elastic search instance
* dusty_coffin - is the python module for populating the elastic search instance
* server - contains all of the docker files

The steps to get the server up are as follows:
1. Clone this repository onto the server
2. Install docker
  a. You can read the installation details here: https://docs.docker.com/installation/
3. Install node
  a. You can red the installation details here: https://nodejs.org/
  b. From node install the npm
  c. Then run the command <code>npm install -g grunt</code>
  d. Then run the command <code>npm install -g grunt-cli</code>
4. Run the commands line by line in server/install.sh
5. Run the commands line by line in server/run.sh
6. The admin docker is currently working, so instead run the command <code>grunt serve</code> from ./admin
