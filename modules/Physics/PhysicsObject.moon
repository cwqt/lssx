class PhysicsObject extends Object
  new: (world, @x, @y, bodyType, ...) =>
    super(...)
    @body = love.physics.newBody(world, @x, @y, bodyType)
    -- Leave a reference to the table key (for collision data)
    @body\setUserData({["hash"]: @hash})
    @removed = false

  update: (dt) =>
    @x, @y = @body\getPosition()


  draw: () =>
    -- love.graphics.print(@hash, @x, @y)

  appendUserData: (key, data) =>
    t = @body\getUserData()
    old = t[key]
    t[key] = data
    new = t[key]
    @body\setUserData(t)
    Debugger.log("Updated userData " .. key .. " from " .. old .. " to " .. new)

  changeHash: (newHash) =>
    super\changeHash(newHash)
    @body\appendUserData("hash", @hash)

  remove: () =>
    -- Mitigate repeated buffer adds
    if not @removed
      -- Remove self from global table, Box2D destroy self
      -- Pass hash along to check later for repeat attempt destroys
      Physics.addToBuffer ->
          @body\destroy()
          super\remove(),
        @hash,
        true
    @removed = true

  beginContact: (other) =>
    other_object = lssx.objects[other\getBody()\getUserData().hash]
    str = "-> " .. other_object.__class.__name .. ", k: " .. other\getBody()\getUserData().hash
    Debugger.log(str, "collision")