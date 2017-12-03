class PolygonPhysicsShape extends PhysicsObject
  new: (points, density, ...) =>
    super(...)
    @shape = love.physics.newPolygonShape(unpack(points))
    @fixture = love.physics.newFixture(@body, @shape, density)

  update: (dt) =>

  draw: () =>
    love.graphics.polygon("line", @body\getWorldPoints(@shape\getPoints()))
