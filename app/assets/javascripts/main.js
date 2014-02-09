$(function() {
	var form = $('form.validate');
	if (form.length) {
		form.validate({
			errorElement: "div",
			errorClass: "error-message",
			errorPlacement: function(error, element) {
				if(element.is('input[type=radio]')) {
					error.appendTo(element.parents('.radio-group'));
				} else if (element.is('input[type=checkbox]') ) {
					if (element.attr("id") == "pul") {
						error.appendTo(element.parents('.form-group'));
					} else {
						error.prependTo(element.parents('.form-group'));
					}
				} else {
					error.insertAfter(element);
				}
    		},
			rules: {
				"karnevalist[kon_id]": {
					required: true
				},
				"karnevalist[storlek_id]": {
					required: true
				},
				"karnevalist[intresse_ids][]": {
					required: true,
					minlength: 3
				},
				"karnevalist[sektion_ids][]": {
					required: true,
					minlength: 5
				}
			},
			messages: {
				"karnevalist[intresse_ids][]": {
					minlength: jQuery.format("Ange minst {0} intressen.")
				},
				"karnevalist[sektion_ids][]": {
					minlength: jQuery.format("Ange minst {0} sektioner.")
				}
			},
			invalidHandler: function(event, validator) {
      		  	$(this).find('input[type=submit]').removeAttr("disabled");
        	},
        	submitHandler: function(form) {
        		$(this).find('input[type=submit]').attr('disabled', 'disabled');
        		if (document.getElementById('karnevalist_image_data').value == '') {
          			$('.form-controls').prepend('<div class="error-message">Bilden har inte sparats! Starta om Chrome med rätt flagga. Gibberish? Prata med IT!</div>');
          		} else {
          			form.submit();
          		}
        	}
		});
	}

});
