class Pickup extends PolygonPhysicsShape
  new: (x, y, ...) =>
    super({0,0, 50,0, 50,50, 0,50}, 1, lssx.world, x, y, "dynamic", ...)

    types = {
      "oxygen",
      "fuel",
      "ammo",
      "HP"
    }

    @type = types[math.random(#types)]

    @color = {255,255,255}
    switch @type
      when "oxygen"
        @color = {0,0,255}
        @t = 10
      when "fuel"
        @color = {255,255,0}
        @t = 5
      when "ammo"
        @color = {255,0,0}
        @t = 20
      when "HP"
        @color = {0,255,0}
        @t = 15

    @co = @color

    @timer = Timer.new()

    @timer\after @t-@t/6, ->
      @timer\every 0.2, ->
        @timer\script (wait) ->
          wait(0.1)
          @color = {10,10,10}
          wait(0.1)
          @color = @co

    @timer\after @t, -> @remove()

    @body\applyAngularImpulse(50)
    @config = {
      s: 20
      r: 0
    }
    flux.to(@config, 2, {s: 40, r:math.random(10)})\after(@config, 2, {s: 50, r: 0})
    @timer\every 4, ->
      flux.to(@config, 2, {s: 40, r:math.random(10)})\after(@config, 2, {s: 50, r: 0})

  update: (dt) =>
    super\update()
    @timer\update(dt)

  draw: () =>
    love.graphics.setColor(@color)
    lx, ly = @body\getWorldCenter()
    PushRotate(lx, ly, @config.r)
    love.graphics.rectangle("line", lx-@config.s/2, ly-@config.s/2, @config.s, @config.s)
    love.graphics.rectangle("line", lx-@config.s/1.2/2, ly-@config.s/1.2/2, @config.s/1.2, @config.s/1.2)
    love.graphics.pop()
    super\draw()

  remove: () =>
    @timer\clear()
    lx, ly = @body\getWorldCenter()
    LineExplosion(lx, ly, 10)
    super\remove()

  beginContact: (other) =>
    super\beginContact(other)
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    switch other_object.__class.__name
      when "Player"
        GlitchText(@type, 0.1, @x, @y, @color)
        SoundManager.playRandom("Pickup", 1)
        @fixture\setSensor(true)
        lssx.SCORE += 2500
        switch @type
          when "ammo"
            other_object[@type] += 100
          when "oxygen"
            other_object[@type] += 25
          when "fuel"
            other_object[@type] += 25
          when "HP"
            other_object[@type] += 10
        @remove()

