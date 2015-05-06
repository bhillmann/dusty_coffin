import urllib.request
from io import BytesIO
import pandas as pd
import ujson
from elasticsearch import Elasticsearch

csv = urllib.request.urlopen("https://docs.google.com/spreadsheet/pub?key=1h1udf_H073YaVlZs0fkYUf9dC6KbEZAhF1veeLExyXo&gid=937170620&output=csv").read()
bio = BytesIO(csv)
csv_pd = pd.DataFrame.from_csv(bio)

json_objs = csv_pd.reset_index().to_json(orient='records')
dict_array= ujson.loads(json_objs)

# Edit to point to elasticsearch instance
es = Elasticsearch('ec2-52-10-17-100.us-west-2.compute.amazonaws.com:9200')

# ignore 404 and 400
es.indices.delete(index='datasets_index', ignore=[400, 404])
for d in dict_array:
	print(d)
	res = es.index(index="datasets_index", doc_type="dataset", body=d)
	print(res['created'])
