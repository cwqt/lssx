class Shield extends CirclePhysicsShape
  new: (hp, x, y, gindex, ...) =>
    radius = hp*2
    super(radius, 0, lssx.world, x, y, "dynamic", ...)
    @hp = hp
    @originalHP = hp
    @disabledTime = 2
    @color = {255,0,0}

    @fixture\setCategory(lssx.categories["Shield"])
    @fixture\setMask(unpack(lssx.masks["Shield"]))
    @fixture\setGroupIndex(gindex)

    @timer = Timer.new()

  update: (dt) =>
    super\update(dt)
    @shape\setRadius(@hp/2)
    @timer\update(dt)

  draw: () =>
    love.graphics.setColor(@color)
    super\draw()

  takeDamage: (amount) =>
    if @hp > 0
      SoundManager.playRandom("ShieldHit", 0.5)
      flux.to(self, 0.2, {hp: @hp-amount})\oncomplete ->
        if @hp <= 5
          SoundManager.playRandom("ShieldDown", 1)
          @body\setActive(false)
          lx, ly = @body\getPosition()
          for i=1, 40 do
            Particle(@color, lx, ly, math.random(-10, 10)+lx,
                                          math.random(-10, 10)+ly,
                                          math.random(2, 5),
                                          math.random(5), 0.4)
          flux.to(self, 0.2, {hp: 0})
          Debugger.log("Shield disabled for " .. @disabledTime .. "s")
          @timer\after @disabledTime, ->
            Physics.addToBuffer ->
              if not lssx.PLAYER_DEAD
                Debugger.log("Shield restoring")
                SoundManager.playRandom("ShieldUp", 1)
                -- we're in the buffer and mightve been removed already
                if lssx.objects[@hash] != nil
                  @body\setActive(true)
                  if not lssx.PLAYER_DEAD
                    flux.to(self, 0.5, {hp: @originalHP})
    Debugger.log("Shield took " .. amount .. " damage", "death")

  remove: () =>
    Debugger.log("SHIELD DESTROYED")
    @timer\clear()
    super\remove()

  beginContact: (other) =>
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    switch other_object.__class.__name
      when "Bullet"
        x, y = other_object.body\getWorldCenter()
        FlashSq(x, y)
        @takeDamage(other_object.damage)
        other_object\remove()