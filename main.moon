io.stdout\setvbuf("no")
require("moonscript")
require("imgui")
require("lssx")

export fluids              = require("libs/fluids")
export flux                = require("libs/flux/flux")
export lovebird            = require("libs/lovebird/lovebird")
export Gamestate           = require("libs/hump/gamestate")
export Timer               = require("libs/hump/timer")
export Camera              = require("libs/STALKER-X/Camera")
export moonshine           = require("libs/moonshine")

export Object              = require("components/Object")
export Debugger            = require("modules/Debugger")
export Physics             = require("modules/Physics/Physics")
export PhysicsObject       = require("modules/Physics/PhysicsObject")
export PolygonPhysicsShape = require("modules/Physics/PolygonPhysicsShape")
export CirclePhysicsShape  = require("modules/Physics/CirclePhysicsShape")

export Entity              = require("components/Entity")
export Ship                = require("components/Ship")
export Player              = require("components/Player")

-- export SPFX        = require("modules/SPFX")
-- export Background  = require("modules/Background")
-- export Particle    = require("modules/Particle")
-- export Text        = require("modules/Text")

love.load = () ->
  Debugger.load()
  Physics.load()
  Player(100, 100)

love.update = (dt) ->
  for k, object in pairs(lssx.objects) do
    object\update(dt)
  Timer.update(dt)
  Debugger.update(dt)
  Physics.update(dt)
  flux.update(dt)

love.draw = () ->
  for k, object in pairs(lssx.objects) do
    object\draw()

  Debugger.draw()

love.keypressed = (key) ->
  fluids.keypressed(key)
  Debugger.keypressed(key)
  for _, object in pairs(lssx.objects)
    if type(object.keypressed) == "function"
      object\keypressed(key)

love.keyreleased = (key) ->
  fluids.keyreleased(key)

love.mousemoved = (x, y) ->
  fluids.mousemoved(x, y)

love.mousepressed = (x, y, button) ->
  fluids.mousepressed(button)

love.mousereleased = (x, y, button) ->
  fluids.mousereleased(button)

love.wheelmoved = (x, y) ->
  fluids.wheelmoved(x, y)

love.textinput = (t) ->
  fluids.textinput(t)

love.quit = () ->
  fluids.Quit()

-- FIXED TIMESTEP ============================================]]
love.run = () ->
  if love.math then love.math.setRandomSeed(os.time())
  if love.load then love.load(arg)
  if love.timer then love.timer.step()

  dt = 0
  fixed_dt = 1/60
  accumulator = 0

  while true
    if love.event
      love.event.pump()
      for name, a, b, c, d, e, f in love.event.poll() do
        if name == "quit"
          if not love.quit or not love.quit()
            return a
        love.handlers[name](a, b, c, d, e, f)

    if love.timer
      love.timer.step()
      dt = love.timer.getDelta()

    accumulator += dt
    while accumulator >= fixed_dt do
      if love.update then love.update(fixed_dt)
      accumulator -= fixed_dt

    if love.graphics and love.graphics.isActive()
      love.graphics.clear(love.graphics.getBackgroundColor())
      love.graphics.origin()
      if love.draw then love.draw()
      love.graphics.present()

    if love.timer then love.timer.sleep(0.0001)