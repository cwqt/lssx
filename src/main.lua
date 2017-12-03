io.stdout:setvbuf("no")
require("moonscript")
require("imgui")
require("lssx")
fluids = require("libs/fluids")
flux = require("libs/flux/flux")
lovebird = require("libs/lovebird/lovebird")
Gamestate = require("libs/hump/gamestate")
Timer = require("libs/hump/timer")
Camera = require("libs/STALKER-X/Camera")
moonshine = require("libs/moonshine")
Object = require("components/Object")
Debugger = require("modules/Debugger")
Physics = require("modules/Physics/Physics")
PhysicsObject = require("modules/Physics/PhysicsObject")
PolygonPhysicsShape = require("modules/Physics/PolygonPhysicsShape")
CirclePhysicsShape = require("modules/Physics/CirclePhysicsShape")
Entity = require("components/Entity")
Ship = require("components/Ship")
Player = require("components/Player")
love.load = function()
  Debugger.load()
  Physics.load()
  return Player(100, 100)
end
love.update = function(dt)
  for k, object in pairs(lssx.objects) do
    object:update(dt)
  end
  Timer.update(dt)
  Debugger.update(dt)
  Physics.update(dt)
  return flux.update(dt)
end
love.draw = function()
  for k, object in pairs(lssx.objects) do
    object:draw()
  end
  return Debugger.draw()
end
love.keypressed = function(key)
  fluids.keypressed(key)
  Debugger.keypressed(key)
  for _, object in pairs(lssx.objects) do
    if type(object.keypressed) == "function" then
      object:keypressed(key)
    end
  end
end
love.keyreleased = function(key)
  return fluids.keyreleased(key)
end
love.mousemoved = function(x, y)
  return fluids.mousemoved(x, y)
end
love.mousepressed = function(x, y, button)
  return fluids.mousepressed(button)
end
love.mousereleased = function(x, y, button)
  return fluids.mousereleased(button)
end
love.wheelmoved = function(x, y)
  return fluids.wheelmoved(x, y)
end
love.textinput = function(t)
  return fluids.textinput(t)
end
love.quit = function()
  return fluids.Quit()
end
love.run = function()
  if love.math then
    love.math.setRandomSeed(os.time())
  end
  if love.load then
    love.load(arg)
  end
  if love.timer then
    love.timer.step()
  end
  local dt = 0
  local fixed_dt = 1 / 60
  local accumulator = 0
  while true do
    if love.event then
      love.event.pump()
      for name, a, b, c, d, e, f in love.event.poll() do
        if name == "quit" then
          if not love.quit or not love.quit() then
            return a
          end
        end
        love.handlers[name](a, b, c, d, e, f)
      end
    end
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end
    accumulator = accumulator + dt
    while accumulator >= fixed_dt do
      if love.update then
        love.update(fixed_dt)
      end
      accumulator = accumulator - fixed_dt
    end
    if love.graphics and love.graphics.isActive() then
      love.graphics.clear(love.graphics.getBackgroundColor())
      love.graphics.origin()
      if love.draw then
        love.draw()
      end
      love.graphics.present()
    end
    if love.timer then
      love.timer.sleep(0.0001)
    end
  end
end
