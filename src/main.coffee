queue = []            # queue of frames

# load handler invoked on change event
load = -> 
  queue = []          # queue of frames
  window.paused = false
  startingTime.innerText = ''
  stoppingTime.innerText = ''
  between.style.visibility  = 'hidden'
  download.style.visibility = 'hidden'
  currentRange.start = null
  currentRange.stop  = null
  File = @files[0]
  return if not File.name.match '\.ldj$'
  file.textContent = File.name
  reader = new FileReader()
  reader.onload = (file) -> 
    controls.style.visibility = 'visible'
    slider.style.visibility = 'visible'
    queue.push(JSON.parse row) for row in @result.split('\n') \
                                          when row.match /timestamp/
    render queue
    slider.max = queue.length - 1
    ''
  reader.readAsText File

togglePlayback = (event) ->
  if @paused
    @paused = false
    render queue
  else
    @paused = true

slide = (count) ->
  slider.value = (slider.valueAsNumber + count).toString()
  setFrame()

key =
  command: 91
  spacebar: 32
  leftArrow: 37
  rightArrow: 39
  upArrow: 38
  downArrow: 40

catchKeyControls = (event) ->
  switch event.keyCode
    when key.spacebar then togglePlayback()
    when key.leftArrow then slide -10
    when key.rightArrow then slide 10
    when key.upArrow then slide -1
    when key.downArrow then slide 1

# callback for the slider control 
setFrame = -> 
  window.currentFrame = +slider.value
  frame = queue[window.currentFrame]
  draw frame
  secs = (frame.timestamp - startTime) / 1000000        # in seconds
  sliderOutput.value = secs.toFixed(2)
  @blur()                                               # remove focus

# range of frames for playback and export
setRange = ->
  if not startingTime.innerText.toString()
    startingTime.innerText = sliderOutput.value
    currentRange.start = currentFrame
  else
    stoppingTime.innerText = sliderOutput.value
    currentRange.stop = currentFrame
  if stoppingTime.innerText.toString()
    download.style.visibility = 'visible'
    between.style.visibility = 'visible'

# export frame data within specified range as a csv file
exportRange = ->
  [start, stop] = [currentRange.start, currentRange.stop]
  rows = []
  if start? and stop?
    rows.push 'FRAME_ID,TIME,Y_POS,Y_VEL'   # column header
    for i in [start..stop]                  # iterate over frames in queue
      frame = queue[i]
      h = frame.hands[0]                    # data from first hand
      secs = (frame.timestamp - startTime) / 1000000    # in seconds
      #      FRAME_ID, TIME, Y_POS   ......   , Y_VEL
      row = [frame.id, secs, h.palmPosition[1], h.palmVelocity[1]]
      rows.push row.join(',')   # join values with comma
  csv = rows.join('\n')         # join rows with newlines
  download.href = 'data:attachment/csv,' + encodeURI(csv)
  download.download = file.innerText.replace('.ldj', '.csv')

reset = (event) -> 
  @innerText = ""
  between.style.visibility = 'hidden'
  download.style.visibility = 'hidden'

palm.addEventListener('click', setRange)
slider.addEventListener('input', setFrame)
document.addEventListener('keydown', catchKeyControls)  # enable key controls
download.addEventListener('click', exportRange)

startingTime.addEventListener('click', reset)
stoppingTime.addEventListener('click', reset)

# click and choose a file to load
chooser.addEventListener('change', load)    
file.addEventListener('click', -> chooser.click())
