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
        "lowercase_normalizer": {
               "type": "custom",
               "filter": ["lowercase"]
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
      "analyzer": "simple",
      "fields": {
        "case_insensitive_sort": {
          "type": "keyword",
          "normalizer": "lowercase_normalizer"
        }
      }
    }
  }
}'


curl -XPUT 'http://localhost:9200/testindex/testmapping/1'  -H "Content-Type: application/json" -d '
{
	"Id": 1,
	"Name": "ABC"
}'

curl -XPUT 'http://localhost:9200/testindex/testmapping/8'  -H "Content-Type: application/json" -d '
{
	"Id": 8,
	"Name": "BCA"
}

'
curl -XPUT 'http://localhost:9200/testindex/testmapping/2'  -H "Content-Type: application/json" -d '
{
	"Id": 2,
	"Name": "CAB"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/3'  -H "Content-Type: application/json" -d '
{
	"Id": 3,
	"Name": "abc"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/4'  -H "Content-Type: application/json" -d '
{
	"Id": 4,
	"Name": "bca"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 5,
	"Name": "cab"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 6,
	"Name": "apple"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 7,
	"Name": "apple"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 8,
	"Name": "Banana"
}
'

curl -XPUT 'http://localhost:9200/testindex/testmapping/5'  -H "Content-Type: application/json" -d '
{
	"Id": 9,
	"Name": "banana"
}
'


curl -XPOST 'http://localhost:9200/testindex/testmapping/_search'  -H "Content-Type: application/json" -d '
{
	"query": {
		"match": {
			"Name": "abc"
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
	"text": "bbb"
}
'

curl -XGET 'http://localhost:9200/testindex/testmapping/_search?sort=Name.case_insensitive_sort'  -H "Content-Type: application/json"
