$(function() {

  $('.btn-file :file').on('change', function(event) {
    var input = $(this),
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.closest('.input-group-btn').children('.form-control').val(label);
  });
  $('a .img-modal-toggle').click(function(e) {
    $('#img-modal .modal-body .thumbnail').children('img').attr('src', $(this).attr('src'));
  });


  $('#accept-photo').click(function(e) {
    var self = $(this),
        id = self.data('id');
    $.ajax({
      type: 'PUT',
      url: '/photos/' + id,
      data: { photo: {accepted: true}},
      dataType: 'json',
      success: function() {
        $('#photo-row-' + id).html("");
      },
      error: function() {
        console.log('Error');
      }
    });
  });
});
