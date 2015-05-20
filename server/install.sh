# run this to remove running containers for rebuild
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)

sudo docker pull dockerfile/elasticsearch
sudo docker build -t bhillmann/elasticsearch-proxy elasticsearch-proxy
sudo docker build -t bhillmann/admin admin
sudo docker build -t bhillmann/frontend frontend
