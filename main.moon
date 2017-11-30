class Object
	new: () =>
		-- Recursive check if our current hash is empty in the table
		-- If not, redo the hash with a new time
		local reHash = () ->
			hash - lssx.hashFunc(love.timer.getTime())
			if lssx.objects[hash] != nil then
				reHash()
			else
				@hash = hash
				lssx.objects[@hash] = self

	remove: () =>
		table.remove(lssx.objects, @hash)

	updateUserData: (data) =>
		t = @body\getUserData()
		t[#t+1] = data
		@body\setUserData(t) 		

class PhysicsObject extends Object 
	-- world, 10, 20, "dynamic"
	new: (world, @x, @y, @type) =>
		@body = love.physics.newBody(world, @x, @y, @type)
		-- Leave a reference to the table key (for collision data) 
		@body\setUserData({hash = @hash})

	update: (dt) =>
		@x, @y = @body\getPosition()

	remove: () =>
		-- Remove self from global table
		-- Box2D destroy self
		super\remove()
		Physics.addToBuffer ->
			@body\destroy()	

Physics = {}

Physics.load = () ->
	lssx.world = love.physics.newWorld(0, 0, true)
  Debugger.log("Created Box2D " .. tostring(lssx.world))

  -- Prevent erroneous errors on startup.
  Timer.after 1, ->
    Debugger.log("Collision callbacks active")
    world\setCallbacks(beginContact, endContact, preSolve, postSolve)  

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

Physics.beginContact(a, b, coll)
	-- Get the fixture userdata and call the objects collision callback
	if lssx.objects[a\getUserData().hash] !+ nil  
		lssx.objects[a\getUserData().hash]\beginContact(b)

	if lssx.objects[b\getUserData().hash] !+ nil  
		lssx.objects[b\getUserData().hash]\beginContact(a)

Player.beginContact = (otherFixture) ->
	otherHash = otherFixture\getUserData().hash -- returns table, {hash=self.hash}
	other =  lssx.objects[otherHash]
	switch other.__class.__name
		when "Asteroid"
			print "Ouch"
		when "Bullet"
			@takeDamage(other.dmg)
			other\destroy()

lssx = {}
-- I am a ...
lssx.categories = {
	["Player"]:     1,
	["Projectile"]: 2,
	["Ship"]:       3,
}

-- I will collide with a...
lssx.masks = {
	["Player"]: {
		lssx.categories["Projectile"]
		lssx.categories["Asteroid"]
		lssx.categories["AI"]
	}
}

lssx.groupIndices = {
	["FriendlyFire"]: 1
}

love.load = () ->
	Physics.load()

love.update = (dt) ->
	for k, object in pairs(lssx.objects) do 
		object\update(dt)

love.draw = () ->
	for k, object in pairs(lssx.objects) do 
		object\draw()
