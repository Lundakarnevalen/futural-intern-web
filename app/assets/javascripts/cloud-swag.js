// If not JS, just keep the static cloud arrangement.

(function() {
    // Swagness parameters.
    var N_CLOUDS = 8,
        CLOUD_SIZE = 1.0,
        CLOUD_SPEED = 1.0, // must be <= 1.0
        TICK_SLEEP = 200;  // mseconds between ticks
        FADE_TIME = 1000; //milliseconds until removal.

    // System state.
    var w_height,
        w_width,
        clouds = [],
        cont = $('<div class="cloud-container">');

    // Add swag to given element.
    var cloud_swag = function(div) {
    	if($(div).length > 0) { //made some mess at "home" if not checked.
            update_bounds();
            div.removeClass('clouds');
            $('body').addClass('cloud-bg');
            div.append(cont);
            for(var i = 0; i < N_CLOUDS; i++) {
                gen_cloud(cont, i);
            }
            clouds = $('.one-cloud');
            setInterval(cloud_tick, TICK_SLEEP);
        }
    };

    // Tick the system of clouds.
    var cloud_tick = function() {
        clouds.offset(function(i, coords) {
            var factor = $(this).hasClass('cloud-flipped') ? 1 : -1;
            return { left: coords.left + factor * CLOUD_SPEED };
        });
        clouds.each(function(i) {
            var jthis = $(this),
                hpos = jthis.offset().left,
                vpos = jthis.offset()["top"];
            if(hpos >= w_width - jthis.width() - 4 || hpos < 0 ||
               vpos >= w_height - jthis.height() - 4) {
                jthis.fadeOut(FADE_TIME, function() {
                    jthis.remove();
                });
                jthis.addClass('dead-cloud');
                setTimeout(function() {
                    gen_cloud(cont, i);
                }, FADE_TIME);
            }
        });
        clouds = $('.one-cloud:not(.dead-cloud)');
    };

    // Generate a new cloud 
    var gen_cloud = function(div, voffset) {
        var cloud = $('<div class="one-cloud">'),
            factor = Math.random() / 2 + 0.5,
            width = 304 * CLOUD_SIZE * factor,
            height = 144 * CLOUD_SIZE * factor;
        cloud.css({ height: 144 * CLOUD_SIZE * factor,
                    width: 304 * CLOUD_SIZE * factor,
                    "top": voffset * ((w_height - height) / N_CLOUDS),
                    left: random(0, w_width - 304 * factor * CLOUD_SIZE),
        });
        cloud.data('offset', voffset);
        cloud.fadeIn(FADE_TIME);
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

    // Generate random int >= lower, < upper
    var random = function(lower, upper) {
        return Math.floor(Math.random() * upper + lower);
    };

    $(window).resize(update_bounds);

    $(function() {
        cloud_swag($('div#identification'));
    });
}).call(this);
