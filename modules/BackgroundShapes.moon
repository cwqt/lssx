class Rect
  new: (@uuid) =>
    @x = math.random(2000)
    @y = math.random(2000)
    @w = math.random(250)
    @h = @w
    @o = 0
    @t1 = math.random(50)/10
    flux.to(@, @t1, {o: 20})
    @t2 = math.random(100)/10
    flux.to(@, @t2, {x: @x-100})\after(@, @t2, {x: @x+100})
    @t3 = math.random(100)/10
    Timer.after @t3, ->
      flux.to(@, @t1, {o: 0})\oncomplete -> 
        BackgroundShapes.shapes[@uuid] = nil
        u = UUID() 
        BackgroundShapes.shapes[u] = Rect(u)

  draw: () =>
    love.graphics.setColor(255,255,255,@o)
    love.graphics.rectangle("fill", @x, @y, @w, @h)

--====================================================
BackgroundShapes = {}

BackgroundShapes.load = () ->
  BackgroundShapes.shapes = {}
  for i=1, 100
    u = UUID() 
    BackgroundShapes.shapes[u] = Rect(u)

BackgroundShapes.draw = () ->
  for _, rect in pairs(BackgroundShapes.shapes) do
    rect\draw()

return BackgroundShapes