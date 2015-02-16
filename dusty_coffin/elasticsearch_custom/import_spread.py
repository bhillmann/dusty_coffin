__author__ = 'bhillmann'

import urllib.request
from io import BytesIO
import pandas as pd
import json
from elasticsearch import Elasticsearch


csv = urllib.request.urlopen("https://docs.google.com/spreadsheet/pub?key=0Ahf71UaPpMOSdGl0NnQtSFgyVFpvSmV3R2JobzVmZHc&output=csv").read()
bio = BytesIO(csv)
csv_pd = pd.DataFrame.from_csv(bio)
csv_pd.shape
json_objs = csv_pd.reset_index().to_json(orient='index')
d = json.loads(json_objs)
es = Elasticsearch('ec2-52-10-17-100.us-west-2.compute.amazonaws.com:9200')
for key in d:
    print(d[key])
    res = es.index(index="datasets_index", doc_type="dataset", body=d[key])
    print(res['created'])
