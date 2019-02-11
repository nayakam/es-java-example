#!/usr/bin/env bash
#curl -XPUT 'http://localhost:9200/testindex'  -H "Content-Type: application/json" -d '
#{
#  "settings": {
#    "analysis": {
#      "analyzer": {
#        "case_insensitive": {
#               "tokenizer": "lowercase"
#        	}
#    	}
#    }
#  }
#}'

#curl -XPUT 'http://localhost:9200/testindex/_mapping/testmapping'  -H "Content-Type: application/json" -d '
#{
#    "properties": {
#      "Id": {
#        "type": "keyword"
#      },
#      "Name": {
#        "type": "text",
#        "analyzer": "case_insensitive",
#        "fields": {
#          "keyword": {
#            "type": "keyword"
#          }
#        }
#      }
#    }
#}'

curl -XPUT 'http://localhost:9200/testindex'  -H "Content-Type: application/json" -d '
{
  "settings": {
    "analysis": {
      "normalizer": {
        "case_insensitive": {
               "tokenizer": "lowercase"
        	}
    	}
    }
  }
}'

curl -XPUT 'http://localhost:9200/testindex/_mapping/testmapping'  -H "Content-Type: application/json" -d '
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
          "normalizer": "case_insensitive"
        }
      }
    }
  }
}'


curl -XPUT 'http://localhost:9200/testindex/testmapping/1'  -H "Content-Type: application/json" -d '
{
	"Id": 1,
	"Name": "III-bbb"
}'

curl -XPUT 'http://localhost:9200/testindex/testmapping/8'  -H "Content-Type: application/json" -d '
{
	"Id": 8,
	"Name": "III-ccc"
}

'
curl -XPUT 'http://localhost:9200/testindex/testmapping/2'  -H "Content-Type: application/json" -d '
{
	"Id": 2,
	"Name": "iii-aaa"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/3'  -H "Content-Type: application/json" -d '
{
	"Id": 3,
	"Name": "iii-AAA"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/4'  -H "Content-Type: application/json" -d '
{
	"Id": 4,
	"Name": "iii-BBB"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 5,
	"Name": "iii-CCC"
}
'


curl -XPOST 'http://localhost:9200/testindex/testmapping/_search'  -H "Content-Type: application/json" -d '
{
	"query": {
		"match": {
			"Name": "iii"
		}
	},
	"sort": [
		{
			"Name.keyword": {
				"order": "asc"
			}
		}]
}
'

curl -XPOST 'http://localhost:9200/testindex/_analyze'  -H "Content-Type: application/json" -d '
{
	"field": "testmapping.Name",
	"text": "IIII-bbb"
}
'

curl -XGET 'http://localhost:9200/testindex/testmapping/_search?sort=name.case_insensitive'  -H "Content-Type: application/json"
