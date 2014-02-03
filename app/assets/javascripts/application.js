// = require jquery.validate
// = require additional-methods
// = require messages_sv
// = require main
//= require jquery.ui.all
//= require jquery.modal

function tilldelad_sektion_submit(karnevalist_id) {
    (function($){
        $.ajax({
            url: 'http://www.karnevalist.se/karnevalister/'+karnevalist_id+'.json',
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify({"karnevalist": {"tilldelad_sektion": $("#select"+karnevalist_id+" option:selected").val()}}),
            dataType: 'json',
            success: function(data) {
                $("tr#"+karnevalist_id).addClass("yellow");
                if ($("#checkbox"+karnevalist_id).attr('disabled')) {
                    $("#checkbox"+karnevalist_id).removeAttr("disabled");
                }
            },
        }); 
    })(jQuery);
}

function tilldelad_klar_submit(karnevalist_id) {
    (function($){
        $.ajax({
            url: 'http://www.karnevalist.se/karnevalister/'+karnevalist_id+'.json',
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify({"karnevalist": {"tilldelad_klar": $("#checkbox"+karnevalist_id).prop('checked')}}),
            dataType: 'json',
            success: function(data) {
                if ($("#checkbox"+karnevalist_id).prop('checked')) {
                    $("tr#"+karnevalist_id).removeClass("yellow");
                    $("tr#"+karnevalist_id).addClass("green");
                    $("#select"+karnevalist_id).attr('disabled', 'disabled');
                } else {
                    $("tr#"+karnevalist_id).removeClass("green");
                    $("tr#"+karnevalist_id).addClass("yellow");
                    if ($("#select"+karnevalist_id).attr('disabled')) {
                        $("#select"+karnevalist_id).removeAttr("disabled");
                    }
                }
            },
        }); 
    })(jQuery);
}
