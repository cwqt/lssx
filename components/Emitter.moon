class Emitter extends Object
  new: (@accuracy, ...) =>
    super(...)
    @accuracy = @accuracy or 0
    -- Timer.every 0.5, -> @emit("Bullet", math.random(10), math.random(10), 10, 10, 1)

  update: (dt) =>

  draw: () =>

  emit: (object, x, y, dx, dy, v, lv) =>
    lv = lv or {}
    lv[1] = lv[1] or 0
    lv[2] = lv[2] or 0

    angle = math.atan2((dy - y), (dx - x))
    fx, fy = v*math.cos(angle), v*math.sin(angle)
    switch object
      when "Bullet"
        b = Bullet(x, y, 1, 5)
        b.body\setLinearVelocity(lv[1], lv[2])
        b.body\applyLinearImpulse(fx, fy)

