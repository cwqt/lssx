class Emitter extends Object
  new: (@x, @y, ...) =>
    super(...)
    Timer.every 0.1, -> @emit("Bullet", 20, 40, 1)

  update: (dt) =>

  draw: () =>
    love.graphics.circle("fill", @x, @y, 2)

  emit: (object, dx, dy, v) =>
    dir = math.atan2((dy - @y), (dx - @x))
    fx, fy = v*math.cos(dir), v*math.sin(dir)
    switch object
      when "Bullet"
        Bullet(2, @x, @y, fx, fy, 1)