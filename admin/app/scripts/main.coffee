class @DatasetsModel

  constructor: ->
    @selected = ko.observable()
    tableOptions =
      recordWord:       'dataset'
      recordWordPlural: 'datasets'
      sortDir:          'desc'
      sortField:        'title'
      perPage:          @size
      unsortedClass:    'glyphicon glyphicon-sort'
      ascSortClass:     'glyphicon glyphicon-sort-by-attributes'
      descSortClass:    'glyphicon glyphicon-sort-by-attributes-alt'

    @table = new DataTable [], tableOptions
    @table.loading true
    req_size = new XMLHttpRequest()
    req_size.open 'GET', 'http://ec2-52-10-17-100.us-west-2.compute.amazonaws.com:8080/datasets_index/_count', true
    req_size.onload = =>
      if req_size.status >= 200 and req_size.status < 400
        count = JSON.parse(req_size.responseText).count
        req = new XMLHttpRequest()
        req.open 'GET', 'http://ec2-52-10-17-100.us-west-2.compute.amazonaws.com:8080/datasets_index/_search?&size=68', true

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
      else
        alert "Error communicating with server"
        @table.loading false

    req_size.onerror = =>
      alert "Error communicating with server"
      @table.loading false

    req_size.send()
    ko.applyBindings @

  selectDataset: (dataset)=>
    if @selected()
      @selected().isSelected(false)
    @selected(dataset)
    @selected().isSelected(true)

class Datasets
  constructor: (@view, hit)->
    @title = hit._source.title
    @type = hit._source.type
    @url = hit._source.url
    @id = hit._id
    @isSelected = ko.observable(false)

  clickHandler: ()=>
    @view.selectDataset(@)
