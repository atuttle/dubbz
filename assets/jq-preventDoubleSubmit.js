jQuery.fn.preventDoubleSubmit=function(duration) {
    duration = duration || 1984;
    jQuery( this ).submit( function() {
        if ( jQuery(this).hasClass("locked") ) return false;
        jQuery(this).addClass("locked");
        that = this;
        setTimeout(function() {
            jQuery(that).removeClass("locked");
        }
        , duration );
    });
};