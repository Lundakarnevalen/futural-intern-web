$(function() {

	var form = $('form');
	if (form.length) {
		form.each(function() {
			$(this).validate({
				errorElement: "div",
				errorClass: "error-message",
				rules: {
					"karnevalist[kon_id]": {
						required: true
					},
					"karnevalist[storlek_id]": {
						required: true
					}
				}
			});
		});
	}

});