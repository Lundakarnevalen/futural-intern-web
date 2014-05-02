$(function() {

  $('.btn-file :file').on('change', function(event) {
    var input = $(this),
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.closest('.input-group-btn').children('.form-control').val(label);
  });
  $('a .img-modal-toggle').click(function(e) {
    $('#img-modal .modal-body .thumbnail').children('img').attr('src', $(this).attr('src'));
  });
  var accMsg = 'Fotot godkändes',
      denyMsg = 'Fotot togs bort.';

  function changePhotoStatus(action, msg) {
    var id = $(this).data('id'),
        $status = $('#photo-status'),
        data = action === 'POST' ? { "_method": "delete" } : { photo: { accepted: true} };
    $.ajax({
      type: action,
      url: '/photos/' + id,
      data: data,
      dataType: 'json',
      success: function() {
        $('#photo-row-' + id).html("");
        console.log($status);
        $status
          .text(msg)
          .attr('class', 'alert alert-success alert-dismissible')
          .show();
      },
      error: function() {
        $status
          .text('Operationen kunde inte utföras')
          .attr('class', 'alert alert-danger alert-dismissible')
          .show();
      }
    });
  }

  $('.accept-photo').click(function(e) {
    changePhotoStatus.call(this, 'PUT', accMsg);
   });
  $('.remove-photo').click(function(e) {
    changePhotoStatus.call(this, 'POST', denyMsg);
  });
});
