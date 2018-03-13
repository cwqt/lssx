range = 300

class Enemy extends Entity
  new: (@ship, ...) =>
    super(...)
    --Reference ship to top-level player
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)
    @ship.fixture\setGroupIndex(lssx.groupIndices["Enemy"])

    @fovshp = love.physics.newPolygonShape(10, 0, range, 20, range, -20)
    @fovfix = love.physics.newFixture(@ship.body, @fovshp, 0)

    -- @fovfix\setCategory(lssx.categories["Enemy_FOV"])
    -- @fovfix\setMask(lssx.categories["Player"])
    @fovfix\setSensor(true)
    @fovfix\setUserData("fov")
    -- @fovfix\setCategory(lssx.categories[""])
    @fovfix\setGroupIndex(lssx.groupIndices["Enemy"])

    -- @ship.components["Shield"]  = Shield(10, 0, 0, lssx.groupIndices["Enemy"])

    @ship.body\setInertia(2)

    @state = "idle"
    @states = {
      "idle": {0, 255, 0},
      "chasing": {255, 255, 0},
      "firing":{255, 0, 0},
      "hiding": {0, 0, 255},
    }

    
    -- @ship.components["Shield"]  = Shield(10, 10, 10)

  update: (dt) =>
    super\update(dt)
    @ship\update(dt)

    -- Instead of following the mouse (like the Player)
    -- follow the player's position
    mx, my = 0,0
    if lssx.objects["Player"]
      mx, my = lssx.objects["Player"].ship.x, lssx.objects["Player"].ship.y 
    else
      mx, my = @ship.x, @ship.y

    -- Get distance from player and body
    @d = math.dist(mx, my, @ship.x, @ship.y)

    -- Decide on a state based on player distance
    if @HP < (@initalHP/2)
      @state = "hiding"
    else
      if @d < 150 then
        @state = "firing"
      else
        @state = "chasing"

    -- Save the CPU
    -- Get differential angle between player and body
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
    @ship.body\applyTorque(difference)

    -- v is proportional to 1/2 distance from player
    @v = math.clamp(0, @d*0.3, 100)

    -- Calculate force components
    @fx, @fy = @v*math.cos(@ship.body\getAngle()), @v*math.sin(@ship.body\getAngle())
    
    -- If in close proximity, sprint towards player
    if @d < 75
      @fx = @fx*5
      @fy = @fy*5
    if @state == "hiding"
      @fx = @fx*-0.2
      @fy = @fy*-0.2

    -- Spin out of control
    if @HP <= 2 then
      @ship.body\setAngularVelocity(10)
      @fx=-@fx*5
      @fy=-@fy*5

    @fx = math.clamp(-200, @fx, 200)
    @fy = math.clamp(-200, @fy, 200)

    @ship.body\applyForce(@fx, @fy)

    if @HP <= 0 @die()

  draw: () =>
    love.graphics.setColor(unpack(@states[@state]))
    super\draw()
    @ship\draw()
    -- love.graphics.polygon("line", @ship.body\getWorldPoints(@fovshp\getPoints()))
    -- love.graphics.circle("line", @ship.x, @ship.y, 500)
    -- love.graphics.circle("line", @ship.x, @ship.y, 150)
    love.graphics.setColor(255,255,255)

  fire: () =>
    Physics.addToBuffer ->
      @ship\fire(lssx.groupIndices["Enemy"])

  die: () =>
    SoundManager.playRandom("Kill", 1, 0.1)
    GlitchText("KILL", 0.2, @ship.body\getX(), @ship.body\getY())
    lssx.KILLS += 1
    Physics.addToBuffer ->
      super\die()
    @ship\remove()

  beginContact: (other, ourfixture) =>
    @ship\beginContact(other)
    if (ourfixture\getUserData() == "fov") and (lssx.objects[other\getBody()\getUserData().hash].hash == "Player")
      @fire()

    -- print(selfs\getUserData())
    -- @ship\beginContact(other)
    -- print(@ship.fixture\getGroupIndex())
    -- print(lssx.objects[other\getBody()\getUserData().hash].hash)