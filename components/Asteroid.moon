class Asteroid extends PolygonPhysicsShape
  new: (x, y, @scale, ...) =>
    v = {}
    for i=1, 16, 2 do
      v[i] = math.random(100)
      v[i+1] = math.random(100)

    @scale = @scale or math.random(0.2, 1)
    for i=1, #v do v[i] = v[i] * @scale

    print(@scale)

    super(v, 1, lssx.world, x, y, "dynamic", ...)

    @fixture\setFriction(1)

    @fixture\setCategory(lssx.categories["Asteroid"])
    @body\setLinearDamping(0.2)
    @body\setAngularDamping(0.2)

    print(@body\getMass())

  update: (dt) =>

  draw: () =>
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    love.graphics.setColor(255,255,255)
    love.graphics.polygon("line", @body\getWorldPoints(@shape\getPoints()))


  beginContact: (other) =>
    super\beginContact(other)
    other_object = lssx.objects[other\getBody()\getUserData().hash].__class.__name
    if other_object == "Player"
      @remove()

  remove: () =>
    x, y = @body\getWorldCenter()
    if @body\getMass() > 2.5
      c = math.ceil(@body\getMass()/math.random(3,6))
      Debugger.log("Asteroid breaking up into " .. c .. " parts")
      p = {@body\getWorldPoints(@shape\getPoints())}
      for i=1, #p, 2 do
        FlashSq(p[i], p[i+1])
        FlashSq(p[i], p[i+1])
        FlashSq(x, y)
      Physics.addToBuffer ->      
        for i=1, c do
          k = Asteroid(x, y, @scale/c)
          k.body\applyAngularImpulse(math.random(-50, 50))
    FlashSq(x, y)
    FlashSq(x, y)
    super\remove()
