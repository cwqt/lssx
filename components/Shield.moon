class Shield extends CirclePhysicsShape
  new: (hp, x, y, ...) =>
    radius = hp*2
    super(radius, 0, lssx.world, x, y, "dynamic", ...)
    @hp = hp
    @originalHP = hp
    @disabledTime = @originalHP/2

  update: (dt) =>
    super\update(dt)
    @shape\setRadius(@hp*2)

  draw: () =>
    super\draw()

  takeDamage: (amount) =>
    flux.to(self, 0.2, {hp: @hp-amount})\oncomplete ->
      if @hp <= 5 then
        lx, ly = @body\getPosition()
        for i=1, 40 do
          Particle({0,205,205}, lx, ly, math.random(-10, 10)+lx, math.random(-10, 10)+ly, math.random(2,5), math.random(5), 0.4)
        flux.to(self, 0.2, {hp: 0})
        Debugger.log("Shield disabled for " .. @disabledTime .. "s")
        Timer.after @disabledTime, ->
          Debugger.log("Shield restoring...")
          flux.to(self, @disabledTime/2, {hp: @initialHP})\ease("cubicout")
    Debugger.log("Shield took " .. amount .. " damage", "death")

  beginContact: (other) =>
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    switch other_object.__class.__name
      when "Bullet"
        @takeDamage(other_object.damage)
        other_object\remove()