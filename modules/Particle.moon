class Particle extends Object
  new: (@colour, @x, @y, @dx, @dy, @s, @v, @life) =>
    super()
    @r, @g, @b = unpack(@colour)
    @dir = math.atan2(( @dy - @y ), ( @dx - @x ))
    @xv, @yv = @v * math.cos(@dir), @v * math.sin(@dir)

    @s = math.random(@s)
    @w, @h = math.random(1)*@s, math.random(1)*@s
    @opacity = 255
    @opacityStep = 255/@life
    @angle = math.random(360)

  update: (dt) =>
    @x += @xv
    @y += @yv
    @opacity -= @opacityStep*dt
    @angle -= 1 * dt

    if @creationTime+lssx.INIT_TIME - love.timer.getTime() < @life*-1
      super\remove()

  draw: () =>
    love.graphics.push()
    love.graphics.translate(@x, @y) -- move relative (0,0) to (x,y)
    love.graphics.rotate(math.deg(@angle)) -- rotate coordinate system around relative (0,0) (absolute (x,y))
    love.graphics.setColor(@r, @g, @b, @opacity)
    love.graphics.rectangle("fill", -@w/2, -@h/2, @w, @h)
    love.graphics.pop()
    love.graphics.setColor(255,255,255,255)