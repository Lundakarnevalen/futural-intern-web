$(function() {
  $('.btn-file :file').on('change', function(event) {
    var input = $(this),
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.closest('.input-group-btn').children('.form-control').val(label);
  });

  $('a .img-modal-toggle').click(function(e) {
    $('#img-modal .modal-body .thumbnail').children('img').attr('src', $(this).attr('src'));
  });
});
