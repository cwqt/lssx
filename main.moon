io.stdout\setvbuf("no")
require("moonscript")
require("imgui")

export fluids              = require("libs/fluids")
export flux                = require("libs/flux/flux")
export lovebird            = require("libs/lovebird/lovebird")
export Gamestate           = require("libs/hump/gamestate")
export Timer               = require("libs/hump/timer")
export Camera              = require("libs/STALKER-X/Camera")
export moonshine           = require("libs/moonshine")
require("lssx")

export Object              = require("components/Object")
export Debugger            = require("modules/Debugger")
export Physics             = require("modules/Physics/Physics")
export PhysicsObject       = require("modules/Physics/PhysicsObject")
export PolygonPhysicsShape = require("modules/Physics/PolygonPhysicsShape")
export CirclePhysicsShape  = require("modules/Physics/CirclePhysicsShape")
export CameraManager       = require("modules/CameraManager")
export Background          = require("modules/Background")
export Particle            = require("modules/Particle")
export SPFX                = require("modules/SPFX")
export EntityManager       = require("modules/EntityManager")

export Entity              = require("components/Entity")
export Ship                = require("components/Ship")
export Player              = require("components/Player")
export Asteroid            = require("components/Asteroid")
export Projectile          = require("components/Projectile")
export Bullet              = require("components/Bullet")
export Emitter             = require("components/Emitter")
export Shield              = require("components/Shield")

-- ============================================================]]
Splash = {}

Splash\init()

Splash\update(dt) ->

Splash\draw() ->

Splash\leave() ->
-- ============================================================]]
MainMenu = {}

MainMenu\init() ->

MainMenu\enter(previous) ->

MainMenu\update(dt) ->

MainMenu\draw() ->

MainMenu\leave() ->
-- ============================================================]]
Game = {}

Game\init() ->
  Physics.load()
  Background.load()
  CameraManager.load(10, 10)

Game\enter(previous) ->
  EntityManager.clear()
  Player(Ship(lssx.world, 10, 10, "dynamic"), 10, "Player")
  CameraManager.setLockTarget(lssx.objects["Player"])
  for i=1, 100 do
    Asteroid(math.random(love.graphics.getWidth()), love.graphics.getHeight())

Game\update(dt) ->
  Physics.update(dt)
  EntityManager.update(dt)
  CameraManager.update(dt)

Game\draw() ->
  CameraManager.attach()
  Background.draw()
  love.graphics.setColor(255,255,255)
  EntityManager.draw()
  CameraManager.detach()

Game\keypressed(key) ->
  EntityManager.keypressed(key)

Game\leave() ->
-- ============================================================]]

love.load = () ->
  Debugger.load()
  Gamestate.registerEvents()
  Gamestate.switch(Game)

love.update = (dt) ->
  Timer.update(dt)
  Debugger.update(dt)
  flux.update(dt)

love.draw = () ->
  Debugger.draw()

love.keypressed = (key) ->
  fluids.keypressed(key)
  Debugger.keypressed(key)

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

math.dist = (x1,y1, x2,y2) -> return (((x2)-(x1))^2+((y2)-(y1))^2)^0.5
math.clamp = (low, n, high) -> return math.min(math.max(n, low), high)
