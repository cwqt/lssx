class Bullet extends Projectile
  new: (x, y, @damage, ...) =>
    -- points = {-1, -2, 1, -2, 2, -1, 2, 1, 1, 2, -1, 2, -2, 1, -2, -1}
    points = {-5,1,-5,-1,5,-1,5,1}
    -- for i=1, #points do
    --   points[i] = points[i] * 0.5

    super(x, y, points, ...)
    @body\setLinearDamping(2)
    @body\setInertia(10)
    @fixture\setRestitution(0.1)

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
        if other_object.ship.components["Shield"].hp > other_object.ship.components["Shield"].originalHP/6  then return
        other_object\takeDamage(1)
        @remove()
        lssx.SLOW_MO = true
        TEsound.pitch("all", 0.7)
        Timer.after 0.5, ->        
          lssx.SLOW_MO = false
          TEsound.pitch("all", 1)
      when "Asteroid"
        other_object\takeDamage(@damage)
        @remove()
      when "Enemy"
        if other\getCategory() == lssx.categories["Ship"]
          LineExplosion(other_object.ship.x, other_object.ship.y)
          other_object\takeDamage(@damage)
          @remove()