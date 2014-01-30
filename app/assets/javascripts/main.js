$(function() {
	
	var form = $('form');
	if (form.length) {		
		form.each(function() {
			$(this).validate();
		});
	}

});