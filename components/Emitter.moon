class Emitter extends Object
  new: (...) =>
    super(...)
    -- Timer.every 0.1, -> @emit("Bullet", 20, 40, 1)

  update: (dt) =>

  draw: () =>

  emit: (object, x, y, dx, dy, v, vextra) =>
    vextra = vextra or 0
    vextra = math.abs(vextra)

    dir = math.atan2((dy - y), (dx - x))
    fx, fy = (v+vextra)*math.cos(dir), (v+vextra)*math.sin(dir)
    switch object
      when "Bullet"
        Bullet(2, x, y, fx, fy, 1)