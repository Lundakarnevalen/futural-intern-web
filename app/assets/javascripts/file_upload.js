$(function() {
  $('.btn-file :file').on('change', function(event) {
    var input = $(this),
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.closest('.input-group-btn').children('.form-control').val(label);
  });
});
