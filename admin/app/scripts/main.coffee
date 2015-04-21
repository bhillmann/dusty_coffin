class @DatasetsViewModel
  constructor: ->
    @datasetBeenSelected = ko.observable(false)
    @datasetSelected = ko.observable(new Dataset @)
    @showDialog = ko.observable(false)
    @submitModal = ()=>

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
            hits = response.hits.hits.map (hit) => new Dataset @, hit
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
    if @datasetBeenSelected()
      @datasetSelected().isSelected(false)
    else
      @datasetBeenSelected(true)
    @datasetSelected(dataset)
    @datasetSelected().isSelected(true)

  editDataset: ()=>
    @submitModal = @submitEditDataset
    @showDialog(true)

  submitEditDataset: ()=>
    console.log('edit')
    @showDialog(false)

  submitDeleteDataset: ()=>
    console.log('delete')

  newDataset: ()=>
    if @datasetBeenSelected()
      @datasetSelected().isSelected(false)
    @datasetBeenSelected(false)
    @datasetSelected(new Dataset(@))
    @submitModal = @submitNewDataset
    @showDialog(true)

  submitNewDataset: ()=>
    console.log('edit')
    @showDialog(false)

class Dataset
  constructor: (@view, hit='')->
    if hit
      @title = hit._source.title
      @type = hit._source.type
      @url = hit._source.url
      @id = hit._id
    @isSelected = ko.observable(false)

  clickHandler: ()=>
    @view.selectDataset(@)

ko.bindingHandlers.modal =
  init: (element, valueAccessor) ->
    $(element).modal show: false
    value = valueAccessor()
    if typeof value == 'function'
      $(element).on 'hide.bs.modal', ->
        value false
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      $(element).modal 'destroy'
  update: (element, valueAccessor) ->
    value = valueAccessor()
    if ko.utils.unwrapObservable(value)
      $(element).modal 'show'
    else
      $(element).modal 'hide'
