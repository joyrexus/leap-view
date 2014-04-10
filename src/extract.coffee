square = (x) -> Math.pow(x, 2)

# Return euclidean-distance between points `a` and `b`.
# Both args should be 2D or 3D vectors.
distance = (a, b) ->    
  sum = 0
  sum += square(a[i] - b[i]) for i in [0...a.length]
  Math.sqrt(sum)
  
@extract =
  # Extract finger-distance info from frame data within specified range.
  # Only consider frames where two fingers are detected.
  #
  # For each frame, extract:
  #   * FRAME - frame ID
  #   * TIME - timestamp in seconds
  #   * DISTANCE - euclidean distance between fingers in millimeters
  #   * STABILIZED - stablized distance between fingers in millimeters
  #
  # Returns CSV-string of extracted frame data in temporal sequence.
  #
  distance: (range) ->
    csv = ['FRAME,TIME,DISTANCE,STABILIZED']    # column header
    for frame in range                          # iter over frames in range
      if frame.pointables.length is 2           # only 2-finger situations
        [a, b] = frame.pointables[..]
        dist = distance(a.tipPosition, b.tipPosition)
        dstb = distance(a.stabilizedTipPosition, b.stabilizedTipPosition)
        secs = (frame.timestamp - startTime) / 1000000    # in seconds
        #      FRAME_ID, TIME, FINGER DISTANCE, STABILIZED DIST
        row = [frame.id, secs, dist, dstb]
        csv.push row.join(',')   # join values with comma
    csv.join('\n')               # join rows with newlines

  # Extract vertical positon/velocity from frame data within 
  # specified range.
  #
  # For each frame, extract:
  #   * FRAME - frame ID
  #   * TIME - timestamp in seconds
  #   * Y_POS - vertical position of hand
  #   * Y_VEL - vertical velocity of hand
  #
  # Returns CSV-string of extracted frame data in temporal sequence.
  #
  velocity: (range) ->
    csv = ['FRAME_ID,TIME,Y_POS,Y_VEL']     # column header
    for frame in range                      # iterate over frames in range
      hand = frame.hands[0]                 # data from first hand
      secs = (frame.timestamp - startTime) / 1000000    # in seconds
      #      FRAME_ID, TIME, Y_POS   ......   , Y_VEL
      row = [frame.id, secs, hand.palmPosition[1], hand.palmVelocity[1]]
      csv.push row.join(',')   # join values with comma
    csv.join('\n')               # join rows with newlines

