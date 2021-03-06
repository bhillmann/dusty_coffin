sudo docker run -d  \
  --name elasticsearch \
  -p 9200:9200 \
  -v /c/Users/Benjamin/Projects/sibu/dusty_coffin/server/elasticsearch/data:/data \
  dockerfile/elasticsearch

sudo docker run -d \
  --name elasticsearch-proxy \
  --link elasticsearch:elasticsearch \
  -p 8080:8080 \
   bhillmann/elasticsearch-proxy

sudo docker run \
  --name admin \
  -p 9100:80 \
  -d bhillmann/admin

sudo docker run \
  --name frontend \
  -p 9000:80 \
  -d bhillmann/frontend
