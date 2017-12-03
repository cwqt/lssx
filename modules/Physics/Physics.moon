Physics = {}

Physics.load = () ->
  lssx.world = love.physics.newWorld(0, 0, true)
  Debugger.log("Created Box2D " .. tostring(lssx.world))
  lssx.world\setCallbacks(beginContact, endContact, preSolve, postSolve)
  -- Prevent erroneous errors on startup.
  Timer.after 1, ->
    lssx.world\setCallbacks(Physics.beginContact, Physics.endContact, Physics.preSolve, Physics.postSolve)
    Debugger.log("Collision callbacks active")

Physics.update = (dt) ->
  lssx.world\update(dt)
  Physics.runBuffer()

Physics.buffer = {}
Physics.addToBuffer = (func) ->
  Physics.buffer[#Physics.buffer+1] = func

Physics.runBuffer = () ->
  if #Physics.buffer > 0
    for i = #Physics.buffer, 1, -1  do
      Physics.buffer[i]()
      table.remove(Physics.buffer, i)

Physics.beginContact = (a, b, coll) ->
  lssx.objects[a\getBody()\getUserData().hash]\beginContact(b)
  lssx.objects[b\getBody()\getUserData().hash]\beginContact(a)

Physics.endContact = (a, b, coll) ->
Physics.preSolve = (a, b, coll) ->
Physics.postSolve = (a, b, coll, normalimpulse, tangentimpulse) ->

return Physics