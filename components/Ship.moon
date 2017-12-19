class Ship extends PolygonPhysicsShape
  new: (...) =>
    -- Don't insert ship into new instance
    @isOwnObject = true
    super({-5,5,-5,-5,10,0}, 1, ...)

    @fixture\setRestitution(0.4)
    @body\setAngularDamping(4)
    @body\setLinearDamping(2)

    @components = {}

  update: (dt) =>
    super\update(dt)
    for _, component in pairs(@components) do
      component\update(dt)
      -- component.x, component.y = @x, @y

  draw: () =>
    love.graphics.setLineStyle("rough")
    love.graphics.polygon("line", @body\getWorldPoints(@shape\getPoints()))
    for _, component in pairs(@components) do
      component\draw()

  remove: () =>
    for k, component in pairs(@components) do
      component\remove()
    super\remove()


  fire: (object, dx, dy, v) =>
    @components["Emitter"]\emit(object, @x, @y, dx, dy, v, {@body\getLinearVelocity()})