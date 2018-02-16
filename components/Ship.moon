class Ship extends PolygonPhysicsShape
  new: (...) =>
    -- Don't insert ship into new instance
    @isOwnObject = true
    super({-5,5,-5,-5,10,0}, 1, ...)

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
    -- love.graphics.setLineStyle("rough")
    super\draw()
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    for _, component in pairs(@components) do
      component\draw()

  remove: () =>
    lx, ly = @body\getWorldCenter()
    for i=1, 20 do
      FlashSq(lx, ly)
    for k, component in pairs(@components) do
      component\remove()
    super\remove()

  fire: (groupIndex) =>
    xl, yl = @body\getWorldPoint(14,0)
    v = math.abs(@body\getLinearVelocity())*0.001+2
    a = @body\getAngle()
    k = Bullet(xl, yl, 2, groupIndex)
    k.body\applyLinearImpulse(v*math.cos(a), v*math.sin(a))
