class Ship extends PolygonPhysicsShape
  new: (...) =>
    -- Don't insert ship into new instance
    @isOwnObject = true
    super({-5,5,-5,-5,10,0}, 1, ...)

    @fixture\setRestitution(0.4)
    @body\setAngularDamping(4)
    @body\setLinearDamping(2)

    @components = {}

    Debugger.log("Spawned Ship at " .. @x .. ", " .. @y, "spawn")

  update: (dt) =>
    for _, component in pairs(@components) do
      component\update(dt)

    -- @components["Emitter"].x, @components["Emitter"].y = @body\getPosition()

  draw: () =>
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    for _, component in pairs(@components) do
      component\draw()

  -- fire: (dx, dy) =>
  --   @components["Emitter"]\emit(dx, dy)