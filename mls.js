// Generated by CoffeeScript 1.4.0
(function() {

  (function() {
    /*
      start= (new Date()).getTime()
      setInterval (->
        writeMessage(timerLayer,'Timer: '+(Math.round(((new Date()).getTime()-start)/100)/10)+'s')
      ), 100
    */

    var box, boxFrame, circle, circleFrame, isposmatch, makeframe, messageLayer, shapeLayer, stage, test_and_complete, timerLayer, tolerance, triangle, triangleFrame, winH, winW, writeMessage;
    writeMessage = function(messageLayer, message) {
      var context;
      context = messageLayer.getContext();
      messageLayer.clear();
      context.font = "18pt Calibri";
      context.fillStyle = "black";
      return context.fillText(message, 10, 25);
    };
    makeframe = function(shape) {
      var debug_counter, flag, frame, h, new_x, new_y, over_upper, under_lower, w;
      frame = shape.clone();
      frame.setFill("#fff");
      frame.setDraggable(false);
      debug_counter = 0;
      flag = true;
      while (flag) {
        new_x = Math.random() * stage.getWidth();
        new_y = Math.random() * stage.getHeight();
        if (frame.toObject().shapeType === "Rect") {
          w = frame.getWidth();
          h = frame.getHeight();
        } else {
          w = h = frame.getRadius();
        }
        over_upper = (new_x + w > stage.getWidth()) || (new_y + h > stage.getHeight());
        under_lower = (new_x - w < 0) || (new_y - h < 0);
        flag = over_upper || under_lower;
        console.log(++debug_counter);
      }
      frame.setPosition(new_x, new_y);
      return frame;
    };
    isposmatch = function(shape, frame) {
      var f_x, f_y, s_x, s_y;
      s_x = Math.round(shape.getX());
      s_y = Math.round(shape.getY());
      f_x = Math.round(frame.getX());
      f_y = Math.round(frame.getY());
      return (Math.abs(s_x - f_x) <= tolerance) && (Math.abs(s_y - f_y) <= tolerance);
    };
    test_and_complete = function(shape, frame, msg, cb) {
      var config;
      if (isposmatch(shape, frame)) {
        writeMessage(messageLayer, msg);
        shape.setPosition(frame.getAbsolutePosition().x, frame.getAbsolutePosition().y);
        shape.setDraggable(false);
        shapeLayer.draw();
        frame.hide();
        config = {};
        config.scale = {
          x: 2,
          y: 2
        };
        config.opacity = 0;
        config.duration = 0.8;
        config.easing = "ease-out";
        if (shape.toObject().shapeType === "Rect") {
          config.x = shape.getAbsolutePosition().x - (shape.getWidth() / 2);
          config.y = shape.getAbsolutePosition().y - (shape.getHeight() / 2);
        }
        shape.transitionTo(config);
        setTimeout((function() {
          messageLayer.clear();
          if (!circleFrame.isVisible() && !boxFrame.isVisible() && !triangleFrame.isVisible()) {
            return alert('All Done! Win!');
          }
        }), 1000);
        if (cb) {
          return cb();
        }
      }
    };
    winW = 630;
    winH = 460;
    if (document.body && document.body.offsetWidth) {
      winW = document.body.offsetWidth;
      winH = document.body.offsetHeight;
    }
    if (document.compatMode === "CSS1Compat" && document.documentElement && document.documentElement.offsetWidth) {
      winW = document.documentElement.offsetWidth;
      winH = document.documentElement.offsetHeight;
    }
    if (window.innerWidth && window.innerHeight) {
      winW = window.innerWidth;
      winH = window.innerHeight;
    }
    stage = new Kinetic.Stage({
      container: "container",
      width: winW,
      height: winH
    });
    shapeLayer = new Kinetic.Layer();
    messageLayer = new Kinetic.Layer();
    timerLayer = new Kinetic.Layer();
    tolerance = 10;
    circle = new Kinetic.Circle({
      x: Math.random() * stage.getWidth(),
      y: Math.random() * stage.getHeight(),
      radius: Math.max(70, Math.random() * 100),
      fill: "red",
      stroke: "black",
      strokeWidth: 2,
      draggable: true
    });
    box = new Kinetic.Rect({
      x: Math.random() * stage.getWidth(),
      y: Math.random() * stage.getHeight(),
      width: 100,
      height: 100,
      fill: "#00D2FF",
      stroke: "black",
      strokeWidth: 2,
      draggable: true
    });
    triangle = new Kinetic.RegularPolygon({
      x: Math.random() * stage.getWidth(),
      y: Math.random() * stage.getHeight(),
      sides: 3,
      radius: Math.max(70, Math.random() * 100),
      stroke: "black",
      fill: "yellow",
      strokeWidth: 2,
      draggable: true
    });
    boxFrame = makeframe(box);
    circleFrame = makeframe(circle);
    triangleFrame = makeframe(triangle);
    circle.on("dragend", function() {
      return test_and_complete(this, circleFrame, "CIRCLE MATCHED!");
    });
    box.on("dragend", function() {
      return test_and_complete(this, boxFrame, "SQUARE MATCHED!");
    });
    triangle.on("dragend", function() {
      return test_and_complete(this, triangleFrame, "TRIANGLE MATCHED!");
    });
    shapeLayer.add(circleFrame);
    shapeLayer.add(triangleFrame);
    shapeLayer.add(boxFrame);
    shapeLayer.add(circle);
    shapeLayer.add(triangle);
    shapeLayer.add(box);
    stage.add(shapeLayer);
    stage.add(messageLayer);
    return stage.add(timerLayer);
  })();

}).call(this);