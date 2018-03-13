class Ship extends PolygonPhysicsShape
  new: (...) =>
    -- Don't insert ship into new instance
    @isOwnObject = true
    super({-5, 5, -3,0,10,0}, 1, ...)
    love.physics.newFixture(@body, love.physics.newPolygonShape(-5,-5, -3,0,10,0), 1)

    @fixture\setRestitution(0.4)
    @fixture\setCategory(lssx.categories["Ship"])
    -- @fixture\setMask(lssx.categories["All"])

    @body\setAngularDamping(3)
    @body\setLinearDamping(2)

    @components = {}

  update: (dt) =>
    super\update(dt)
    for _, component in pairs(@components) do
      component\update(dt)
      if component.body != nil then
        component.body\setPosition(@x, @y)

  draw: () =>
    -- super\draw()
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    love.graphics.polygon("fill", @body\getWorldPoints(-5,-5, -3,0,10,0))
    for _, component in pairs(@components) do
      component\draw()

  remove: () =>
    SoundManager.playRandom("Explosion", 3)
    lx, ly = @body\getWorldCenter()
    for i=1, 20 do
      FlashSq(lx, ly)
    for k, component in pairs(@components) do
      component\remove()
    super\remove()

  fire: (groupIndex) =>
    SoundManager.playRandom("Laser_Shoot", 1, 0.3)
    xl, yl = @body\getWorldPoint(20,0)
    v = math.abs(@body\getLinearVelocity())*0.01+5
    a = @body\getAngle()+math.random(-10, 10)/50
    k = Bullet(xl, yl, 2, groupIndex)
    k.body\setAngle(a)
    k.body\applyLinearImpulse(v*math.cos(a), v*math.sin(a))
