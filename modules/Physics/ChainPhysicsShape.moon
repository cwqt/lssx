class ChainPhysicsShape extends PhysicsObject
  new: (points, density, ...) =>
    super(...)
    @shape = love.physics.newChainShape(true, points)
    @fixture = love.physics.newFixture(@body, @shape, density)

  update: (dt) =>
    super\update(dt)

  draw: () =>
    love.graphics.setColor(255,255,255)
    love.graphics.line(@body\getWorldPoints(@shape\getPoints()))
