class Cross
  new: (@x, @y) =>

  draw: () =>
    love.graphics.line(@x+0, @y+0, @x+0, @y+20)
    love.graphics.line(@x+(-10), @y+10, @x+10, @y+10)