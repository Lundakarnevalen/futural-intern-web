// If not JS, just keep the static cloud arrangement.

(function() {
    // Swagness parameters.
    var N_CLOUDS = 8,
        CLOUD_SIZE = 1.0,
        CLOUD_SPEED = 1.0, // must be <= 1.0
        TICK_SLEEP = 50;  // mseconds between ticks
        FADE_TIME = 10000; //milliseconds until removal.

    // System state
    var w_height,
        w_width,
        clouds = [],
        cont = $('<div class="cloud-container">');

    var cloud_swag = function(div) {
    	if($(div).length > 0) { //made some mess at "home" if not checked.
            update_bounds();
            div.removeClass('clouds');
            $('body').addClass('cloud-bg');
            div.append(cont);
            for(var i = 0; i < N_CLOUDS; i++) {
                gen_cloud(cont);
            }
            clouds = $('.one-cloud');
            setInterval(cloud_tick, TICK_SLEEP);
        }
    };

    var cloud_tick = function() {
        clouds.offset(function(i, coords) {
            var factor = $(this).hasClass('cloud-flipped') ? 1 : -1;
            return { left: coords.left + factor * CLOUD_SPEED };
        });
        clouds.each(function() {
            var pos = $(this).offset().left;
            if(pos > w_width - $(this).width() || pos < 0) {
                $(this).fadeOut(FADE_TIME, function() {
                    $(this).remove();
                });
                clouds = $('.one-cloud');
            }
        });
    };

    var gen_cloud = function(div) {
        var cloud = $('<div class="one-cloud">'),
            factor = Math.random() / 2 + 0.5;
        cloud.css({ height: 144 * CLOUD_SIZE * factor,
                    width: 304 * CLOUD_SIZE * factor,
                    top: random(0, w_height - 144 * CLOUD_SIZE),
                    left: random(0, w_width),
        });
        if(Math.random() > 0.5) {
            cloud.addClass('cloud-flipped');
        }
        div.append(cloud);
        return cloud;
    };

    var update_bounds = function() {
        w_height = $(window).height();
        w_width = $(window).width();
    };

    var random = function(lower, upper) {
        return Math.floor(Math.random() * upper + lower);
    };

    $(window).resize(update_bounds);

    $(function() {
        cloud_swag($('div#identification'));
    });
}).call(this);
