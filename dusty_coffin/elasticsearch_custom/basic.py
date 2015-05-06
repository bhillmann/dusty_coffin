from elasticsearch import Elasticsearch
import os
import json

es = Elasticsearch("54.186.66.162:9200")

path = '../quandl_farmer/json'

for (dirpath, dirnames, filenames) in os.walk(path):
    for filename in filenames:
        with open(os.path.join(path, filename)) as f:
            list_data = json.load(f)
            for doc in list_data:
                es.create(index="test-index", doc_type='test', body=doc)
