var MessageView = Backbone.View.extend({
  className: 'message',
  template: _.template("<%= body %>"),
  render: function () {
    return this.$el.html(this.template(this.model.attributes))
  }
});

var MessagesFeed = Backbone.Collection.extend({
  url: function () {
    return '/rooms/' + this.room_id + '/feed.json';
  },
  pollCount: 0,
  getPollCount: function () { return this.pollCount; },
  increasePollCount: function () { this.pollCount++; },
  start: function () {
    this.fetch();
    this.increasePollCount();
    var self = this;
    this.poll =
      setInterval(function () {
        self.fetch();
        self.increasePollCount();
      }, 2000);
  },
  stop: function () {
    clearInterval(this.poll);
  }
});


var FeedView = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.collection, 'sync', this.render);
  },
  render: function () {
    this.collection.each(function (message) {
      var messageView = new MessageView( {model: message} );
      this.$el.append(messageView.render());
    }, this);
  }
});
