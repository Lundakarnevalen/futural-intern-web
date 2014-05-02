//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.cookie
//= require jquery.validate
//= require bootstrap
//= require bootstrap-datepicker/core.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.sv.js
//= require bootstrap-timepicker
//= require main
//= require karnevalister
//= require sektioner
//= require additional-methods
//= require messages_sv
//= require cloud-swag
//= require karnevalist.ui.js
//= require turbolinks
//= require fullcalendar
//= require warehouse.js
//= require autosubmit
//= require jquery.dotdotdot.js
//= require karnegram.js

$(document).ready(function(){
  $('[data-behaviour~=datepicker]').datepicker({
    language: "sv",
    autoclose: true
  });


  $('.timepicker').timepicker({
    template: false,
    minuteStep: 15,
    showMeridian: false
  });
});

$(document).ready(function() {
  $(".ellipsis").dotdotdot({
    watch: "window"
  });
});
