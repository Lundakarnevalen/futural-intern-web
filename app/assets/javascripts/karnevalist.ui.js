var touch = function() { return !!('ontouchstart' in window); };

//bind the touch event
(function() {
	
	if(touch() == true) {

		document.addEventListener('touchstart', function(event) {});
		document.addEventListener('touchend', 	function(event) {});

	}

	
}).call(this);

var action_event = function() {
	
	return (touch() == true) ? 'touchstart' : 'mousedown';	
	
};

var leave_event = function() {
	
	return (touch() == true) ? 'touchend' : 'mouseup';
	
}

$(function() {

	var flash = function() {
		
		return $('.alert,.notice');
		
	}
	
	//$('body').fadeOut(0).fadeIn(200);

	$('.dropdown > .header').bind(action_event(), function() {
		
		$(this).parent().toggleClass('toggled');
		
	});
	
	flash().bind(action_event(), function() {
		
		$(this).slideUp(200);
		
	});
	
	window.setTimeout(function() {
	
		flash().fadeOut(200);
	
	}, 5000); //got to have some time to read.

});