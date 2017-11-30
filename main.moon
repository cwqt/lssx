class Object
	new: () =>
		-- hash the time, insert into table
		@hash = lssx.hashFunc(love.timer.getTime())		
		lssx.objects[@hash] = self

	remove: () =>
		table.remove(lssx.objects, @hash)

	updateUserData: (data) =>
		t = @body\getUserData()
		t[#t+1] = data
		@body\setUserData(t) 		

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

lssx.groupIndexes = {
	["FriendlyFire"]: 1
}

class PhysicsObject extends Object 
	-- world, 10, 20, "dynamic"
	new: (world, @x, @y, @type, @isSensor) =>
		@body = love.physics.newBody(world, @x, @y, @type)
		-- Leave a reference to the table key (for collision data) 
		@body\setUserData({hash = @hash})
		if @isSensor
			@body\setSensor(true)

	update: (dt) =>
		@x, @y = @body\getPosition()

	remove: () =>
		super\remove()
		@body\destroy()	


Physics.beginContact(a, b, coll)
 lssx.objects[a\getUserData().hash]\beginContact(b)
 lssx.objects[b\getUserData().hash]\beginContact(a)

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
	for i = #Physics.buffer, 1, -1  do
	  Physics.buffer[i]()
	  table.remove(Physics.buffer, i)

Player.beginContact = (otherFixture) ->
	otherHash = otherFixture\getUserData().hash -- returns table, {hash=self.hash}
	other =  lssx.objects[otherHash]
	switch other.__class.__name
		when "Asteroid"
			print "Ouch"
		when "Bullet"
			@takeDamage(other.dmg)
			other\destroy()
