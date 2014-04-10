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

	$('.dropdown > .header').bind(action_event(), function() {
		
		$(this).parent().toggleClass('toggled');
		
	});

});