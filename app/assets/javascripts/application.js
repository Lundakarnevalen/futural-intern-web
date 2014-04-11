//= require jquery_ujs
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
//= require bootstrap-datepicker/core.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.sv.js
//= require bootstrap/modal

$(document).ready(function(){
  $('[data-behaviour~=datepicker]').datepicker({
    language: "sv",
    autoclose: true
  });
})
