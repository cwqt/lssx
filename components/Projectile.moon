class Projectile extends PolygonPhysicsShape
  new: (x, y, points, groupIndex, ...) =>
    super(points, 0.2, lssx.world, x, y, "dynamic", ...)
    @body\isBullet(true)
    @fixture\setCategory(lssx.categories["Projectile"])
    @fixture\setGroupIndex(groupIndex)

  update: (dt) =>
    super\update(dt)
    if math.abs(@body\getLinearVelocity()) < 1
      @remove()

  beginContact: (other) =>

  draw: () =>
    super\draw()
