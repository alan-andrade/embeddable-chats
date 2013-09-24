var MessageView = Backbone.View.extend({
  className: 'message',
  template: _.template("<li data-created_at='<%= created_at %>'><%= body %></li>"),
  render: function () {
    return this.$el.html(this.template(this.model.attributes))
  }
});

var Message = Backbone.Model.extend({
  url: '/rooms/1/messages'
});

var MessagesFeed = Backbone.Collection.extend({
  model: Message,
  initialize: function () {
    this.startTime = new Date().toJSON();
  },
  url: function () {
    return '/rooms/' + this.room_id + '/feed.json';
  },
  pollCount: 0,
  pollTimeout: 2000,
  getPollCount: function () { return this.pollCount; },
  increasePollCount: function () { this.pollCount++; },
  start: function () {
    this.on('add', this.updateStartTime);

    this.fetch();
    this.increasePollCount();

    var self = this;
    this.pollInterval = setInterval(function () {
                          self.fetch();
                          self.increasePollCount();
                        }, this.pollTimeout);
  },
  fetch: function () {
    var params = { created_at: this.startTime }

    Backbone.Collection.prototype.fetch.call(
      this,
      { data: params }
    );
  },
  stop: function () {
    clearInterval( this.pollInterval );
  },
  updateStartTime: function () {
    this.startTime = new Date().toJSON();
  }
});

var FeedView = Backbone.View.extend({
  initialize: function() {
    this.collection.on('add', this.render, this);
  },
  render: function () {
    this.collection.each(function (message) {
      var messageView = new MessageView({ model: message });
      this.$el.append(messageView.render());
    }, this);
  }
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

  events: {
    'submit': 'submit'
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
    var self = this;
    message.save({}, {
      success: function () {
        self.$body().val('');
      }
    });
  }
});
