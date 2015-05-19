sudo docker run -d  \
  --name elasticsearch \
  -p 9200:9200 \
  -v /c/Users/Benjamin/Projects/sibu/dusty_coffin/server/elasticsearch/data:/data \
  dockerfile/elasticsearch

sudo docker run -d \
  --name nginx \
  --link elasticsearch:elasticsearch \
  -p 8080:8080 \
   bhillmann/nginx

sudo docker run \
  --name admin \
  -P -d \
   bhillmann/nginx
