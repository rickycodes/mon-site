if( !window.requestAnimFrame )
window.requestAnimFrame = ( function( window ) {
	var suffix = "equestAnimationFrame",
	rAF = [ "r", "webkitR", "mozR" ].filter( function( val ) {
		return val + suffix in window;
	})[ 0 ] + suffix;

    return window[ rAF ]  || function( callback ) {
    	window.setTimeout( function() {
    		callback( +new Date() );
    	}, 1000 / 60 );
    };
})( window );