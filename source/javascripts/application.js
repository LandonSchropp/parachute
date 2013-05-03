// libraries

//= require libraries/jquery-1.9.1
//= require libraries/handlebars-1.0.0-rc.3
//= require libraries/ember-1.0.0-rc.3
//= require libraries/jquery.caret

// application

//= require_self
//= require router
//= require_tree ./routes
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./templates

(function($) {

  // BUG FIX: This is part of a bug fix that detects if the device is running iOS. Normally, user
  // agent sniffing would be considered a bad idea, because it doesn't reliably detect if a feature
  // is implemented. However, in this case the problem stems from a bug with mobile Safari, which
  // can't be detected through feature detection.
  var ios = ( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false );

  // append a class to the html element if the) device is an iOS device
  if (ios)
    $("html").addClass("ios");

  // start the application
  window.Parachute = Ember.Application.create();

})(jQuery);