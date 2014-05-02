$(function() {

  $('.btn-file :file').on('change', function(event) {
    var input = $(this),
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.closest('.input-group-btn').children('.form-control').val(label);
  });
  $('a .img-modal-toggle').click(function(e) {
    $('#img-modal .modal-body .thumbnail').children('img').attr('src', $(this).attr('src'));
  });

  function changePhotoStatus(action) {
    var id = $(this).data('id'),
        data = action === 'POST' ? { "_method": "delete" } : { photo: { accepted: true} };
    $.ajax({
      type: action,
      url: '/photos/' + id,
      data: data,
      dataType: 'json',
      success: function() {
        $('#photo-row-' + id).html("");
      },
      error: function() {
        console.log('Error');
      }
    });
  }

  $('.accept-photo').click(function(e) {
    changePhotoStatus.call(this, 'PUT');
   });
  $('.remove-photo').click(function(e) {
    changePhotoStatus.call(this, 'POST');
  });
});
