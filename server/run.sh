docker run -d  \
  --name elasticsearch \
  -p 9200:9200 \
  -v /c/Users/Benjamin/Projects/sibu/dusty_coffin/server/elasticsearch/data:/data \
  dockerfile/elasticsearch

docker run -d \
  --name nginx \
  --link elasticsearch:elasticsearch \
  -p 8080:8080 \
   bhillmann/nginx