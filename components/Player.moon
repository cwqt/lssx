class Player extends Entity
  new: (@ship, ...) =>
    super(...)
    --Reference ship to top-level player
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)

    -- @ship.body\setInertia(2)

    @ship.fixture\setGroupIndex(lssx.groupIndices["Friendly"])

    @oxygen = 100
    @fuel = 100
    @ammo = 1000
    @boost = 10

    @ship.components["Shield"]  = Shield(10, 0, 0, lssx.groupIndices["Friendly"])

  update: (dt) =>
    super\update(dt)
    @ship\update(dt)

    mx, my = lssx.camera\toWorldCoords(love.mouse.getPosition())

    -- Get differential angle between mouse and body
    @angle = math.atan2(( my - @ship.y ), ( mx - @ship.x ))

    -- Map atan2 (-180, 180) onto 0-360
    @angle = math.deg(@angle)
    if @angle < 0 then @angle += 360

    -- Calculate differential angle between desired and actual angle
    -- Cap @body\getAngle() to 360 to prevent over-spin
    difference = @angle - (math.deg(@ship.body\getAngle()) % 360)

    -- Compensate for -360/360 overtick
    if difference > 180 then difference -= 360
    if difference < -180 then difference += 360

    -- Apply torque into direction of differential angle
    @ship.body\applyTorque(1.2 * difference)

    -- Get distance from mouse and body, calculate a velocity
    @v = math.dist(mx, my, @ship.x, @ship.y)*0.5

    -- Detract some fuel from moving - adjust v
    if @fuel <= 0 then @v = @v*0.3

    -- Finally, apply the force
    @fx, @fy = @v*math.cos(@ship.body\getAngle()), @v*math.sin(@ship.body\getAngle())

    @fx = math.clamp(-200, @fx, 200)
    @fy = math.clamp(-200, @fy, 200)

    if not love.mouse.isDown("1")
      @ship.body\applyForce(@fx*0.8, @fy*1.2)
      @fuel -= @v*0.0002

    -- Take some background O2 away, check it
    @oxygen -= 0.01
    if @oxygen <= 0
      lssx.CHROMASEP = math.random(5)
      lssx.CHROMASEP_ANGLE = math.random(5)
      CameraManager.shake((@HP-@initalHP)*0.08, 0.2, 40, "XY")
      @HP -= 0.1
      @oxygen = 0

    if love.keyboard.isDown("f")
      @fire()


    @HP += 0.01
    @ammo += 0.1
    @oxygen += 0.01

    @HP = math.clamp(0, @HP, @initalHP+1)
    @ammo = math.clamp(0, @ammo, 1000)
    @fuel = math.clamp(0, @fuel, 100)
    @oxygen = math.clamp(0, @oxygen, 100)

    if @HP <= 0 @die()


  draw: () =>
    love.graphics.setColor(255,255,255)
    super\draw()
    @ship\draw()

  takeDamage: (amount) =>
    super\takeDamage(amount)
    LineExplosion(@ship.x, @ship.y)
    SPFX.bounceChroma(0.5, 10, 10)
    lssx.camera\flash(0.05, {0, 0, 0, 255})
    CameraManager.shake(200, 5, 5)

  die: () =>
    SoundManager.playRandom("Death", 1)
    @ammo = 0
    @boost = 0
    @fuel = 0
    @hp = 0
    @oxygen = 0
    Timer.after 2, -> lssx.PLAYER_DEAD = true
    Physics.addToBuffer ->
      super\die()
    @ship\remove()

  fire: () =>
    if @ammo > 3
      @ship\fire(lssx.groupIndices["Friendly"])
      @oxygen -= 0.05
      @ammo -= 1

  -- We're not a physics object, but we should pass on our data to our ship, which is
  beginContact: (other) =>
    @ship\beginContact(other)

  keypressed: (key) =>
    switch key
      when "s"
        @takeDamage(1)
      when "k"
        lssx.KILLS += 1
      when "w"
        @ship.body\applyAngularImpulse(50)
      -- when "f"
      --   @fire()
