var FLASH_DURATION = 5000;
var SECTION_SLIDE_SPEED = 250;

//bind the touch event
var touch = function() { return !!('ontouchstart' in window); };
var storageAvailable = function() { return 'localStorage' in window; };

//sections
var adminSection;
var informationSection;

(function() {
	
	if(touch() === true) {

		document.addEventListener('touchstart', function(event) {});
		document.addEventListener('touchend', 	function(event) {});
		console.log('listening for touches.')

	}

	if(storageAvailable() === true) { //to be continued, if the user is hiding one of the sections they'll be stored in localStorage and then accessed every time the page is reloaded.

		adminSection = localStorage.getItem('section_admin');
		informationSection = localStorage.getItem('section_information');

	}
	
}).call(this);

var action_event = function() {
	
	return (touch() == true) ? 'touchstart' : 'mousedown';	
	
};

var leave_event = function() {
	
	return (touch() == true) ? 'touchend' : 'mouseup';
	
};

$(function() {

	var flash = function() {
		
		return $('.alert,.notice');
		
	}
	
	//$('body').fadeOut(0).fadeIn(200);

	$('.dropdown > .header').bind(action_event(), function() {

		var toggledClass = 'toggled';

		var list = $(this).parent().children('ul.nav');
		var dropdown = $(this).parent();

		if(dropdown.hasClass(toggledClass) === true) {

			list.slideUp(SECTION_SLIDE_SPEED, function() {

				dropdown.toggleClass(toggledClass);

			});

		} else {

			dropdown.toggleClass(toggledClass);
			list.slideDown(SECTION_SLIDE_SPEED);

		}
		
	});
	
	flash().bind(action_event(), function() {
		
		$(this).slideUp(200);
		
	});
	
	window.setTimeout(function() {
	
		flash().fadeOut(200);
	
	}, FLASH_DURATION); //got to have some time to read.

});