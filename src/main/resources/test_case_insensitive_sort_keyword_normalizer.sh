#!/usr/bin/env bash
curl -X DELETE "localhost:9200/testindex_normal_sort"

curl -XPUT 'http://localhost:9200/testindex_normal_sort'  -H "Content-Type: application/json" -d '
{
  "settings": {
    "analysis": {
      "normalizer": {
        "case_insensitive": {
          "filter": "lowercase"
        }
      }
    }
  }
}'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/_mapping/testmapping'  -H "Content-Type: application/json" -d '
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


curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/1'  -H "Content-Type: application/json" -d '
{
	"Id": 1,
	"Name": "bbb"
}'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/8'  -H "Content-Type: application/json" -d '
{
	"Id": 8,
	"Name": "ccc"
}

'
curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/2'  -H "Content-Type: application/json" -d '
{
	"Id": 2,
	"Name": "aaa"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/3'  -H "Content-Type: application/json" -d '
{
	"Id": 3,
	"Name": "AAA"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/4'  -H "Content-Type: application/json" -d '
{
	"Id": 4,
	"Name": "BBB"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 5,
	"Name": "CCC"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/6'  -H "Content-Type: application/json" -d '
{
	"Id": 6,
	"Name": "BCA"
}
'

curl -XPUT 'http://localhost:9200/testindex_normal_sort/testmapping/7'  -H "Content-Type: application/json" -d '
{
	"Id": 7,
	"Name": "bca"
}
'


curl -XPOST 'http://localhost:9200/testindex_normal_sort/testmapping/_search'  -H "Content-Type: application/json" -d '{
	"query": {
		"match": {
			"Name": "a"
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

curl -X POST "localhost:9200/testindex_normal_sort/_refresh"

curl -XPOST 'http://localhost:9200/testindex_normal_sort/_analyze'  -H "Content-Type: application/json" -d '
{
	"field": "testmapping.Name",
	"text": "bbb"
}
'

curl -XGET 'http://localhost:9200/testindex_normal_sort/testmapping/_search?sort=Name'  -H "Content-Type: application/json"

curl -XGET 'http://localhost:9200/testindex_normal_sort/testmapping/_search?sort=Name.keyword'  -H "Content-Type: application/json"
