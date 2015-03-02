var check = function() {
  for ( var a = [ 'webgl', 'experimental-webgl', 'moz-webgl', 'webkit-3d' ], c = [], b = false, d = false, e = false, f = 0; 4 > f; f++ ) {
    d = false;
    try {
      d = document.createElement( 'canvas' ).getContext( a[ f ], {
        stencil: true
      });
      if ( d ) b || ( b = d ), c.push( a[ f ] );
    } catch ( g ) {}
  }

  if ( !b && eval( '/*@cc_on!@*/false' ) ) { // this is ___SO___ gross!
    var object = doc.createElement( 'object' );
      object.setAttribute( 'type', 'application/x-webgl' );
      object.setAttribute( 'id', 'glCanvas' );
    try {
      b = doc.getElementById( 'glCanvas' ).getContext( 'webgl' ), c.push( 'webgl' ), e = true;
    } catch ( h ) {}
  }

  return b ? {
    name: c,
    gl: b,
    isModule: e
  } : false;
}
