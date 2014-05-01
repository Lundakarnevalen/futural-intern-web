(function() {
  $(function() {
    $('.js-hide').hide();

    $('form').each(function() {
      var form = $(this);
      form.find('.autosubmit').change(function() {
        var url = form.attr('action') + '?' + form.serialize();
        Turbolinks.visit(url);
      });
    });
  });
}).call(this);

