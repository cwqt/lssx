class Player extends Entity
  new: (@x, @y, ...) =>
    super(...)
    @ship = Ship(lssx.world, @x, @y, "dynamic")
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)

    Debugger.log("Player spawned.", "spawn")

    -- Mouse selection
    @mshape = love.physics.newCircleShape(love.mouse.getX(), love.mouse.getY(), 5)
    @mfix = love.physics.newFixture(@ship.body, @mshape)
    @mfix\setSensor(true)

  update: (dt) =>
    super\update(dt)
    @ship\update(dt)

  draw: () =>
    super\draw()
    @ship\draw()
    love.graphics.setColor(255,0,0)
    mx, my = @ship.body\getWorldPoints(@mshape\getPoint())
    love.graphics.circle("fill", mx, my, @mshape\getRadius())
    love.graphics.setColor(255,255,255)
