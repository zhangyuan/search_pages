$(document).ready ->
  serverRoute = {
    search: "search.js"
  }

  topSearchTemplate = $('#top-search-template').html()
  Mustache.parse topSearchTemplate
  searchResultsTemplate = $("#search-results-template").html()
  Mustache.parse searchResultsTemplate

  SearchModel = Backbone.Model.extend()
  SearchResultModel = Backbone.Model.extend()

  SearchView = Backbone.View.extend
    initialize: ->
      this.render()
    el: "#top-search"
    events:
      "click .submit" : "search"
    search: ->
      query = this.$("input[name='query']").val()
      searchRouter.navigate("search/" + query, {trigger: true})
      false
    template: ->
      topSearchTemplate
    render: ->
      this.$el.html Mustache.render(this.template(), this.model.attributes)
      this

  SearchResultsView = Backbone.View.extend
    initialize: ->
    template: ->
      $("#search-results-template").html()
    el: "#search-results"
    render: ->
      this.$el.html Mustache.render(searchResultsTemplate, this.model.attributes)
      this

  SearchRouter = Backbone.Router.extend
    routes:
      "search/:query": "search"
      "search/:query/:page": "search"
      "*path" : "home"
    home: ->
      console.log "home"
      searchModel = new SearchModel(query: "")
      searchView = new SearchView(model: searchModel)
    search: (query, page) ->
      searchModel = new SearchModel(query: "")
      searchView = new SearchView(model: searchModel)

      searchResultModel = new SearchResultModel(query: query)
      searchResultsView = new SearchResultsView(model: searchResultModel)

      searchModel.on "change", ->
          searchView.render()

        searchResultModel.on "change", ->
          searchResultsView.render()
      if query
        searchModel.set(query: query)
        url = serverRoute.search
        url += "?query=" + query

        if page
          url += "&page=" + page
        searchResultModel.fetch(url: url)

  searchRouter = new SearchRouter()
  
  Backbone.history.start()
