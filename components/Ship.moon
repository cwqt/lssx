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
      if component.body != nil then
        component.body\setPosition(@x, @y)

  draw: () =>
    -- love.graphics.setLineStyle("rough")
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    for _, component in pairs(@components) do
      component\draw()

  remove: () =>
    lx, ly = @body\getWorldCenter()
    for i=1, 100 do
      Particle({255,255,0}, lx, ly, math.random(-10, 10)+lx, math.random(-10, 10)+ly, 5, math.random(5), love.math.random(4)*0.1)
    for k, component in pairs(@components) do
      component\remove()
    super\remove()

  fire: (object, dx, dy, v, groupIndex) =>
    @components["Emitter"]\emit(object, @x, @y, dx, dy, v, {@body\getLinearVelocity()}, groupIndex)