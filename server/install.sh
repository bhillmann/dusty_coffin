# run this to remove running containers for rebuild
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)

sudo docker pull dockerfile/elasticsearch
sudo docker build -t bhillmann/nginx nginx
sudo docker build -t bhillmann/admin admin
# docker build -t bhillmann/dusty_coffin dusty_coffin
