class @DatasetsModel

  constructor: ->

    tableOptions =
      recordWord:       'dataset'
      recordWordPlural: 'datasets'
      sortDir:          'desc'
      sortField:        'title'
      perPage:          10
      unsortedClass:    'glyphicon glyphicon-sort'
      ascSortClass:     'glyphicon glyphicon-sort-by-attributes'
      descSortClass:    'glyphicon glyphicon-sort-by-attributes-alt'

    @table = new DataTable [], tableOptions
    @table.loading true

    req = new XMLHttpRequest()
    req.open 'GET', 'http://ec2-52-10-17-100.us-west-2.compute.amazonaws.com:8080/datasets_index/_search?', true

    req.onload = =>
      if req.status >= 200 and req.status < 400
        response = JSON.parse req.responseText
        hits = response.hits.hits.map (hit) => new Datasets @, hit
        @table.rows hits
        @table.loading false
      else
        alert "Error communicating with server"
        @table.loading false

    req.onerror = =>
      alert "Error communicating with server"
      @table.loading false

    req.send()

    ko.applyBindings @

class Datasets

  constructor: (@view, hit)->
    @title = hit._source.title
    @type = hit._source.type
    @url = hit._source.url
