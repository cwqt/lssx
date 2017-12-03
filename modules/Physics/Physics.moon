Physics = {}

Physics.load = () ->
  lssx.world = love.physics.newWorld(0, 0, true)
  lssx.world\setCallbacks(beginContact, endContact, preSolve, postSolve)

  -- Debugger.log("Created Box2D " .. tostring(lssx.world))

  -- Prevent erroneous errors on startup.
  -- Timer.after 1, ->
    -- Debugger.log("Collision callbacks active")
    -- lssx.world\setCallbacks(beginContact, endContact, preSolve, postSolve)  

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

-- Physics.beginContact = (a, b, coll) ->
--   print a\getUserData()[hash]
  -- Get the fixture userdata and call the objects collision callback
  -- if lssx.objects[a\getUserData()[hash]] != nil
    -- lssx.objects[a\getUserData().hash]\beginContact(b)

  -- if lssx.objects[b\getUserData().hash] != nil
  --   lssx.objects[b\getUserData().hash]\beginContact(a)

-- Player.beginContact = (otherFixture) ->
--   otherHash = otherFixture\getUserData().hash -- returns table, {hash=self.hash}
--   other =  lssx.objects[otherHash]
--   switch other.__class.__name
--     when "Asteroid"
--       print "Ouch"
--     when "Bullet"
--       @takeDamage(other.dmg)
--       other\destroy()

return Physics