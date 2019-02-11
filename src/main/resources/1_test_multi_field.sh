curl -X DELETE "localhost:9200/my_index"

curl -X PUT "localhost:9200/my_index" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "city": {
        "type": "text",
        "fields": {
          "raw": {
            "type":  "keyword"
          }
        }
      }
    }
  }
}
'
curl -X PUT "localhost:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "city": "New York"
}
'
curl -X PUT "localhost:9200/my_index/_doc/2" -H 'Content-Type: application/json' -d'
{
  "city": "York"
}
'
curl -X GET "localhost:9200/my_index/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "city": "york"
    }
  },
  "sort": {
    "city.raw": "asc"
  },
  "aggs": {
    "Cities": {
      "terms": {
        "field": "city.raw"
      }
    }
  }
}
'
