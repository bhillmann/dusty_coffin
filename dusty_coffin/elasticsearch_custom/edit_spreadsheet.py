import urllib.request
from io import BytesIO
import pandas as pd
import ujson
from elasticsearch import Elasticsearch

csv = urllib.request.urlopen("https://docs.google.com/spreadsheet/pub?key=0Ahf71UaPpMOSdGl0NnQtSFgyVFpvSmV3R2JobzVmZHc&output=csv").read()
bio = BytesIO(csv)
csv_pd = pd.DataFrame.from_csv(bio)
csv_pd.columns = ["title", "username", "description", "subject_areas", "type", "locations", "tag_words", "discipline", "url", "creator", "time_periods", "alternate_title", "source_type", "keywords", "macalester_dataset"]
json_objs = csv_pd.reset_index().to_json(orient='records')
dict_array= ujson.loads(json_objs)
es = Elasticsearch('ec2-52-10-17-100.us-west-2.compute.amazonaws.com:9200')
# ignore 404 and 400
es.indices.delete(index='datasets_index', ignore=[400, 404])
for d in dict_array:
    res = es.index(index="datasets_index", doc_type="dataset", body=d)
    print(res['created'])
