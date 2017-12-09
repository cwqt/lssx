class Projectile extends PolygonPhysicsShape
  new: (@lifetime, ...) =>
    super(...)
    @body\isBullet(true)

  update: (dt) =>
    super\update(dt)
    if (love.timer.getTime() - lssx.INIT_TIME) > @lifetime
      @remove()

  draw: () =>
    super\draw()
    love.graphics.circle(10, 10, 10)