colors = {
  {255,255,255}
  {255,255,255}
  {255,255,255}
  {255,69,0}
  {255,69,0}
  {100,10,10}
  {100,10,10}
  {0,0,0}
}
class FlashSq extends Object
  new: (x, y, intensity, color, ...) =>
    super(...)
    @c = {}
    intensity = intensity or 1
    z = 20*intensity
    @c.x, @c.y = x+math.random(-z, z), y+math.random(-z, z)
    @c.w = (10+math.random(30))*intensity
    @c.h = @c.w

    @startc = colors[math.random(#colors)]
    @endc   = colors[math.random(#colors)]
    rand = math.random(3)

    @tAlive = 0.1+math.random(5)/20
    if rand == 1
      flux.to(@c, @tAlive/6, {w: @c.w/1.2, h: @c.h/1.2})
    Timer.after @tAlive+0.1, -> super\remove()

    if color != nil then @startc = color

  update: (dt) =>

  draw: () =>
    love.graphics.setColor(@startc)
    love.graphics.rectangle("fill", @c.x, @c.y, @c.w, @c.h)
