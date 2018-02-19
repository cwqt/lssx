class LineExplosion extends Object
  new: (@x, @y, @count=math.random(4,8), ...) =>
    super(...)
    @c = { -- ox, offsetx, ex, endx
      ox: 2
      oy: 2
      ex: 10
      ey: 10
      o: 255
    }
    t = math.random(5)/10+0.1
    mo, me = math.random(20)+5, math.random(20)+10
    flux.to(@c, t, {ox: mo, oy: mo, ex: me, ey: me})\ease("quadout")\oncomplete(-> super\remove())
    Timer.after(t/2, -> flux.to(@c, t/2, {o: 0}))

  update: (dt) =>

  draw: () =>
    love.graphics.setColor(255,255,255, @c.o)
    for i=1, @count do
      PushRotate(@x, @y, math.rad((360/@count)*i))
      love.graphics.line(@x+@c.ox, @y+@c.ox, @x+@c.ex, @y+@c.ey)
      love.graphics.pop()