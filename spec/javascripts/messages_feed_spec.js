module('Messages Feed');

test('echoes', function(){
  equal(MessagesFeed.echo(2), 2, 'Not echoing');
});
