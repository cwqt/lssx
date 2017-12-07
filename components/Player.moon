class Player extends Entity
  new: (x, y, ...) =>
    super(...)
    @ship = Ship(lssx.world, x, y, "dynamic")
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)

    @oxygen = 100
    @fuel = 100
    @ammo = 50
    @boost = 10

    Debugger.log("Player spawned.", "spawn")

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
    if difference > 180 difference -= 360
    if difference < -180 difference += 360

    -- Apply torque into direction of differential angle
    @ship.body\applyTorque(1.2 * difference)

    -- Get distance from mouse and body, calculate a velocity
    @v = math.dist(mx, my, @ship.x, @ship.y)*0.3

    -- Detract some fuel from moving - adjust v
    @fuel -= @v*0.0002
    if @fuel <= 0 then @v = @v*0.3

    -- Finally, apply the force
    @fx, @fy = @v*math.cos(@ship.body\getAngle()), @v*math.sin(@ship.body\getAngle())
    if not love.mouse.isDown("1")
      @ship.body\applyForce(@fx, @fy)

    if (math.abs(@fx) + math.abs(@fy)) > 75 and @fuel > 0
      for i=0, 1, 1/(@v*0.1) do
        Particle({100,0,255}, @ship.x, @ship.y, math.random(10)+@ship.x, math.random(10)+@ship.y, math.random(3, 5), math.random(2), 0.4)

    -- Take some background O2 away, check it
    @oxygen -= 0.001
    if @oxygen <= 0
      lssx.CHROMASEP = math.random(5)
      lssx.CHROMASEP_ANGLE = math.random(5)
      lssx.camera\shake((@hp-@initalHP)*0.08, 0.2, 40, "XY")
      @hp -= 0.1
      @oxygen = 0


  draw: () =>
    super\draw()
    @ship\draw()
