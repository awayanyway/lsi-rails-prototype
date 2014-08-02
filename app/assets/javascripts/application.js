// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require_directory .
//= require bootstrap
//= require bootstrap-sprockets
//= require cocoon
//= require bootstrap-wysiwyg
//= require websocket_rails/main
//= require jquery-hotkeys
//= require best_in_place
//= require ./external/events.js
//= require ./external/flotr2.js
//= require ./external/jquery.formvalidator.min.js
//= require ./external/justgage.1.0.1.min.js
//= require ./external/numerous-2.1.1.min.js
//= require ./external/processing-1.3.6.min.js
//= require ./external/raphael-min.js
//= require ./external/typeahead.js
//= require ./own/smartinput.js

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});