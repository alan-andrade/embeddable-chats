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
  pollTimeout: 2000,
  getPollCount: function () { return this.pollCount; },
  increasePollCount: function () { this.pollCount++; },
  start: function () {
    this.fetch();
    this.increasePollCount();
    var self = this;
    this.pollInterval = setInterval(function () {
                          self.fetch();
                          self.increasePollCount();
                        }, this.pollTimeout);
  },
  stop: function () {
    clearInterval(this.pollInterval);
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

var Message = Backbone.Model.extend({
  url: '/rooms/1/messages'
});

var MessageForm = Backbone.View.extend({
  initialize: function () {
    // Prevent normal form behavior so that this view can take over.
    if ( this.el ) {
      $(this.el).submit(function (e) {
        e.preventDefault();
      });
    }
  },

  '$body': function () { return this.$('input[type="text"]') },

  body: function ( text ) {
    if ( text === undefined ) {
      return this.$body.val();
    } else {
      this.$body.val( text );
    }
  },

  setBody: function ( text ) {
    this.$('input[type="text"]').val( text );
  },

  submit: function () {
    var message = new Message( {body: this.$body().val()} );
    message.save();
  }
});
