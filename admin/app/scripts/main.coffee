class @DatasetsViewModel
  constructor: ->
    @datasetBeenSelected = ko.observable(false)
    @datasetSelected = ko.observable(new Dataset @)
    @showDialog = ko.observable(false)
    @submitModal = ()=>
    @client = new elasticsearch.Client({
      host: 'ec2-52-10-17-100.us-west-2.compute.amazonaws.com:8080'
      })

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
        req.open 'GET', 'http://ec2-52-10-17-100.us-west-2.compute.amazonaws.com:8080/datasets_index/_search?&size=' + count, true

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
    @client.update({
      index: 'datasets_index',
      type: 'dataset',
      id: @datasetSelected().id(),
      body: {
        doc: {
              author: @datasetSelected().author()
              description: @datasetSelected().description()
              frequency: @datasetSelected().frequency()
              geographic_granularity: @datasetSelected().geographic_granularity()
              location: @datasetSelected().location()
              source_type: @datasetSelected().source_type()
              tag_words: @datasetSelected().tag_words()
              time_periods: @datasetSelected().time_periods()
              timestamp: @datasetSelected().timestamp()
              title: @datasetSelected().title()
              types: @datasetSelected().types()
              url: @datasetSelected().url()
        }
      }
    }, (error, response)=>
      console.log(error)
      console.log(response)
      @client.indices.flush(()->
        location.reload())
    )

  submitDeleteDataset: ()=>
    @client.delete({
      index: 'datasets_index',
      type: 'dataset',
      id: @datasetSelected().id()
    }, (error, response)=>
      console.log(error)
      console.log(response)
      @client.indices.flush(()->
        location.reload())
    )

  newDataset: ()=>
    if @datasetBeenSelected()
      @datasetSelected().isSelected(false)
    @datasetBeenSelected(false)
    @datasetSelected(new Dataset(@))
    @datasetSelected().isSelected(true)
    @submitModal = @submitNewDataset
    @showDialog(true)

  submitNewDataset: ()=>
    @showDialog(false)
    @client.create({
      index: 'datasets_index',
      type: 'dataset',
      body: {
        author: @datasetSelected().author()
        description: @datasetSelected().description()
        frequency: @datasetSelected().frequency()
        geographic_granularity: @datasetSelected().geographic_granularity()
        location: @datasetSelected().location()
        source_type: @datasetSelected().source_type()
        tag_words: @datasetSelected().tag_words()
        time_periods: @datasetSelected().time_periods()
        timestamp: @datasetSelected().timestamp()
        title: @datasetSelected().title()
        types: @datasetSelected().types()
        url: @datasetSelected().url()
      }
    }, (error, response)=>
      console.log(error)
      console.log(response)
      @client.indices.flush(()->
        location.reload())
    )

class Dataset
  constructor: (@view, hit='')->
    @author = ko.observable()
    @description = ko.observable()
    @frequency = ko.observable()
    @geographic_granularity = ko.observable()
    @location = ko.observable()
    @source_type = ko.observable()
    @tag_words =  ko.observableArray()
    @time_periods = ko.observableArray()
    @timestamp = ko.observable()
    @title = ko.observable()
    @types = ko.observableArray()
    @url = ko.observable()
    if hit
      @id =  ko.observable(hit._id)
      @fromSource(hit._source)
    @isSelected = ko.observable(false)

  fromSource: (source)=>
    @author(source.author)
    @description(source.description)
    @frequency(source.frequency)
    @geographic_granularity(source.geographic_granularity)
    @location(source.location)
    @source_type(source.source_type)
    @tag_words(source.tag_words)
    @time_periods(source.time_periods)
    @title(source.title)
    @types(source.types)
    @url(source.url)

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
