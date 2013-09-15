module('Messages Feed', {
  setup: function () {
    sinon.config.useFakeTimers = false
    this.server = sinon.fakeServer.create();
    this.server.autoRespond = true;
  },
  teardown: function () {
    this.server.restore();
  }
});

test('polls every 2 seconds', function () {
  var clock = this.sandbox.useFakeTimers();
  var feed = new MessagesFeed();
  feed.start();
  clock.tick(2500);
  equal(feed.getPollCount(), 2, 'Feed is not polling every 2 seconds.')
  clock.restore();
});

asyncTest('appends the received messages to #messages-output', 2, function () {
  var feed = new MessagesFeed();
  var feedView = new FeedView( {collection: feed} );

  this.server.respondWith('/rooms/1/feed.json', [ 200,
                            { 'Content-Type': 'application/json' },
                            '[{"id": 1, "body": "Hey there" }]'
                          ]);

  feed.room_id = 1;
  feed.on('sync', function(e){
    equal(feed.length, 1, 'populates the collection');
    equal(feedView.$('.message').length, 1, 'Feed should insert messages in DOM');
    feed.stop();
    start();
  });

  feed.start();
});
