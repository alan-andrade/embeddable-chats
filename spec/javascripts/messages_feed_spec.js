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

test( 'polls every 2 seconds', function () {
  var clock = this.sandbox.useFakeTimers();
  var feed = new MessagesFeed();
  feed.start();
  clock.tick(2500);
  equal(feed.getPollCount(), 2, 'Feed is not polling every 2 seconds.')
  clock.restore();
});

test( 'limits each request by a date', function () {
  sinon.spy( Backbone, 'sync' );

  var feed = new MessagesFeed();

  feed.fetch();

  var request = Backbone.sync.getCall( 0 );
  var params = request.args[2].data;

  ok( !!params.created_at, 'Requests are not being trimmed by date' );
});

asyncTest( 'appends received messages', function () {
  expect( 2 );
  var feed = new MessagesFeed();
  var feedView = new FeedView({ collection: feed });

  var response = [{ id: 5,
    body: 'fake plastic servers',
    created_at: new Date()
  }];

  this.server.respondWith( JSON.stringify(response) );

  feed.room_id = 1;

  setTimeout(function () {
    equal( feed.length, 1, 'populates the collection' );
    equal( feedView.$('.message').text(),
          'fake plastic servers',
          'Feed should insert messages in DOM');
    feed.stop();
    start();
  }, 500);

  feed.start();
});

asyncTest( 'persists a new message in the server', function () {
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

module( 'Message Form', {
  setup: function () {
    fixture.set( '<form id="test-form" action="/">' +
                   '<input type="text"></input>' +
                   '<input type="submit" value="Submit">' +
                 '</form>');
  },
  teardown: function () { fixture.cleanup(); }
});

asyncTest('It attaches to a form and prevents its default behavior', function () {
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


asyncTest('It posts message to the server', function () {
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


module( 'Message View' );

test( 'renders the message creation date in a data attribute', function () {
  var time = ( new Date() ).toJSON();
  var message = new Message({
    body: 'Tester'
    , created_at: time
  });
  var messageView = new MessageView( { model: message } );

  var rendered = messageView.render();
  ok(rendered.html().match(time),
     'Message view is not rendering the date in the element');
});
