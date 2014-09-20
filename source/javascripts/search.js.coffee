$(document).ready ->
  SearchModel = Backbone.Model.extend()
  searchModel = new SearchModel(query: "")

  SearchView = Backbone.View.extend
    initialize: ->
      this.render()
    el: "#top-search"
    events:
      "click .submit" : "search"
    search: ->
      query = this.$("input[name='query']").val()
      searchRouter.navigate("search/" + query)
      false
    template: ->
      $('#top-search-template').html()
    render: ->
      template = this.template()
      Mustache.parse(template)
      this.$el.html Mustache.render(template, this.model.attributes)
      this

  SearchRouter = Backbone.Router.extend
    routes:
      "search/:query": "search"
      "search/:query/:page": "search"
    search: (query, page) ->
      searchModel.set(query: query)
      searchView.render()

  searchRouter = new SearchRouter()

  searchView = new SearchView
    model: searchModel

  Backbone.history.start()
