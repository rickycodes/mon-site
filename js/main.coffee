require [
  'WebGLCheck'
  'Three'
  'Tween'
  'RequestAnimationFrame'
], ->
  monSite = do ->
    startTime = Date.now()
    doc = document
    win = window
    purple = 0xff01ff
    blue = 0x22ffff
    body = doc.body
    content = ''
    three = ''
    webGLEnabled = ''
    group = ''
    animSpeed = 1200
    ease = TWEEN.Easing.Quadratic.Out
    camera = ''
    scene = ''
    renderer = ''
    # loading = doc.getElementsByClassName('loading')[0]
    top = doc.getElementsByClassName('top')[0]
    mouse = {}
    scrolly = ''

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
        len = group.children.length
        i = 0
        while i < len
          if i != len - 1
            group.children[i].rotation.x += 0.002
            group.children[i].rotation.y += 0.003
            group.children[i].rotation.z += 0.001
          i++
        render()
      return

    bindExternalLinks = ->
      links = doc.querySelectorAll('section a')
      i = 0
      while i < links.length
        links[i].setAttribute 'target', '_blank'
        i++
      return

    bindMainNav = (e) ->
      links = doc.querySelectorAll('[data-to]')
      i = 0
      while i < links.length
        links[i].addEventListener 'click', (e) ->
          e.preventDefault()
          dest = doc.getElementsByClassName(@getAttribute('data-to'))[0]
          from = 0 or document.body.scrollTop or document.documentElement.scrollTop
          to = dest.offsetTop - 180
          new (TWEEN.Tween)(y: from).to(y: to).easing(ease).onUpdate(->
            body.scrollTop = win.scrollTop = doc.documentElement.scrollTop = Math.floor(@y)
            return
          ).start()
          return
        i++
      return

    init = ->
      content = doc.getElementsByClassName('content')[0]
      top = doc.getElementsByClassName('top')[0]
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      three = doc.getElementsByClassName('three')[0]
      sections = doc.getElementsByTagName('section')
      i = 0
      while i < sections.length
        sections[i].setAttribute 'style', 'margin-bottom: 1000px !important;'
        i++
      camera = new (THREE.PerspectiveCamera)(75, win.innerWidth / win.innerHeight, 1, 2000)
      camera.position.z = 1000
      scene = new (THREE.Scene)
      group = new (THREE.Object3D)
      geometry = new (THREE.Geometry)
      i = 0
      while i < 80
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
        i++
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
      renderer = new (THREE.WebGLRenderer)(alpha: true)
      renderer.setSize win.innerWidth, win.innerHeight
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
      scrollTop = document.body.scrollTop or document.documentElement.scrollTop
      @y = window.pageYOffset
      directionY = if !scrollY then 'NONE' else if scrollY > 0 then 'UP' else 'DOWN'
      if directionY == 'UP'
        top.setAttribute 'class', 'top'
        camera.position.z += 0.8
        group.rotation.x += 0.02
        group.rotation.y += 0.0226
        group.rotation.z += 0.0176
        return
      if directionY == 'DOWN'
        top.setAttribute 'class', 'top hide' if scrollTop > 200 and mouse.clientY > 140
        camera.position.z -= 0.8
        group.rotation.x -= 0.08
        group.rotation.y -= 0.0226
        group.rotation.z -= 0.0176
        return
      return

    resize = ->
      content.setAttribute 'style', 'padding-top:' + win.innerHeight + 'px; visibility: visible !important;'
      camera.aspect = window.innerWidth / window.innerHeight
      camera.updateProjectionMatrix()
      renderer.setSize window.innerWidth, window.innerHeight
      return

    do ->
      webGLEnabled = check()
      if webGLEnabled
        init()
      else
        content = doc.getElementsByClassName('content')[0]
        content.setAttribute 'style', 'padding-top:' + 220 + 'px; visibility: visible !important;'
        # loading.parentElement.removeChild loading
      animate()
      bindMainNav()
      bindExternalLinks()
      return
    return
  return
