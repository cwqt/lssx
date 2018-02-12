class Asteroid extends PolygonPhysicsShape
  new: (x, y, ...) =>
    v = {}
    for i=1, 16, 2 do
      v[i] = math.random(100)
      v[i+1] = math.random(100)
    @scale = math.random(0.2, 1)
    for i=1, #v do v[i] = v[i] * @scale

    super(v, 1, lssx.world, x, y, "dynamic", ...)

    @fixture\setFriction(1)
    @body\setLinearDamping(0.2)
    @body\setAngularDamping(0.2)

  update: (dt) =>

  draw: () =>
    -- love.graphics.polygon("line", @v)
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("fill", @body\getWorldPoints(@shape\getPoints()))
    love.graphics.setColor(255,255,255)
    love.graphics.polygon("line", @body\getWorldPoints(@shape\getPoints()))
