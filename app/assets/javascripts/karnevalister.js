$(function() {
  $('form').filter(function(_) {
    return /karnevalist/.test(this.id);
  }).submit(function(e) {
    var that = this;
    if(!$('input.must-accept').is(':checked')) {
      e.preventDefault();
      alert(
        'Du måste acceptera att vi lagrar dina personuppgifter enligt PUL!'
      );
    }
  });
});
