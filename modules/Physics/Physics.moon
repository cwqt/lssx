Physics = {}

Physics.load = () ->
  Physics.buffer = {}
  Physics.removes = {}
  lssx.world = nil
  lssx.world = love.physics.newWorld(0, 0, true)
  Debugger.log("Created Box2D " .. tostring(lssx.world))
  -- lssx.world\setCallbacks(beginContact, endContact, preSolve, postSolve)
  -- Prevent erroneous errors on startup.
  Timer.after 0.2, ->
    lssx.world\setCallbacks(Physics.beginContact, Physics.endContact, Physics.preSolve, Physics.postSolve)
    Debugger.log("Collision callbacks active")

Physics.update = (dt) ->
  if lssx.SLOW_MO
    dt = dt * 0.1
  lssx.world\update(dt)
  Physics.runBuffer()
  Physics.runRemoves()
  Physics.buffer = {}
  Physics.removes = {}

Physics.addToBuffer = (func, hash, isDestroyCommand) ->
  if isDestroyCommand
    hash = hash or UUID()
    Debugger.log("Delete object " .. hash)
    Physics.removes[#Physics.removes+1] = {func, hash}
  else
    hash = hash or UUID()
    Physics.buffer[#Physics.buffer+1] = {func, hash}

Physics.runBuffer = () ->
  hash = {}
  if #Physics.buffer > 0 then
    for i = #Physics.buffer, 1, -1  do
      -- Detect if we've already seen this function before
      -- So we don't try and delete the same body twice
      if (not hash[Physics.buffer[i][2]]) then
        Physics.buffer[i][1]()
        hash[Physics.buffer[i][2]] = true
        table.remove(Physics.buffer, i)

Physics.runRemoves = () ->
  hash = {}
  if #Physics.removes > 0 then
    Debugger.log("Running removal stack")
    for i = #Physics.removes, 1, -1  do
      -- Same as runBuffer except for object deletion only
      -- ran last after world tick and Physics.runBuffer
      if (not hash[Physics.removes[i][2]]) then
        Physics.removes[i][1]()
        hash[Physics.removes[i][2]] = true
        table.remove(Physics.removes, i)

Physics.beginContact = (a, b, coll) ->
  Debugger.log("beginContact() triggered", "important")
  lssx.objects[a\getBody()\getUserData().hash]\beginContact(b, a)
  lssx.objects[b\getBody()\getUserData().hash]\beginContact(a, b)
  
Physics.endContact = (a, b, coll) ->

Physics.preSolve = (a, b, coll) ->

Physics.postSolve = (a, b, coll, normalimpulse, tangentimpulse) ->

return Physics