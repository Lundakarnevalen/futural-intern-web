//= require jquery_ujs
//= require notifications
//= require karnevalister
//= require sektioner
//= require jquery.validate
//= require additional-methods
//= require messages_sv
//= require cloud-swag
//= require karnevalist.ui.js
//= require main
//= require jquery.ui.all
//= require jquery.modal
//= require jquery.cookie
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.sv.js

$(document).ready(function(){
  $('[data-behaviour~=datepicker]').datepicker({
    language: "sv",
    autoclose: true
  });
})
