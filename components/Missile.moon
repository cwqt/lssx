class Missile extends Projectile
  new: (x, y, ...) =>
    super(x, y, {-4,4, -4,-4, 4, 0}, ...)

  update: (dt) =>
    super\update(dt)

  draw: () =>
    super\draw()