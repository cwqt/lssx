class CirclePhysicsShape extends PhysicsObject
  new: (@radius, density, ...) =>
    super(...)
    @shape = love.physics.newCircleShape(@x, @y, @radius)
    @fixture = love.physics.newFixture(@body, @shape, density)

  update: (dt) =>
    super\update(dt)

  draw: () =>
    lx, ly = @body\getWorldPoints(@shape\getPoint())
    love.graphics.circle("line", lx, ly, @shape\getRadius())
