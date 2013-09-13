module('Messages Feed', {
  setup: function() {
    this.server = sinon.fakeServer.create();
    this.server.autoRespond = true;
  },
  teardown: function() {
    this.server.restore();
  }
});

test('polls every 2 seconds', function() {
  var clock = this.sandbox.useFakeTimers();
  var feed = new MessagesFeed('/feed');
  feed.start();
  clock.tick(2500);
  equal(feed.getPollCount(), 2, 'Feed is not polling every 2 seconds.')
});
