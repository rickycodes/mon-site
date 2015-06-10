require [
  'libs/WebGLCheck'
  'libs/Three'
  'libs/Tween'
  'libs/RequestAnimationFrame'
], ->
  website = do ->
    doc = document
    win = window
    ease = TWEEN.Easing.Exponential.Out
    colors = [0xff01ff, 0x22ffff]
    body = doc.body
    nav = doc.querySelectorAll '[data-to]'
    internal = doc.querySelectorAll '[data-internal]'
    external = doc.querySelectorAll 'section a:not([data-internal]):not([data-to])'
    webGLEnabled = check()
    hash = content = sections = scene = camera = group = geometry = renderer = null
    top = doc.getElementsByClassName('top')[0]
    mouse = {}
    amount = 40
    speed = 900
    rotAmount = .016
    linewidth = 2
    halfx = win.innerWidth / 2
    halfy = win.innerHeight / 2

    setTitle = () ->
      flair = ['ᕕ( ᐛ )ᕗ', '(☞ﾟヮﾟ)☞', '(ง ͠° ͟ʖ ͡°)ง', '¯\\_(ツ)_/¯']
      loc = flair[Math.floor(Math.random()*flair.length)] + ' • ' + win.location.host
      doc.title = loc

    getRandNum = (min, max) ->
      Math.floor Math.random() * (max - min + 1) + min

    getRandomHue = ->
      colors[Math.floor(colors.length * Math.random())]

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

    animate = ->
      requestAnimationFrame animate
      TWEEN.update()
      scroll()
      if webGLEnabled
        for child in group.children
          if child not instanceof THREE.Line
            child.rotation.x += .002
            child.rotation.y += .003
            child.rotation.z += .001
        render()

    internalClick = (e) ->
      e.preventDefault()
      win.location.hash = @getAttribute('data-internal')

    navClick = (e) ->
      e.preventDefault()
      win.location.hash = @getAttribute('data-to')
      win.dispatchEvent(new HashChangeEvent('hashchange'))

    scrollToSectionEl = (el) ->
      dest = doc.getElementsByClassName(el)[0]
      from = 0 or body.scrollTop or doc.documentElement.scrollTop
      to = dest.offsetTop - 180
      new (TWEEN.Tween)(y: from).to(y: to, speed).easing(ease).onUpdate(->
        body.scrollTop = win.scrollTop = doc.documentElement.scrollTop = Math.floor(@y)
      ).start()

    selectSection = (e) ->
      location = win.location.hash
      section = location.replace('#','')
      if section.length and section isnt 'glitch' then scrollToSectionEl(section) else redraw()

    redraw = ->
      three = doc.getElementsByClassName('three')[0]
      canvas = doc.getElementsByTagName('canvas')[0]
      three.removeChild(canvas)
      setup()

    getAspect = ->
      win.innerWidth / win.innerHeight

    moveCamera = ->
      camera.position.x += (mouse.x - camera.position.x) * .08
      camera.position.y += (- mouse.y - camera.position.y) * .08
      camera.position.z += (- mouse.y - camera.position.y) * .08
      camera.lookAt scene.position

    setup = ->
      body.classList.remove 'loading'
      scene = new (THREE.Scene)
      camera = new (THREE.PerspectiveCamera)(75, getAspect(), 1, 2000)
      camera.position.z = 400
      group = new (THREE.Object3D)
      geometry = new (THREE.Geometry)
      hash = win.location.hash.replace('#','')
      renderer = new (THREE.WebGLRenderer)(alpha: true)
      if hash isnt 'glitch'
        body.classList.add 'glitch'
        renderer.setSize win.innerWidth, win.innerHeight + 100
      else
        body.classList.remove 'glitch'
      content = doc.getElementsByClassName('content')[0]
      top = doc.getElementsByClassName('top')[0]
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      three = doc.getElementsByClassName('three')[0]
      sections = doc.getElementsByTagName('section')
      section.setAttribute 'style', 'margin-bottom: 1000px !important;' for section in sections
      for num in [1..amount]
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
      lineMaterial = new (THREE.LineBasicMaterial)(color: colors[1], linewidth: linewidth, fog: true)
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
      three.classList.add 'visible'
      three.appendChild renderer.domElement
      win.addEventListener 'resize', resize, false
      selectSection() if win.location.hash.length and hash isnt 'glitch'

    mousemove = (e) ->
      e.preventDefault()
      mouse.clientY = e.clientY
      mouse.x = e.clientX - halfx
      mouse.y = e.clientY - halfy
      moveCamera() if webGLEnabled

    scroll = () ->
      scrollY = (@y or win.pageYOffset) - win.pageYOffset
      scrollTop = body.scrollTop or win.scrollTop or doc.documentElement.scrollTop
      @y = win.pageYOffset
      directionY = if !scrollY then 'NONE' else if scrollY > 0 then 'UP' else 'DOWN'
      if directionY is 'UP'
        top.classList.remove 'hide'
        if webGLEnabled
          group.rotation.x += rotAmount
      if directionY is 'DOWN'
        top.classList.add 'hide' if scrollTop > 200 and mouse.clientY > 140
        if webGLEnabled
          group.rotation.x -= rotAmount

    resize = ->
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      camera.aspect = getAspect()
      camera.updateProjectionMatrix()
      renderer.setSize win.innerWidth, win.innerHeight + 100 if hash isnt 'glitch'

    do ->
      if webGLEnabled
        setup()
        body.classList.add 'animate'
        internal_item.addEventListener 'click', internalClick for internal_item in internal
      else
        content = doc.getElementsByClassName('content')[0]
        content.setAttribute 'style', 'padding-top:' + 220 + 'px; visibility: visible !important;'
        body.classList.remove 'loading'
      setTitle()
      animate()
      win.addEventListener 'hashchange', selectSection, false
      doc.addEventListener 'mousemove', mousemove, false
      nav_item.addEventListener 'click', navClick for nav_item in nav
      external_item.setAttribute 'target', '_blank' for external_item in external
