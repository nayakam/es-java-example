#!/usr/bin/env bash

curl -X DELETE "localhost:9200/testindex_normal"

curl -XPUT 'http://localhost:9200/testindex_normal'  -H "Content-Type: application/json" -d '
{
  "settings": {
    "analysis": {
      "analyzer": {
        "case_insensitive": {
          "tokenizer": "keyword",
          "filter": ["lowercase"]
        }
      }
    }
  }
}'


curl -XPUT 'http://localhost:9200/testindex_normal/_mapping/testmapping'  -H "Content-Type: application/json" -d '
{
  "properties": {
    "Id": {
      "type": "keyword"
    },
    "Name": {
      "type": "text",
      "fields": {
        "keyword": {
          "type": "keyword",
          "normalizer": "case_insensitive",
           "index": "not_analyzed"
        }
      }
    }
  }
}
'


curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/1'  -H "Content-Type: application/json" -d '
{
	"Id": 1,
	"Name": "bbb-III"
}'

curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/8'  -H "Content-Type: application/json" -d '
{
	"Id": 8,
	"Name": "ccc-III"
}

'
curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/2'  -H "Content-Type: application/json" -d '
{
	"Id": 2,
	"Name": "aaa-iii"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/3'  -H "Content-Type: application/json" -d '
{
	"Id": 3,
	"Name": "AAA-iii"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/4'  -H "Content-Type: application/json" -d '
{
	"Id": 4,
	"Name": "BBB-iii"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 5,
	"Name": "CCC-iii"
}
'

curl -XPOST 'http://localhost:9200/testindex_normal/testmapping/_search'  -H "Content-Type: application/json" -d '{
	"query": {
		"match": {
			"Name": "iii"
		}
	},
	"sort": [
		{
			"Name.keyword": {
				"order": "desc"
			}
		}]
}
'

curl -XPOST 'http://localhost:9200/testindex_normal/_analyze'  -H "Content-Type: application/json" -d '
{
	"field": "testmapping.Name",
	"text": "IIII-bbb"
}
'

curl -X POST "localhost:9200/testindex_normal/_refresh"

curl -XGET 'http://localhost:9200/testindex_normal/testmapping/_search?sort=Name'  -H "Content-Type: application/json"

curl -XGET 'http://localhost:9200/testindex_normal/testmapping/_search?sort=Name.keyword'  -H "Content-Type: application/json"
