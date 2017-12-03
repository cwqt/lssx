require("moonscript")
io.stdout:setvbuf("no")
lssx = {
  objects = { },
  INIT_TIME = love.timer.getTime(),
  categories = {
    ["Player"] = 1,
    ["Projectile"] = 2,
    ["Ship"] = 3
  },
  groupIndices = {
    ["FriendlyFire"] = 1
  }
}
lssx.masks = {
  ["Player"] = {
    lssx.categories["Projectile"],
    lssx.categories["Asteroid"],
    lssx.categories["AI"]
  }
}
Physics = require("Physics")
Object = require("Object")
PhysicsObject = require("PhysicsObject")
PolygonPhysicsShape = require("PolygonPhysicsShape")
love.load = function()
  Physics.load()
  lssx.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  Test = PolygonPhysicsShape({
    10,
    20,
    30,
    40,
    40,
    80
  }, 0.1, lssx.world, 10, 20, "dynamic")
  Test.body:applyForce(10000, 0)
  Test4 = PolygonPhysicsShape({
    10,
    20,
    30,
    40,
    40,
    40,
    200,
    -100
  }, 0.1, lssx.world, 100, 20, "dynamic")
end
love.update = function(dt)
  Physics.update(dt)
  require("../libs/lovebird/lovebird").update()
  for k, object in pairs(lssx.objects) do
    object:update(dt)
  end
end
love.draw = function()
  for k, object in pairs(lssx.objects) do
    object:draw()
  end
end
beginContact = function(a, b, coll)
  lssx.objects[a:getBody():getUserData().hash]:beginContact(b)
  return lssx.objects[b:getBody():getUserData().hash]:beginContact(a)
end
endContact = function(a, b, coll) end
preSolve = function(a, b, coll) end
postSolve = function(a, b, coll, normalimpulse, tangentimpulse) end
