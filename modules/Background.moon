Background = {}

Background.load = () ->
  export pos = {}
  sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.setLineStyle("rough")
  for i=1, 200 do
    table.insert(pos, {x: math.random(sw), y: math.random(sh), r: math.random(5)})

Background.draw = () ->
  love.graphics.setColor(60, 60, 60)
  for i=1, 200 do
    love.graphics.circle("line", pos[i].x, pos[i].y, pos[i].r)

return Background