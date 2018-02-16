class Bullet extends Projectile
  new: (x, y, @damage, ...) =>
    points = {-1, -2, 1, -2, 2, -1, 2, 1, 1, 2, -1, 2, -2, 1, -2, -1}
    -- for i=1, #points do
    --   points[i] = points[i] * 0.5

    super(x, y, points, ...)
    @body\setLinearDamping(0.8)
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
        other_object\takeDamage(@damage)
        @remove()        
      when "Asteroid"
        other_object\takeDamage(@damage)
        @remove()
      when "Enemy"
        print("hye")
        if other\getCategory() == lssx.categories["Ship"]
          other_object\takeDamage(@damage)
          @remove()