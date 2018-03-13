class Laser extends Projectile
  new: (x, y, @damage, ...) =>
    points = {-1, -2, 1, -2, 2, -1, 2, 1, 1, 2, -1, 2, -2, 1, -2, -1}
    -- points = {20, 10, 20, -10, -5, -10, -5, 10}

    for i=1, #points do
      points[i] = points[i] * 5

    super(x, y, points, ...)
    @body\setLinearDamping(5)
    @body\setInertia(10)
    @fixture\setRestitution(0.1)

    Timer.after 4, ->
      @remove()

  update: (dt) =>
    super\update(dt)

  draw: () =>
    love.graphics.setColor(255,255,255)
    super\draw()

  beginContact: (other) =>
    super\beginContact(other)
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    switch other_object.__class.__name
      -- when "Player"
      --   other_object\takeDamage(@damage)
      --   @remove()
      -- when "Entity"
      --   other_object\takeDamage(@damage)
      --   @remove()
      when "Player"
        other_object\takeDamage(@damage)
        @remove()        
      when "Asteroid"
        other_object\takeDamage(@damage)
        @remove()
      when "Enemy"
        if other\getCategory() == lssx.categories["Ship"]
          LineExplosion(other_object.ship.x, other_object.ship.y)
          other_object\takeDamage(@damage)
          @remove()