class Asteroid extends PolygonPhysicsShape
  new: (x, y, @scale, ...) =>
    v = {}
    for i=1, 16, 2 do
      v[i] = math.random(-50, 50)
      v[i+1] = math.random(-50, 50)

    @scale = @scale or math.random(0.2, 1.5)
    for i=1, #v do v[i] = v[i] * @scale
    super(v, 1, lssx.world, x, y, "dynamic", ...)
    @hp = math.ceil(@body\getMass())

    @fixture\setCategory(lssx.categories["Asteroid"])

    @fixture\setFriction(1)
    @body\setLinearDamping(0.2)
    @body\setAngularDamping(0.2)

  update: (dt) =>

  draw: () =>
    super\draw()
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    love.graphics.setColor(255,255,255)
    love.graphics.polygon("line", @body\getWorldPoints(@shape\getPoints()))

  takeDamage: (amount) =>
    @hp -= amount

  beginContact: (other) =>
    super\beginContact(other)
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    other_name = other_object.__class.__name
    switch other_name
      when "Bullet"
        if @hp <= 0 then @remove()

  remove: () =>
    SoundManager.playRandom("AsteroidExp", 2)
    x, y = @body\getWorldCenter()
    m = @body\getMass()
    if m > 4
      c = math.random(1, 6)
      Debugger.log("Asteroid breaking up into " .. c .. " parts")
      p = {@body\getWorldPoints(@shape\getPoints())}
      for i=1, #p, 2 do
        FlashSq(p[i], p[i+1])
      Physics.addToBuffer ->      
        for i=1, c do
          k = Asteroid(x+math.random(-10,10), y+math.random(-10,10), 1.4*@scale/c)
          -- thanks @ILILIL#2995 ★~(◡‿◡✿)
          if k.body\getMass() > m
            k\remove()
          else
            k.body\applyAngularImpulse(math.random(-200, 200))
    FlashSq(x, y)
    FlashSq(x, y)
    super\remove()
