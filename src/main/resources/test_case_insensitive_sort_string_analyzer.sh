curl -X DELETE "localhost:9200/my_index_string"

curl -XPUT 'http://localhost:9200/my_index_string'  -H "Content-Type: application/json" -d '
{
  "settings": {
    "analysis": {
      "analyzer": {
        "case_insensitive_sort": {
          "tokenizer": "keyword",
          "filter":  [ "lowercase" ]
        }
      }
    }
  }
}'

curl -XPUT 'http://localhost:9200/my_index_string/_mapping/user'  -H "Content-Type: application/json" -d '
{
  "properties": {
    "name": {
      "type": "text",
      "fields": {
        "lower_case_sort": {
          "type":     "text",
		  "fielddata": true,
          "analyzer": "case_insensitive_sort"
        }
      }
    }
  }
}'


curl -XPUT 'http://localhost:9200/my_index_string/user/1'  -H "Content-Type: application/json" -d '
{ "name": "Boffey" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/2'  -H "Content-Type: application/json" -d '
{ "name": "BROWN" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/3'  -H "Content-Type: application/json" -d '
{ "name": "Boffey" }'


curl -XPUT 'http://localhost:9200/my_index_string/user/4'  -H "Content-Type: application/json" -d '
{ "name": "bailey" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/5'  -H "Content-Type: application/json" -d '
{ "name": "Apple" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/6'  -H "Content-Type: application/json" -d '
{ "name": "apple" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/7'  -H "Content-Type: application/json" -d '
{ "name": "Banana" }'

curl -XPUT 'http://localhost:9200/my_index_string/user/8'  -H "Content-Type: application/json" -d '
{ "name": "banana" }'


curl -X POST "localhost:9200/my_index_string/_refresh"

curl -XGET 'http://localhost:9200/my_index_string/user/_search?sort=name.lower_case_sort'  -H "Content-Type: application/json"
