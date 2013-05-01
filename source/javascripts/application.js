// libraries

//= require libraries/jquery-1.9.1
//= require libraries/handlebars-1.0.0-rc.3
//= require libraries/ember-1.0.0-rc.3

// application

//= require_self
//= require router
//= require_tree ./routes
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./templates

(function($) {

  // start the application
  window.Parachute = Ember.Application.create();

})(jQuery);