class Projectile extends PolygonPhysicsShape
  new: (@lifetime, ...) =>
    super(...)
    @body\isBullet(true)

  update: (dt) =>
    super\update(dt)

  draw: () =>
    super\draw()