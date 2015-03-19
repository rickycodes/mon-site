require [
  'libs/WebGLCheck'
  'libs/Three'
  'libs/Tween'
  'libs/RequestAnimationFrame'
], ->
  monSite = do ->
    doc = document
    win = window
    purple = 0xff01ff
    blue = 0x22ffff
    body = doc.body
    webGLEnabled = check()
    scene = new (THREE.Scene)
    camera = new (THREE.PerspectiveCamera)(75, win.innerWidth / win.innerHeight, 1, 2000)
    camera.position.z = 900
    group = new (THREE.Object3D)
    geometry = new (THREE.Geometry)
    animSpeed = 1200
    ease = TWEEN.Easing.Quadratic.Out
    renderer = new (THREE.WebGLRenderer)(alpha: true)
    renderer.setSize win.innerWidth, win.innerHeight
    # loading = doc.getElementsByClassName('loading')[0]
    top = doc.getElementsByClassName('top')[0]
    mouse = {}

    setTitle = () ->
      flair = ['ᕕ( ᐛ )ᕗ', '(☞ﾟヮﾟ)☞', '(ง ͠° ͟ʖ ͡°)ง', '¯\\_(ツ)_/¯']
      loc = flair[Math.floor(Math.random()*flair.length)] + ' • ' + window.location.host
      doc.title = loc

    getRandNum = (min, max) ->
      Math.floor Math.random() * (max - min + 1) + min

    getRandomHue = ->
      hues = [
        purple
        blue
      ]
      hues[Math.floor(hues.length * Math.random())]

    getGeom = ->
      size = getRandNum(60, 120)
      geom = [
        new (THREE.CubeGeometry)(size, size, size)
        new (THREE.SphereGeometry)(getRandNum(8, 20), 20, 20)
      ]
      index = Math.floor(geom.length * Math.random())
      geom[index]

    render = ->
      renderer.render scene, camera
      return

    animate = ->
      requestAnimationFrame animate
      TWEEN.update()
      if webGLEnabled
        for child in group.children
          if child not instanceof THREE.Line
            child.rotation.x += 0.002
            child.rotation.y += 0.003
            child.rotation.z += 0.001
        render()
      return

    bindExternalLinks = ->
      links = doc.querySelectorAll('section a')
      link.setAttribute 'target', '_blank' for link in links
      return

    navClick = (e) ->
      e.preventDefault()
      dest = doc.getElementsByClassName(@getAttribute('data-to'))[0]
      from = 0 or body.scrollTop or doc.documentElement.scrollTop
      to = dest.offsetTop - 180
      new (TWEEN.Tween)(y: from).to(y: to).easing(ease).onUpdate(->
        body.scrollTop = win.scrollTop = doc.documentElement.scrollTop = Math.floor(@y)
        return
      ).start()
      return

    bindMainNav = ->
      links = doc.querySelectorAll('[data-to]')
      link.addEventListener 'click', navClick for link in links
      return

    setup = ->
      content = doc.getElementsByClassName('content')[0]
      top = doc.getElementsByClassName('top')[0]
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      three = doc.getElementsByClassName('three')[0]
      sections = doc.getElementsByTagName('section')
      section.setAttribute 'style', 'margin-bottom: 1000px !important;' for section in sections
      for num in [1..30]
        material = new (THREE.MeshPhongMaterial)(color: getRandomHue())
        mesh = new (THREE.Mesh)(getGeom(), material)
        mesh.position.x = Math.random() * 1200 - 600
        mesh.position.y = Math.random() * 1200 - 600
        mesh.position.z = Math.random() * 1200 - 600
        geometry.vertices.push new (THREE.Vector3)(mesh.position.x, mesh.position.y, mesh.position.z)
        mesh.rotation.x = Math.random() * 2 * Math.PI
        mesh.rotation.y = Math.random() * 2 * Math.PI
        mesh.rotation.z = Math.random() * 2 * Math.PI
        group.add mesh
      lineMaterial = new (THREE.LineBasicMaterial)(color: blue)
      line = new (THREE.Line)(geometry, lineMaterial)
      light = new (THREE.DirectionalLight)(0xffffff, 1.2)
      light.position.fromArray [
        0
        0
        1000
      ]
      light.position.multiplyScalar 1.3
      light.castShadow = light.shadowCameraVisible = true
      group.add line
      scene.add light
      scene.add group
      three.setAttribute 'class', 'three visible'
      three.appendChild renderer.domElement
      # loading.parentElement.removeChild loading
      doc.addEventListener 'mousemove', mousemove, false
      win.addEventListener 'scroll', scroll, false
      win.addEventListener 'resize', resize, false
      return

    mousemove = (e) ->
      e.preventDefault()
      mouse.clientY = e.clientY
      mouse.x = e.clientX / win.innerWidth * 2 - 1
      mouse.y = -(e.clientY / win.innerHeight) * 2 + 1
      return

    scroll = (e) ->
      scrollY = (@y or window.pageYOffset) - window.pageYOffset
      scrollTop = body.scrollTop or win.scrollTop or doc.documentElement.scrollTop
      @y = window.pageYOffset
      directionY = if !scrollY then 'NONE' else if scrollY > 0 then 'UP' else 'DOWN'
      if directionY is 'UP'
        top.setAttribute 'class', 'top show'
        group.rotation.x += 0.08
        group.rotation.y += 0.024
        group.rotation.z += 0.018
        return
      if directionY is 'DOWN'
        top.setAttribute 'class', 'top hide' if scrollTop > 200 and mouse.clientY > 140
        group.rotation.x -= 0.08
        group.rotation.y -= 0.024
        group.rotation.z -= 0.018
        return
      return

    resize = ->
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      camera.aspect = window.innerWidth / window.innerHeight
      camera.updateProjectionMatrix()
      renderer.setSize window.innerWidth, window.innerHeight
      return

    do ->
      if webGLEnabled
        setup()
      else
        content = doc.getElementsByClassName('content')[0]
        content.setAttribute 'style', 'padding-top:' + 220 + 'px; visibility: visible !important;'
        # loading.parentElement.removeChild loading
      setTitle()
      animate()
      bindMainNav()
      bindExternalLinks()
      return
    return
  return
