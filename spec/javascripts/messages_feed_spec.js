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

asyncTest('appends received messages', 2, function () {
  var feed = new MessagesFeed();
  var feedView = new FeedView( {collection: feed} );

  this.server.respondWith('/rooms/1/feed.json', [ 200,
                            { 'Content-Type': 'application/json' },
                            '[{"id": 1, "body": "Hey there" }]'
                          ]);

  feed.room_id = 1;

  setTimeout(function () {
    equal(feed.length, 1, 'populates the collection');
    equal(feedView.$('.message').text(), 'Hey there', 'Feed should insert messages in DOM');
    feed.stop();
    start();
  }, 100);
  feed.start();
});

asyncTest('persists a new message', function () {
  expect( 1 );
  this.server.respondWith('POST', '/rooms/1/messages', [ 200,
                            { 'Content-Type': 'application/json' },
                            '{"id":1, "body":"bose"}'
                          ]);

  var message = new Message( {body: 'bose'} );

  message.save();

  setTimeout(function () {
    ok(!message.isNew(), 'Message instance didnt save');
    start();
  }, 10);
});

module( 'Message View', {
  setup: function () {
    fixture.set( '<form id="test-form" action="/">' +
                   '<input type="text"></input>' +
                   '<input type="submit" value="Submit">' +
                 '</form>');
  },
  teardown: function () { fixture.cleanup(); }
});

asyncTest('It prevents regular form behavior', function () {
  expect( 1 );

  // Depends on what handler gets binded first.
  // the messageForm needs to be created before the test on() listener.
  var messageForm = new MessageForm( {el: '#test-form'} );

  $('#test-form').on( 'submit', function (e) {
    ok( e.isDefaultPrevented(), 'Form should be defaultPrevented' );
    start();
  });

  $('#test-form').submit();
});


asyncTest('It creates a new message', function () {
  expect( 2 );

  Backbone.sync = function ( method, model, options ) {
    equal( method, 'create', 'Method was: ' + method );
    equal( model.get('body'), 'more coffee', 'Body was: ' + model.get('body') );
    start();
  };

  var messageForm = new MessageForm( {el: '#test-form'} );
  messageForm.setBody('more coffee');
  messageForm.submit();
});
