if !window.requestAnimFrame
  window.requestAnimFrame = do (window) ->
    suffix = 'equestAnimationFrame'
    rAF = [
      'r'
      'webkitR'
      'mozR'
    ].filter((val) ->
      val + suffix in window
    )[0] + suffix
    window[rAF] or (callback) ->
      window.setTimeout (->
        callback +new Date
        return
      ), 1000 / 60
      return
