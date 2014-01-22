@currentFrame = 0     # current frame number
@currentRange =       # current range of selected frames
  start: null
  stop:  null
@paused = false       # pause status


# Utility methods ...

R2D = 180 / Math.PI

pitch = (hand) -> 
  Math.round(R2D * Math.atan2(hand.direction[1], -hand.direction[2]) - 90)

yaw = (hand) -> 
  Math.round(R2D * Math.atan2(hand.direction[0], -hand.direction[2]))

roll = (hand) ->
  Math.round(-R2D * Math.atan2(hand.palmNormal[0], -hand.palmNormal[1]))


# Rendering logic ...

parse = (pos) ->
  [x, y, z] = (Math.round(x) for x in pos)
  [x, -y, 350/(350 + z)]

points = (window[i] for i in ['A', 'B', 'C', 'D', 'E'])

@draw = draw = (frame) ->

  if frame?.hands?.length
    palm.style.opacity = .75
    hand = frame.hands[0]
    [x, y, z] = parse hand.palmPosition
    transform = """
      translate(#{x}px, #{y}px) 
      scale(#{z})
      rotateX(#{pitch(hand)}deg)
      rotateZ(#{roll(hand)}deg)
    """
    palm.style.webkitTransform = transform

  else
    palm.style.opacity = 0

  if frame?.pointables?.length
    last = null
    for i, point of frame.pointables
      return if i > 4
      [x, y, z] = parse point.tipPosition
      transform = "translate(#{x}px, #{y}px) scale(#{z})"
      opacity = if point.handId is -1 then 0 else .75
      points[i].style.webkitTransform = transform
      points[i].style.opacity = opacity
      last = parseInt(i)

    if last < 4
      x = last + 1
      points[i.toString()].style.opacity = 0 for i in [x..4]

  else
      points[x.toString()].style.opacity = 0 for x in [0..4]

  ''

@render = (queue) ->
  last = queue.length - 1
  stop = queue[last].timestamp
  @startTime = start = queue[0].timestamp
  duration = (stop - start) / 1000
  step = duration / queue.length
  run = ->
    return if @paused
    frame = @currentFrame + 1
    requestAnimationFrame -> draw queue[frame]
    time = (queue[frame].timestamp - start) / 1000000    # in seconds
    sliderOutput.value = time.toFixed(2)
    slider.value = frame
    if frame is last
      @currentFrame = 0 
      @paused = true
      return
    @currentFrame = frame
    setTimeout(run, step)
  run()
