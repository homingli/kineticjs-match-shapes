
  # DONE!! //TODO: shapes should not be out of bound (edge of canvas) 
  # DONE!! //TODO: check when all shapes have matched
  # TODO: location of frames cannot conflict
  # TODO: reset game

(->
  ###
  start= (new Date()).getTime()
  setInterval (->
    writeMessage(timerLayer,'Timer: '+(Math.round(((new Date()).getTime()-start)/100)/10)+'s')
  ), 100
  ###
 
  color={'circle':'red','box':"#00D2FF",'triangle':'yellow'}

  writeMessage = (messageLayer, message, c) ->
    c = "black" if (typeof c == 'undefined')
    ###
    context = messageLayer.getContext()
    messageLayer.clear()
    context.font = "18pt Calibri"
    context.fillStyle = c
    context.fillText message, 10, 25
    ###
    msg.setText message
    msg.setTextFill c
    messageLayer.draw()

  makeframe = (shape) ->
    frame = shape.clone()
    frame.setFill "#fff"
    frame.setDraggable false
    debug_counter = 0
    flag = true
    while flag
      new_x = Math.random() * stage.getWidth()
      new_y = Math.random() * stage.getHeight()
      if frame.toObject().shapeType is "Rect"
        w = frame.getWidth()
        h = frame.getHeight()
      else
        w = h = frame.getRadius()
      # check upperbound
      over_upper = ((new_x + w > stage.getWidth()) or (new_y + h > stage.getHeight()))

      # check lowerbound
      under_lower = ((new_x - w < 0) or (new_y - h < 0))
      flag = (over_upper or under_lower)
      console.log ++debug_counter
    # endwhile

    frame.setPosition new_x, new_y
    frame


  # check matching position
  isposmatch = (shape, frame) ->
    s_x = Math.round(shape.getX())
    s_y = Math.round(shape.getY())
    f_x = Math.round(frame.getX())
    f_y = Math.round(frame.getY())
    (Math.abs(s_x - f_x) <= tolerance) and (Math.abs(s_y - f_y) <= tolerance)

  # function to check if shape is correct
  test_and_complete = (shape, frame, msg, cb) ->
    if isposmatch(shape, frame)
      writeMessage messageLayer, msg, shape.getFill()
      shape.setPosition frame.getAbsolutePosition().x, frame.getAbsolutePosition().y
      shape.setDraggable false
      shapeLayer.draw()
      frame.hide()
      
      #console.log(shape.toJSON());
      #console.log(shape.toObject().shapeType);
      config = {}
      config.scale =
        x: 2
        y: 2

      config.opacity = 0
      config.duration = 0.8
      config.easing = "ease-out"
      if shape.toObject().shapeType is "Rect"
        config.x = shape.getAbsolutePosition().x - (shape.getWidth() / 2)
        config.y = shape.getAbsolutePosition().y - (shape.getHeight() / 2)
      shape.transitionTo config
      setTimeout (->
        if (not circleFrame.isVisible() and not boxFrame.isVisible() and not triangleFrame.isVisible())
          writeMessage messageLayer, 'Congrats! All Done! Win!'
          # blink effect, omg!!!!
          setInterval (->
            if (messageLayer.isVisible())
              messageLayer.hide()
            else
              messageLayer.show()
          ), 500
      ), 1000

      cb()  if cb

  # find window width and height
  winW = 630
  winH = 460
  if document.body and document.body.offsetWidth
    winW = document.body.offsetWidth
    winH = document.body.offsetHeight
  if document.compatMode is "CSS1Compat" and document.documentElement and document.documentElement.offsetWidth
    winW = document.documentElement.offsetWidth
    winH = document.documentElement.offsetHeight
  if window.innerWidth and window.innerHeight
    winW = window.innerWidth
    winH = window.innerHeight
  stage = new Kinetic.Stage(
    container: "container"
    width: winW
    height: winH
  )
  shapeLayer = new Kinetic.Layer()
  messageLayer = new Kinetic.Layer()
  #timerLayer = new Kinetic.Layer()
  tolerance = 50
  
  circle = new Kinetic.Circle(
    x: Math.random() * stage.getWidth()
    y: Math.random() * stage.getHeight()
    radius: Math.max(80, Math.random() * 100)
    fill: color.circle
    stroke: "black"
    strokeWidth: 2
    draggable: true
  )
  box_w=box_h=Math.max(150, Math.random() * 180)
  box = new Kinetic.Rect(
    x: Math.random() * stage.getWidth()
    y: Math.random() * stage.getHeight()
    width: box_w
    height: box_h
    fill: color.box
    stroke: "black"
    strokeWidth: 2
    draggable: true
  )
  triangle = new Kinetic.RegularPolygon(
    x: Math.random() * stage.getWidth()
    y: Math.random() * stage.getHeight()
    sides: 3
    radius: Math.max(100, Math.random() * 130)
    stroke: "black"
    fill: color.triangle
    strokeWidth: 2
    draggable: true
  )

  boxFrame = makeframe(box)
  circleFrame = makeframe(circle)
  triangleFrame = makeframe(triangle)
  
  # write out drag and drop events
  #circle.on "dragstart", ->
  #  writeMessage messageLayer, "dragstart"

  circle.on "dragend", ->
    test_and_complete this, circleFrame, "CIRCLE MATCHED!"

  box.on "dragend", ->
    test_and_complete this, boxFrame, "SQUARE MATCHED!"

  triangle.on "dragend", ->
    test_and_complete this, triangleFrame, "TRIANGLE MATCHED!"
  
  msg = new Kinetic.Text(
    x: 10,
    y: 10,
    text: '',
    fontSize: 30,
    fontFamily: 'Calibri',
    textFill: 'green'
  )

  shapeLayer.add circleFrame
  shapeLayer.add triangleFrame
  shapeLayer.add boxFrame
  shapeLayer.add circle
  shapeLayer.add triangle
  shapeLayer.add box
  messageLayer.add msg

  stage.add shapeLayer
  stage.add messageLayer
  #stage.add timerLayer


)()
