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

export Object              = require("components/Object")

export Physics             = require("modules/Physics/Physics")
export PhysicsObject       = require("modules/Physics/PhysicsObject")
export PolygonPhysicsShape = require("modules/Physics/PolygonPhysicsShape")

love.load = () ->
  Physics.load()

  export Test = PolygonPhysicsShape({10, 20, 30, 40, 40, 80}, 0.1, lssx.world, 10, 60, "dynamic")
  Test.body\applyForce(10000,0)
  Test.type = "memer"
  Test\appendUserData("help", "Memes")
  Test4 = PolygonPhysicsShape({10, 20, 30, 40, 40, 40, 200, -100}, 0.1, lssx.world, 100, 60, "dynamic")

love.update = (dt) ->
  Physics.update(dt)
  require("../libs/lovebird/lovebird").update()
  for k, object in pairs(lssx.objects) do
  	object\update(dt)

love.draw = () ->
  for k, object in pairs(lssx.objects) do
  	object\draw()

export beginContact = (a, b, coll) ->
  print "contact"
  lssx.objects[a\getBody()\getUserData().hash]\beginContact(b)
  lssx.objects[b\getBody()\getUserData().hash]\beginContact(a)


export endContact = (a, b, coll) ->

export preSolve = (a, b, coll) ->

export postSolve = (a, b, coll, normalimpulse, tangentimpulse) ->
