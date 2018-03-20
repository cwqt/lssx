class Projectile extends PolygonPhysicsShape
  new: (x, y, points, groupIndex, ...) =>
    super(points, 0.2, lssx.world, x, y, "dynamic", ...)
    @body\isBullet(true)
    @fixture\setCategory(lssx.categories["Projectile"])
    @fixture\setMask(lssx.categories["Projectile"])
    @fixture\setGroupIndex(groupIndex)
    Timer.after 1, -> super\remove()

  update: (dt) =>
    super\update(dt)
    if math.abs(@body\getLinearVelocity()) < 80
      FlashSq(@x, @y, 0.3)
      @remove()

  draw: () =>
    super\draw()
