EntityManager = {}

EntityManager.clear = () ->
  for k, object in pairs(lssx.objects) do
    object\remove()
  Physics.runBuffer()
  Physics.runRemoves()
  
EntityManager.update = (dt) ->
  for k, object in pairs(lssx.objects) do
    object\update(dt)

EntityManager.draw = () ->
  for k, object in pairs(lssx.objects) do
    object\draw()

EntityManager.keypressed = (key) ->
  for k, object in pairs(lssx.objects) do
    if type(object.keypressed) == "function"
      object\keypressed(key)

EntityManager.mousereleased = (x, y, button) ->
  for k, object in pairs(lssx.objects) do
    if type(object.mousereleased) == "function"
      object\mousereleased(x, y, button)

return EntityManager
