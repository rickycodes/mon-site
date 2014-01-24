var monSite = function () {

	var startTime = Date.now(),
        
        current,
        sections,

        doc = document,
        win = window,
        
        body = doc.body,
        top,
        content,
        three,

        animating = true,
        throttle = false,

        group,
        brands,

        animSpeed = 600,
        ease = TWEEN.Easing.Quadratic.Out,
        
        camera,
        scene,
        renderer,

        mouse = {},

        html,

        scrolly;

    function getRandomHue() {
        var hues = [ 0xDE0028, 0x004060 ];
        return hues[ Math.floor( hues.length * Math.random() ) ];
    }

    function getThreeWidht() {
        return win.innerHeight < 956 ? win.innerHeight : 956;
    }

    function getThreeHeight() {
        return Math.floor( top.offsetWidth / 2 ) * 2;
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

        var links = doc.querySelectorAll("[data-to]");
        for ( var i = 0; i < links.length; i++ ) {

            links[ i ].addEventListener( 'click', function( e ) {
                
                e.preventDefault();

                var dest = doc.getElementsByClassName( this.getAttribute( 'data-to' ) )[ 0 ];
                var from = body.scrollTop || win.scrollTop;
                var to = dest.offsetTop;

                (new TWEEN.Tween({
                    y: from
                })).to({
                    y: to
                })
                .easing( ease )
                .onUpdate( function () {
                    body.scrollTop = win.scrollTop = this.y;
                })
                .start();
            });
        }
    }

    function init() {

        var links = doc.querySelectorAll( "section a" );
        for ( var i = 0; i < links.length; i++ ) {
            links[ i ].setAttribute( "target", "_blank" );
        }

        sections = doc.querySelectorAll( "section" );
        content = doc.getElementsByClassName( "content" )[ 0 ];
        top = doc.getElementsByClassName( "top" )[ 0 ];
        content.setAttribute( "style", "padding-top:" + getThreeWidht() + "px" );
        html = doc.getElementsByTagName( "html" )[ 0 ];
        three = doc.getElementsByClassName( "three" )[ 0 ];
        
        camera = new THREE.PerspectiveCamera( 75, getThreeHeight() / getThreeWidht(), 1, 2000 );
        camera.position.z = 1000;

        scene = new THREE.Scene();

        group = new THREE.Object3D();
        brands = new THREE.Object3D();

        var geometry = new THREE.CubeGeometry( 100, 100, 100 );

        for( var i = 0; i < 20; i++ ) {

            var material = new THREE.MeshPhongMaterial( { color : getRandomHue() } );
            var mesh = new THREE.Mesh( geometry, material );

            mesh.position.x = Math.random() * 2000 - 1000;
            mesh.position.y = Math.random() * 2000 - 1000;
            mesh.position.z = Math.random() * 2000 - 1000;

            mesh.rotation.x = Math.random() * 2 * Math.PI;
            mesh.rotation.y = Math.random() * 2 * Math.PI;

            mesh.matrixAutoUpdate = false;
            mesh.updateMatrix();

            group.add( mesh );
        }
        
        var light = new THREE.DirectionalLight( 0xffffff, 1.2 );
        
        light.position.fromArray( [ 0, 0, 1000 ] );
        light.position.multiplyScalar( 1.3 );
        light.castShadow = light.shadowCameraVisible = true;
        
        scene.add( light );
        scene.add( group );
        scene.add( brands);

        renderer = new THREE.WebGLRenderer( { alpha: true } );

        renderer.setSize( getThreeHeight(), getThreeWidht() );
        three.appendChild( renderer.domElement );

        doc.addEventListener( "mousemove", mousemove, false );
        win.addEventListener( "scroll", scroll, false );
        win.addEventListener( "resize", resize, false );

        bindMainNav();
    }

    function mousemove( e ) {
        e.preventDefault();
        mouse.x = e.clientX / window.innerWidth * 2 - 1;
        mouse.y = - ( e.clientY / window.innerHeight ) * 2 + 1;
    }

    function scroll( e ) {

        // scrolly = this.scrollY;

        camera.position.z += 0.02;

        group.rotation.x += 0.02;
        group.rotation.y += 0.0226;
        group.rotation.z += 0.0176;
    }

    function resize() {
        content.setAttribute( "style", "padding-top:" + getThreeWidht() + "px" );
        
        camera.aspect = getThreeHeight() / getThreeWidht();
        camera.updateProjectionMatrix();
        
        renderer.setSize( getThreeHeight(), getThreeWidht() );
    }

    (function() {
        init();
        animate();
    })();
}();