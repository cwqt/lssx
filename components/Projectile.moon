class Projectile extends PolygonPhysicsShape
  new: (x, y, points, @lifetime, ...) =>
    super(points, 0.2, lssx.world, x, y, "dynamic", ...)
    -- @body\isBullet(true)

  update: (dt) =>
    super\update(dt)
    if (@creationTime+lssx.INIT_TIME - love.timer.getTime()) < @lifetime*-1
      @remove()

  draw: () =>
    super\draw()
