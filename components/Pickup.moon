class Pickup extends PolygonPhysicsShape
  new: (x, y, ...) =>
    super({0,0, 15,0, 15,15, 0,15}, 1, lssx.world, x, y, "dynamic", ...)

    types = {
      "oxygen",
      "fuel",
      "ammo",
      "boost"
    }
    @type = types[math.random(#types)]

    @body\applyAngularImpulse(50)
    @config = {
      s: 20
      r: 0
    }
    flux.to(@config, 2, {s: 40, r:math.random(10)})\after(@config, 2, {s: 15, r: 0})
    Timer.every 4, ->
      flux.to(@config, 2, {s: 40, r:math.random(10)})\after(@config, 2, {s: 15, r: 0})

  update: (dt) =>
    super\update()

  draw: () =>
    love.graphics.setColor(255,255,255)
    lx, ly = @body\getWorldCenter()
    PushRotate(lx, ly, @config.r)
    love.graphics.rectangle("line", lx-@config.s/2, ly-@config.s/2, @config.s, @config.s)
    love.graphics.rectangle("line", lx-@config.s/1.2/2, ly-@config.s/1.2/2, @config.s/1.2, @config.s/1.2)
    love.graphics.pop()
    super\draw()

  beginContact: (other) =>
    super\beginContact(other)
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    switch other_object.__class.__name
      when "Player"
        @fixture\setSensor(true)
        FlashSq(@x, @y)
        FlashSq(@x, @y)
        FlashSq(@x, @y)
        other_object[@type] += 10
        @remove()
