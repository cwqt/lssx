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

export Entity              = require("components/Entity")
export Ship                = require("components/Ship")
export Player              = require("components/Player")
export Asteroid            = require("components/Asteroid")
export Projectile          = require("components/Projectile")
export Bullet              = require("components/Bullet")
export Emitter             = require("components/Emitter")
export Shield              = require("components/Shield")
export Enemy               = require("components/Enemy")

love.load = () ->
  Debugger.load()
  Physics.load()
  Background.load()
  SPFX.load()
  Player(Ship(lssx.world, 10, 10, "dynamic"), 10, "Player")
  CameraManager.load(130, 100)
  CameraManager.setLockTarget(lssx.objects["Player"])

  Enemy(Ship(lssx.world, 10, 10, "dynamic"), 10)

  for i=1, 100
    Asteroid(math.random(2000), math.random(2000))
  Emitter(10, 20)

love.update = (dt) ->
  for k, object in pairs(lssx.objects) do
    object\update(dt)
  Timer.update(dt)
  Debugger.update(dt)
  Physics.update(dt)
  CameraManager.update(dt)
  SPFX.update(dt)
  flux.update(dt)

love.draw = () ->
  SPFX.effect ->
    CameraManager.attach()
    Background.draw()
    love.graphics.setColor(255,255,255)
    for k, object in pairs(lssx.objects) do
      object\draw()
    CameraManager.detach()

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

math.dist = (x1,y1, x2,y2) -> return (((x2)-(x1))^2+((y2)-(y1))^2)^0.5
math.clamp = (low, n, high) -> return math.min(math.max(n, low), high)


HSL = (h, s, l, a) ->
  if s<=0 
    return l,l,l,a
  h, s, l = h/256*6, s/255, l/255
  c = (1-math.abs(2*l-1))*s
  x = (1-math.abs(h%2-1))*c
  m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  return (r+m)*255,(g+m)*255,(b+m)*255,a
