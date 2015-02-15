docker run -d -rm \
  --name elasticsearch \
  -v /c/Users/Benjamin/Projects/sibu/dusty_coffin/server/elasticsearch/data:/data \
  dockerfile/elasticsearch

docker run -d -rm \
  --name nginx \
  --link es:es \
  -p 8080:8080 \
   bhillmann/nginx
