
  # DONE!! #TODO: shapes should not be out of bound (edge of canvas) 
  # DONE!! #TODO: check when all shapes have matched
  # DONE!! #TODO: switched from regenerating frame to moving frame within stage
  # DONE!! #TODO: size based on the canvas size
  # DONE!! #TODO: on drag item, become raised to top
  # TODO: when 'picked' up, add effects like shadow, etc.
  # SEMI-DONE!! just a reload button atm #TODO: reset game
  # TODO: location of frames cannot conflict

(->


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

  ###
  start= (new Date()).getTime()
  setInterval (->
    writeMessage(timerLayer,'Timer: '+(Math.round(((new Date()).getTime()-start)/100)/10)+'s')
  ), 100
  ###

  shapes={
    'circle': {
      'color': 'red'
      'x': Math.random() * stage.getWidth()
      'y': Math.random() * stage.getHeight()
    },
    'box': {
      'color': "#00D2FF"
      'x': Math.random() * stage.getWidth()
      'y': Math.random() * stage.getHeight()
    },
    'triangle': {
      'color': "yellow"
      'x': Math.random() * stage.getWidth()
      'y': Math.random() * stage.getHeight()
    }
  }

  writeMessage = (messageLayer, message, c) ->
    c = "black" if (typeof c == 'undefined')
    ###
    context = messageLayer.getContext()
    messageLayer.clear()
    context.font = "18pt Calibri"
    context.fillStyle = c
    context.fillText message, 10, 25
    ###
    msg.setTextFill c
    msg.setTextStroke 'black'
    msg.setTextStrokeWidth 1
    msg.setText message
    messageLayer.draw()

  makeframe = (shape) ->
    frame = shape.clone()
    frame.setFill "#000"
    frame.setDraggable false
    new_x = Math.random() * stage.getWidth()
    new_y = Math.random() * stage.getHeight()
    if frame.toObject().shapeType is "Rect"
      w = frame.getWidth()
      h = frame.getHeight()
    else
      w = h = frame.getRadius()

    # check upperbound
    new_x = new_x - w if (new_x + w > stage.getWidth())
    new_y = new_y - h if (new_y + h > stage.getHeight())

    # check lowerbound
    new_x = new_x + w if (new_x - w < 0)
    new_y = new_y + h if (new_y - h < 0)

    ###
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
    ###
   
    console.log frame.toObject().shapeType,new_x,new_y
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

      new Audio("applause.mp3").play()
      writeMessage messageLayer, msg, shape.getFill()
      shape.setPosition frame.getAbsolutePosition().x, frame.getAbsolutePosition().y
      #shape.setDraggable false
      shapeLayer.draw()
      
      #console.log(shape.toJSON());
      #console.log(shape.toObject().shapeType);
      config = {}
      config.scale =
        x: 0
        y: 0

      config.opacity = 0
      config.duration = 0.5
      config.easing = "ease-out"
      #config.callback = ->
      frame.hide()
      if shape.toObject().shapeType is "Rect"
        config.x = shape.getAbsolutePosition().x + (shape.getWidth() / 2)
        config.y = shape.getAbsolutePosition().y + (shape.getHeight() / 2)
      shape.transitionTo config

      setTimeout (->
        if (not circleFrame.isVisible() and not boxFrame.isVisible() and not triangleFrame.isVisible())
          # http://soundbible.com/1003-Ta-Da.html
          new Audio("tada.mp3").play()
          writeMessage messageLayer, 'Congrats! All Done!'

          circleFrame.setFill(shapes.circle.color)
          circleFrame.show()

          boxFrame.setFill(shapes.box.color)
          boxFrame.show()
          
          triangleFrame.setFill(shapes.triangle.color)
          triangleFrame.show()
          stage.draw()

          # blink effect, omg!!!!
          setInterval (->
            if (messageLayer.isVisible())
              messageLayer.hide()
            else
              messageLayer.show()
          ), 500
      ), 1000

      cb()  if cb

  shapeLayer = new Kinetic.Layer()
  messageLayer = new Kinetic.Layer()
  #timerLayer = new Kinetic.Layer()
  tolerance = 50

  circle = new Kinetic.Circle(
    x: shapes.circle.x
    y: shapes.circle.y
    radius: Math.max(100, Math.random() * stage.getWidth()/8)
    fill: shapes.circle.color
    stroke: "black"
    strokeWidth: 2
    draggable: true
  )
  
  box_w=box_h=Math.max(150, Math.random() * stage.getWidth()/6)


  box = new Kinetic.Rect(
    x: shapes.box.x
    y: shapes.box.y
    width: box_w
    height: box_h
    fill: shapes.box.color
    rotationDeg: Math.random() * 180,
    stroke: "black"
    strokeWidth: 2
    draggable: true
  )

  triangle = new Kinetic.RegularPolygon(
    x: shapes.triangle.x
    y: shapes.triangle.y
    sides: 3
    radius: Math.max(120, Math.random() * stage.getWidth()/8)
    stroke: "black"
    fill: shapes.triangle.color
    rotationDeg: Math.random() * 120
    strokeWidth: 2
    draggable: true
  )

  boxFrame = makeframe(box)
  circleFrame = makeframe(circle)
  triangleFrame = makeframe(triangle)
   
  msg = new Kinetic.Text(
    x: 10,
    y: stage.getHeight()/2,
    text: '',
    align: 'center'
    fontSize: 64,
    fontFamily: 'Calibri',
    textFill: 'green'
  )

  # write out drag and drop events
  circle.on "dragstart", ->
    this.moveToTop()
    writeMessage messageLayer, "CIRCLE", this.getFill()
    ###
    this.setAttrs {
      shadow: { offset: { x: 5, y: 5 } }
      scale: { x: 1.1, y: 1.1 }
    }
    ###
  circle.on "touchend dragend", ->
    ###
    this.setAttrs {
      shadow: { offset: { x: 0, y: 0 } }
      scale: { x: 1, y: 1 }
    }
    shapeLayer.draw()
    ###
    test_and_complete this, circleFrame, "CIRCLE"

  box.on "dragstart", ->
    this.moveToTop()
    writeMessage messageLayer, "SQUARE", this.getFill()

  box.on "touchend dragend", ->
    test_and_complete this, boxFrame, "SQUARE"

  triangle.on "dragstart", ->
    this.moveToTop()
    writeMessage messageLayer, "TRIANGLE", this.getFill()

  triangle.on "touchend dragend", ->
    test_and_complete this, triangleFrame, "TRIANGLE"
  
  findBounds = (shape) ->
    if shape.toObject().shapeType is "Rect"
      s_w = shape.getWidth()
      s_h = shape.getHeight()
      x_upper = shape.getX() + s_w/2
      x_lower = shape.getX() - s_w/2
      y_upper = shape.getY() + s_h/2
      y_lower = shape.getY() - s_h/2
    else
      s_r = shape.getRadius()
      x_upper = shape.getX() + s_r
      x_lower = shape.getX() - s_r
      y_upper = shape.getY() + s_r
      y_lower = shape.getY() - s_r
    {x:[x_lower,x_upper],y:[y_lower,y_upper]}

  # get boundaries
  circleFrame.bounds = findBounds(circleFrame)
  triangleFrame.bounds = findBounds(triangleFrame)
  boxFrame.bounds = findBounds(boxFrame)
  # check overlapping

  messageLayer.add msg

  shapeLayer.add circleFrame
  shapeLayer.add triangleFrame
  shapeLayer.add boxFrame
  shapeLayer.add circle
  shapeLayer.add triangle
  shapeLayer.add box

  stage.clear()
  stage.add shapeLayer
  stage.add messageLayer
  #stage.add timerLayer

)()
