var MessagesFeed = function(url) {
  // pollCount is a counter mainly for testing purposes.
  var pollCount = 0;
  var increasePollCounter = function() { pollCount++ };

  // retrieveMessages will request new messages from the server.
  //
  var retrieveMessages = function(){
    $.get(url).always(increasePollCounter);
  };

  // Public
  //
  // Exposes the amount of times the feed has poked the server.
  this.getPollCount = function() {
    return pollCount
  };

  // Starts the process of polling every 2 seconds for new messages.
  this.start = function() {
    retrieveMessages();
    setInterval(retrieveMessages, 2000);
  }

};
