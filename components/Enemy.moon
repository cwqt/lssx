class Enemy extends Entity
  new: (@ship, ...) =>
    super(...)
    --Reference ship to top-level player
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)

    @states = {
      {"idle", {}},
      {"chasing", {}},
      {"firing", {}},
    }

    -- @ship.fixture\setGroupIndex(-1)

    -- @ship.components["Emitter"] = Emitter!
    -- @ship.components["Shield"]  = Shield(10, 10, 10)
    -- Timer.every 0.5, ->
    --   lx, ly = @ship.body\getWorldPoints(15, 0)
    --   @ship\fire("Bullet", lx, ly, 2, -1)


  update: (dt) =>
    super\update(dt)
    @ship\update(dt)

    -- Instead of following the mouse (like the Player)
    -- follow the player's position
    mx, my = lssx.objects["Player"].ship.x, lssx.objects["Player"].ship.y 

    -- Get differential angle between mouse and body
    @angle = math.atan2(( my - @ship.y ), ( mx - @ship.x ))

    -- Map atan2 (-180, 180) onto 0-360
    @angle = math.deg(@angle)
    if @angle < 0 then @angle += 360

    -- Calculate differential angle between desired and actual angle
    -- Cap @body\getAngle() to 360 to prevent over-spin
    difference = @angle - (math.deg(@ship.body\getAngle()) % 360)

    -- Compensate for -360/360 overtick
    if difference > 180 difference -= 360
    if difference < -180 difference += 360

    -- Apply torque into direction of differential angle
    @ship.body\applyTorque(1.8 * difference)

    -- Get distance from mouse and body, calculate a velocity
    @v = math.dist(mx, my, @ship.x, @ship.y)*0.5

    -- Finally, apply the force
    @fx, @fy = @v*math.cos(@ship.body\getAngle()), @v*math.sin(@ship.body\getAngle())
    if not love.mouse.isDown("1")
      @ship.body\applyForce(@fx, @fy)

    if @HP <= 0 @die()

  draw: () =>
    love.graphics.setColor(255,0,0)
    super\draw()
    @ship\draw()
    love.graphics.setColor(255,255,255)

  beginContact: (other) =>
    @ship\beginContact(other)
    -- print(@ship.fixture\getGroupIndex())
    -- print(lssx.objects[other\getBody()\getUserData().hash].fixture\getGroupIndex())