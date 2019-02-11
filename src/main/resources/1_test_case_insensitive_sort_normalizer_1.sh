#!/usr/bin/env bash
curl -X DELETE "localhost:9200/index_normal"

curl -X PUT "localhost:9200/index_normal" -H 'Content-Type: application/json' -d'
{
 "settings": {
    "analysis": {
      "normalizer": {
        "case_insensitive": {
          "filter": "lowercase"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "foo": {
        "type": "text",
        "fields": {
          "raw": {
            "type":  "keyword",
            "normalizer": "case_insensitive",
            "index": "not_analyzed"
          }
        }
      }
    }
  }
}
'
curl -X PUT "localhost:9200/index_normal/type/1" -H 'Content-Type: application/json' -d'
{
  "foo": "BÀR"
}
'
curl -X PUT "localhost:9200/index_normal/type/2" -H 'Content-Type: application/json' -d'
{
  "foo": "bar"
}
'
curl -X PUT "localhost:9200/index_normal/type/3" -H 'Content-Type: application/json' -d'
{
  "foo": "baz"
}
'

curl -X PUT "localhost:9200/index_normal/type/4" -H 'Content-Type: application/json' -d'
{
  "foo": "apple"
}
'

curl -X PUT "localhost:9200/index_normal/type/5" -H 'Content-Type: application/json' -d'
{
  "foo": "Apple"
}
'

curl -X PUT "localhost:9200/index_normal/type/6" -H 'Content-Type: application/json' -d'
{
  "foo": "banana"
}
'

curl -X PUT "localhost:9200/index_normal/type/7" -H 'Content-Type: application/json' -d'
{
  "foo": "Banana"
}
'

curl -X POST "localhost:9200/index_normal/_refresh"

curl -X GET "localhost:9200/index_normal/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "foo": "BAR"
    }
  }
}
'

curl -X PUT "localhost:9200/index_normal/type/8" -H 'Content-Type: application/json' -d'
{
  "foo": "ABC"
}
'

curl -X PUT "localhost:9200/index_normal/type/9" -H 'Content-Type: application/json' -d'
{
  "foo": "abc"
}
'

curl -X PUT "localhost:9200/index_normal/type/10" -H 'Content-Type: application/json' -d'
{
  "foo": "BCA"
}
'

curl -X PUT "localhost:9200/index_normal/type/11" -H 'Content-Type: application/json' -d'
{
  "foo": "bca"
}
'

curl -X POST "localhost:9200/index_normal/_refresh"

curl -X GET "localhost:9200/index_normal/_search?sort=foo" -H 'Content-Type: application/json'
curl -X GET "localhost:9200/index_normal/_search?sort=foo.case_insensitive" -H 'Content-Type: application/json'
