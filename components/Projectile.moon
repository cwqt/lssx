-- PolygonPhysicsShape(points, density, world, x, y, bodyType, customHash)

class Projectile extends PolygonPhysicsShape
  new: (x, y, points, @lifetime, ...) =>
    super(points, 0.2, lssx.world, x, y, "dynamic", ...)
    -- @body\isBullet(true)

    -- -- Keep projectile inkeeping with conservation of momentum
    -- @body\setLinearVelocity(vinit)
    -- -- Calculate components of force
    -- dir = math.atan2((dy - @y), (dx - @x))
    -- fx, fy = v*math.cos(dir), v*math.sin(dir)
    -- @body\applyLinearImpulse(fx, fy)

  update: (dt) =>
    super\update(dt)
    if (@creationTime+lssx.INIT_TIME - love.timer.getTime()) < @lifetime*-1
      @remove()

  draw: () =>
    super\draw()
