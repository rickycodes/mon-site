var monSite = function() {

	var startTime = Date.now(),

        doc = document,
        win = window,

        red = 0xDE0028,
        blue = 0x004060,
        
        body = doc.body,
        top,
        content,
        three,

        group,

        animSpeed = 1200,
        ease = TWEEN.Easing.Quadratic.Out,
        
        camera,
        scene,
        renderer,

        mouse = {},

        scrolly;

    function getRandNum( min, max ) {
        return Math.floor( Math.random() * ( max - min + 1 ) + min );
    }

    function getRandomHue() {
        var hues = [ red, blue ];
        return hues[ Math.floor( hues.length * Math.random() ) ];
    }

    function getThreeWidht() {
        return win.innerHeight < 956 ? win.innerHeight : 956;
    }

    function getThreeHeight() {
        return Math.floor( top.offsetWidth / 2 ) * 2;
    }

    function getGeom() {
        var size = getRandNum( 60, 120 );
        var geom = [
            new THREE.CubeGeometry( size, size, size ),
            new THREE.SphereGeometry( getRandNum( 8, 20 ), 20, 20 )
        ];
        var index = Math.floor( geom.length * Math.random() );
        return geom[ index ];
    }

    function render() {
        renderer.render( scene, camera );
    }

    function animate() {
        requestAnimationFrame( animate );
        TWEEN.update();
        render();
    }

    function bindMainNav( e ) {

        var links = doc.querySelectorAll( '[data-to]' );
        for ( var i = 0; i < links.length; i++ ) {

            links[ i ].addEventListener( 'click', function( e ) {
                
                e.preventDefault();

                var dest = doc.getElementsByClassName( this.getAttribute( 'data-to' ) )[ 0 ];
                var from = 0; // body.scrollTop || win.scrollTop;
                var to = dest.offsetTop;

                (new TWEEN.Tween({
                    y: from
                })).to({
                    y: to
                })
                .easing( ease )
                .onUpdate( function() {
                    body.scrollTop = win.scrollTop = this.y;
                })
                .start();
            });
        }
    }

    function init() {

        var links = doc.querySelectorAll( 'section a' );
        for ( var i = 0; i < links.length; i++ ) {
            links[ i ].setAttribute( 'target', '_blank' );
        }

        content = doc.getElementsByClassName( 'content' )[ 0 ];
        top = doc.getElementsByClassName( 'top' )[ 0 ];
        content.setAttribute( 'style', 'padding-top:' + getThreeWidht() + 'px' );
        three = doc.getElementsByClassName( 'three' )[ 0 ];
        
        camera = new THREE.PerspectiveCamera( 75, getThreeHeight() / getThreeWidht(), 1, 2000 );
        camera.position.z = 1000;

        scene = new THREE.Scene();

        group = new THREE.Object3D();
        brands = new THREE.Object3D();

        var geometry = new THREE.Geometry();

        for( var i = 0; i < 80; i++ ) {

            var material = new THREE.MeshPhongMaterial( { color : getRandomHue() } );
            var mesh = new THREE.Mesh( getGeom(), material );

            mesh.position.x = Math.random() * 1200 - 600;
            mesh.position.y = Math.random() * 1200 - 600;
            mesh.position.z = Math.random() * 1200 - 600;

            geometry.vertices.push( new THREE.Vector3( mesh.position.x, mesh.position.y, mesh.position.z ) );

            mesh.rotation.x = Math.random() * 2 * Math.PI;
            mesh.rotation.y = Math.random() * 2 * Math.PI;
            mesh.rotation.z = Math.random() * 2 * Math.PI;

            group.add( mesh );
        }

        var lineMaterial = new THREE.LineBasicMaterial( { color : blue } );
        var line = new THREE.Line( geometry, lineMaterial );
        
        var light = new THREE.DirectionalLight( 0xffffff, 1.2 );
        
        light.position.fromArray( [ 0, 0, 1000 ] );
        light.position.multiplyScalar( 1.3 );
        light.castShadow = light.shadowCameraVisible = true;
        
        group.add( line );
        
        scene.add( light );
        scene.add( group );

        renderer = new THREE.WebGLRenderer( { alpha: true } );

        renderer.setSize( getThreeHeight(), getThreeWidht() );
        three.appendChild( renderer.domElement );

        doc.addEventListener( 'mousemove', mousemove, false );
        win.addEventListener( 'scroll', scroll, false );
        win.addEventListener( 'resize', resize, false );

        bindMainNav();
    }

    function mousemove( e ) {
        e.preventDefault();

        mouse.x = e.clientX / window.innerWidth * 2 - 1;
        mouse.y = - ( e.clientY / window.innerHeight ) * 2 + 1;
    }

    function scroll( e ) {

        // scrolly = this.scrollY;

        var scrollY = ( this.y || window.pageYOffset ) - window.pageYOffset;

        this.y = window.pageYOffset;

        var directionY = !scrollY ? 'NONE' : scrollY > 0 ? 'UP' : 'DOWN';

        if( directionY === 'UP' ) {
            camera.position.z += 0.02;
            group.rotation.x += 0.02;
            group.rotation.y += 0.0226;
            group.rotation.z += 0.0176;
            return;
        }

        if( directionY === 'DOWN' ) {
            camera.position.z -= 0.02;
            group.rotation.x -= 0.02;
            group.rotation.y -= 0.0226;
            group.rotation.z -= 0.0176;
            return;
        }
    }

    function resize() {
        content.setAttribute( 'style', 'padding-top:' + getThreeWidht() + 'px' );
        
        camera.aspect = getThreeHeight() / getThreeWidht();
        camera.updateProjectionMatrix();
        
        renderer.setSize( getThreeHeight(), getThreeWidht() );
    }

    init();
    animate();
}();