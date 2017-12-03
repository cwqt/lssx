class PhysicsObject extends Object
  new: (world, @x, @y, bodyType) =>
    super()
    @body = love.physics.newBody(world, @x, @y, bodyType)
    -- Leave a reference to the table key (for collision data)
    @body\setUserData({hash: @hash})

  update: (dt) =>
    @x, @y = @body\getPosition()

  remove: () =>
    -- Remove self from global table, Box2D destroy self
    Physics.addToBuffer ->
      super\remove()
      @body\destroy()

  beginContact: (other) =>
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    print "I collided with object " .. other_object.__class.__name .. " with key " .. other\getBody()\getUserData().hash
