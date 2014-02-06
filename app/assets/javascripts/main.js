$(function() {

	var form = $('form');
	if (form.length) {
		form.validate({
			errorElement: "div",
			errorClass: "error-message",
			errorPlacement: function(error, element) {
				if(element.is('input[type=radio]')) {
					error.appendTo(element.parents('.radio-group'));
				} else if (element.is('input[type=checkbox]') ) {
					error.prependTo(element.parents('.form-group'));
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
			}
		});
	}

});