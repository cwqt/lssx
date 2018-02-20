Background = {}

Background.load = () ->
  export pos = {}
  sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

Background.draw = () ->
  love.graphics.setColor(60, 60, 60)

  Background.drawGrid(0, 0)
  Background.drawGrid(1000, 0)
  Background.drawGrid(0, 1000)
  Background.drawGrid(1000, 1000)

  love.graphics.setLineWidth(3)
  love.graphics.line(0, 0, 0, 20)
  love.graphics.line(-10, 10, 10, 10)

  love.graphics.setLineWidth(0.9)

Background.drawGrid = (offsetx, offsety) ->
  love.graphics.line(0+offsetx, 0+offsety, 0+offsetx, 1000+offsety)
  love.graphics.line(0+offsetx, 0+offsety, 1000+offsetx, 0+offsety)
  for i=1, 20 do
    x = i*50
    love.graphics.line(x+offsetx, 0+offsety, x+offsetx, 1000+offsety)
    love.graphics.line(0+offsetx, x+offsety, 1000+offsetx, x+offsety)

    -- love.graphics.push()
    -- love.graphics.translate(math.random(x)%50, math.random(x)%50)
    -- love.graphics.setLineWidth(3)
    -- love.graphics.line(0, 0, 0, 20)
    -- love.graphics.line(-10, 10, 10, 10)
    -- love.graphics.setLineWidth(0.9)
    -- love.graphics.pop()

return Background