$(function() {
    var alertbox = $('p.alert');

    // Code for `sektioner#kollamedlem`
    $('table.kollamedlem').find('tr').each(function(_, k) {
        k = $(k);
        var stat = k.find('span'),
            form = k.find('form'),
            boxes = k.find('input:checkbox'),
            labels = k.find('label');

        labels.click(function(e) {
            e.preventDefault();
            // We need to hack past the strange boxes that someone programmed.
            var forbox = $(this).attr('for'),
                thebox = boxes.filter('#' + forbox);

            thebox.click();
            thebox.attr('checked') ? thebox.attr('checked', null) :
                                     thebox.attr('checked', 'checked');
            stat.removeClass().addClass('medlem-wait');
            form.submit();
        });
        form.bind('ajax:error', function(e, xhr, _, _) {
            var errors;
            try {
                errors = $.parseJSON(xhr.responsetext);
            } catch(_) {
                errors = { message: 'Oklart fel' };
            }
            alertbox.html('Dina ändringar sparades inte! Servern säger: ' + 
                          errors.message);
        });
        form.bind('ajax:complete', function(e, _, _, _) {
            stat.removeClass();
            var success = true;
            boxes.each(function(_, b) {
                if($(b).attr('checked') != 'checked') {
                    success = false;
                }
            });
            if(success) {
                stat.addClass('medlem-ok');
            } else {
                stat.addClass('medlem-fail');
            }
        });
    });
});

