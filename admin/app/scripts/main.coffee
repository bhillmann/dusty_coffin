class @CitiesModel

  constructor: ->

    tableOptions =
      recordWord:       'city'
      recordWordPlural: 'cities'
      sortDir:          'desc'
      sortField:        'population'
      perPage:          15
      unsortedClass:    'glyphicon glyphicon-sort'
      ascSortClass:     'glyphicon glyphicon-sort-by-attributes'
      descSortClass:    'glyphicon glyphicon-sort-by-attributes-alt'

    @table = new DataTable [], tableOptions
    @table.loading true

    req = new XMLHttpRequest()
    req.open 'GET', '/api/cities', true

    req.onload = =>
      if req.status >= 200 and req.status < 400
        response = JSON.parse req.responseText
        rows = response.results.map (row) => new City @, row
        @table.rows rows
        @table.loading false
      else
        alert "Error communicating with server"
        @table.loading false

    req.onerror = =>
      alert "Error communicating with server"
      @table.loading false

    req.send()

    ko.applyBindings @
