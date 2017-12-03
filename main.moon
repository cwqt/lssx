require "moonscript"
io.stdout\setvbuf("no")

export lssx = {
  objects: {}
  INIT_TIME: love.timer.getTime()
  -- I am a ...
  categories: {
  	["Player"]:     1,
  	["Projectile"]: 2,
  	["Ship"]:       3,
  }
  groupIndices: {
    ["FriendlyFire"]: 1
  }
}
-- I will collide with a...
lssx.masks = {
	["Player"]: {
		lssx.categories["Projectile"]
		lssx.categories["Asteroid"]
		lssx.categories["AI"]
	}
}

export Physics             = require("Physics")

export Object              = require("Object")
export PhysicsObject       = require("PhysicsObject")
export PolygonPhysicsShape = require("PolygonPhysicsShape")

love.load = () ->
  Physics.load()
  lssx.world\setCallbacks(beginContact, endContact, preSolve, postSolve)

  export Test = PolygonPhysicsShape({10, 20, 30, 40, 40, 80}, 0.1, lssx.world, 10, 20, "dynamic")
  Test.body\applyForce(10000,0)

  export Test4 = PolygonPhysicsShape({10, 20, 30, 40, 40, 40, 200, -100}, 0.1, lssx.world, 100, 20, "dynamic")
  -- export Test = PhysicsObject(lssx.world, 10, 20, "dynamic")
  -- export Test2 = PhysicsObject(lssx.world, 50, 20, "dynamic")
  -- print Test.body\getUserData().hash

love.update = (dt) ->
  Physics.update(dt)
  require("../libs/lovebird/lovebird").update()
  for k, object in pairs(lssx.objects) do
  	object\update(dt)

love.draw = () ->
  for k, object in pairs(lssx.objects) do
  	object\draw()

export beginContact = (a, b, coll) ->
  lssx.objects[a\getBody()\getUserData().hash]\beginContact(b)
  lssx.objects[b\getBody()\getUserData().hash]\beginContact(a)


export endContact = (a, b, coll) ->

export preSolve = (a, b, coll) ->

export postSolve = (a, b, coll, normalimpulse, tangentimpulse) ->
