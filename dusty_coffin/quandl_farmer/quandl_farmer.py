import Quandl
import json
import time


def import_api_token():
    with open('api_tok.json', 'r') as f:
        dic = json.load(f)
        return dic['api_tok']


def main():
    count = 0
    # api_tok = import_api_token()
    query = '*'
    while True:
        # result = Quandl.search(query, authtoken=api_tok, verbose=False, page=count)
        result = Quandl.search(query, verbose=False, page=count)
        if not result:
            break
        print("Result returned. Dumping JSON page %d" % count)
        with open('./json/%0d.json' % time.time(), 'w') as f:
            json.dump(result, f)
            f.close()
        count += 1
    print('-----Done-----')


if __name__ == main():
    main()