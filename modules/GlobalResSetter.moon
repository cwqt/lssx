GlobalResolutionSetter = {}

GlobalResolutionSetter.load = () ->
  -- Scale everything with nearest neighbour
  love.graphics.setDefaultFilter('nearest', 'nearest')
  lssx.canvas = love.graphics.newCanvas(lssx.WIDTH, lssx.HEIGHT)

GlobalResolutionSetter.attach = () ->
  love.graphics.setCanvas(lssx.canvas)
  love.graphics.clear()
  -- Draw game contents

GlobalResolutionSetter.detach = () ->
  love.graphics.setCanvas()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(lssx.canvas, 0, 0, 0, lssx.SCALE, lssx.SCALE)
  love.graphics.setBlendMode('alpha')

return GlobalResolutionSetter