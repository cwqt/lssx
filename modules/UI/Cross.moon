class Cross
  new: (@x, @y) =>

  draw: () =>
    love.graphics.line(@x-10, @y, @x+10, @y)
    love.graphics.line(@x, @y-10, @x, @y+10)

