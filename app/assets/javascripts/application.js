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
//= require pickup-calendar.js
//= require autosubmit
//= require jquery.dotdotdot.js
//= require karnegram.js

$(document).ready(function(){
  $('[data-behaviour~=datepicker]').datepicker({
    language: "sv",
    todayHighlight: true,
    autoclose: true
  });
});

$(document).ready(function(){
  var currentDate = new Date();
  currentDate.setTime(currentDate.getTime() + 15*60*1000);
  var minutes = currentDate.getMinutes();
  var hours = currentDate.getHours();
  var m = (parseInt((minutes + 7.5)/15) * 15) % 60;
  var h = minutes > 52 ? (hours === 23 ? 0 : ++hours) : hours;

  $('.timepicker').timepicker({
    template: false,
    minuteStep: 15,
    defaultTime: h+":"+m,
    showMeridian: false
  });
});

$(document).ready(function() {
  $(".ellipsis").dotdotdot({
    watch: "window"
  });
});
