class Player extends Entity
  new: (@ship, ...) =>
    super(...)
    --Reference ship to top-level player
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)
    lssx.LOW_HP = false

    -- @ship.body\setInertia(2)

    @ship.fixture\setGroupIndex(lssx.groupIndices["Friendly"])

    @oxygen = 100
    @fuel = 100
    @ammo = 1000
    @boost = 10

    @slomo = 100
    @canSlomo = false
    Timer.after 0.5, ->
      @canSlomo = true

    @ship.components["Shield"]  = Shield(10, 0, 0, lssx.groupIndices["Friendly"])
    @ship.components["Shield"].color = {0,205,205}

    -- aaahh fucking hell this code is getting spaghettified
    @trailPositions = {}
    @mouseTrailPositions = {}

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

    if not lssx.SHOW_INSTRUCTIONS
      if not love.mouse.isDown("2") -- stationary
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

    if @canSlomo
      if love.mouse.isDown("1")
        @slomo -= 1
        lssx.SLOW_MO = true
        TEsound.pitch("all", 0.7)
        if @slomo < 0
          @canSlomo = false
    else
      lssx.SLOW_MO = false
      TEsound.pitch("all", 1)
      @slomo += 1
      if @slomo == 100
        @canSlomo = true

    -- background resourcing
    @HP += 0.01
    @ammo += 0.1
    @oxygen += 0.01

    @HP = math.clamp(0, @HP, @initalHP+1)
    @ammo = math.clamp(0, @ammo, 1000)
    @fuel = math.clamp(0, @fuel, 100)
    @oxygen = math.clamp(0, @oxygen, 100)
    @slomo = math.clamp(0, @slomo, 100)

    
    table.insert(@trailPositions, { x: @ship.body\getX(), y: @ship.body\getY()})
    if #@trailPositions > 20 then
       table.remove(@trailPositions, 1)

    mx, my = lssx.camera\getMousePosition()
    table.insert(@mouseTrailPositions, { x: mx, y: my})
    if #@mouseTrailPositions > 8 then
       table.remove(@mouseTrailPositions, 1)

    if @HP <= 10
      if not lssx.LOW_HP
        TEsound.play("assets/Game/Sound/LowHP.ogg", "alarm", 5)
      lssx.LOW_HP = true
    else
      lssx.LOW_HP = false
      TEsound.pause("alarm")

    if @HP <= 0 @die()

  draw: () =>
    -- super\draw()
    love.graphics.setLineWidth(4)
    for i = 1, #@trailPositions do
      love.graphics.setColor(148,0,211, (255/(#@trailPositions)^2)*20*i)
      ax = @trailPositions[i]
      ay = @trailPositions[i]
      bx = @trailPositions[i+1] or @trailPositions[i]
      by = @trailPositions[i+1] or @trailPositions[i]
      -- love.graphics.circle("fill", @trailPositions[i].x, @trailPositions[i].y, 2)
      love.graphics.line(ax.x, ay.y, bx.x, by.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255,255,255)
    super\draw()
    @ship\draw()

    love.graphics.circle("fill", @mouseTrailPositions[#@mouseTrailPositions].x, @mouseTrailPositions[#@mouseTrailPositions].y, 5)
    for i = 1, #@mouseTrailPositions do
      love.graphics.setColor(0,205,205, (255/(#@mouseTrailPositions)^2)*20*i)
      ax = @mouseTrailPositions[i]
      ay = @mouseTrailPositions[i]
      bx = @mouseTrailPositions[i+1] or @mouseTrailPositions[i]
      by = @mouseTrailPositions[i+1] or @mouseTrailPositions[i]
      -- love.graphics.circle("fill", @mouseTrailPositions[i].x, @mouseTrailPositions[i].y, 2)
      love.graphics.line(ax.x, ay.y, bx.x, by.y)

  takeDamage: (amount) =>
    super\takeDamage(amount)
    LineExplosion(@ship.x, @ship.y)
    SPFX.bounceChroma(0.5, 10, 10)
    lssx.camera\flash(0.05, {0, 0, 0, 255})
    CameraManager.shake(200, 5, 5)

  die: () =>
    SoundManager.playRandom("Death", 1)
    TEsound.pitch("music", 0.8)
    TEsound.pitch("alarm", 0.8)
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
      when "`"
        @takeDamage(1)
      when "w"
        SoundManager.playRandom("Boost", 1, 2)
        @ship.body\applyLinearImpulse(50*math.cos(@ship.body\getAngle()), 50*math.sin(@ship.body\getAngle()))
        -- @ship.body\applyAngularImpulse(50)
      -- when "f"
      --   @fire()

  mousereleased: (x, y, button) =>
    if button == 1
      lssx.SLOW_MO = false
      TEsound.pitch("all", 1)
