(function() {
  $(document).ready(function() {
    var SearchModel, SearchResultModel, SearchResultsView, SearchRouter, SearchView, searchResultsTemplate, searchRouter, serverRoute, topSearchTemplate;
    serverRoute = {
      search: "search.js"
    };
    topSearchTemplate = $('#top-search-template').html();
    Mustache.parse(topSearchTemplate);
    searchResultsTemplate = $("#search-results-template").html();
    Mustache.parse(searchResultsTemplate);
    SearchModel = Backbone.Model.extend();
    SearchResultModel = Backbone.Model.extend();
    SearchView = Backbone.View.extend({
      initialize: function() {
        return this.render();
      },
      el: "#top-search",
      events: {
        "click .submit": "search"
      },
      search: function() {
        var query;
        query = this.$("input[name='query']").val();
        searchRouter.navigate("search/" + query, {
          trigger: true
        });
        return false;
      },
      template: function() {
        return topSearchTemplate;
      },
      render: function() {
        this.$el.html(Mustache.render(this.template(), this.model.attributes));
        return this;
      }
    });
    SearchResultsView = Backbone.View.extend({
      initialize: function() {},
      template: function() {
        return $("#search-results-template").html();
      },
      el: "#search-results",
      render: function() {
        this.$el.html(Mustache.render(searchResultsTemplate, this.model.attributes));
        return this;
      }
    });
    SearchRouter = Backbone.Router.extend({
      routes: {
        "search/:query": "search",
        "search/:query/:page": "search",
        "*path": "home"
      },
      home: function() {
        var searchModel, searchView;
        console.log("home");
        searchModel = new SearchModel({
          query: ""
        });
        return searchView = new SearchView({
          model: searchModel
        });
      },
      search: function(query, page) {
        var searchModel, searchResultModel, searchResultsView, searchView, url;
        searchModel = new SearchModel({
          query: ""
        });
        searchView = new SearchView({
          model: searchModel
        });
        searchResultModel = new SearchResultModel({
          query: query
        });
        searchResultsView = new SearchResultsView({
          model: searchResultModel
        });
        searchModel.on("change", function() {
          return searchView.render();
        });
        searchResultModel.on("change", function() {
          return searchResultsView.render();
        });
        if (query) {
          searchModel.set({
            query: query
          });
          url = serverRoute.search;
          url += "?query=" + query;
          if (page) {
            url += "&page=" + page;
          }
          return searchResultModel.fetch({
            url: url
          });
        }
      }
    });
    searchRouter = new SearchRouter();
    return Backbone.history.start();
  });

}).call(this);
