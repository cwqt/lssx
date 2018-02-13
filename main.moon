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
export splashy             = require("libs/splashy/splashy")
require("lssx")

export Object              = require("components/Object")
export Debugger            = require("modules/Debugger")
export Physics             = require("modules/Physics/Physics")
export PhysicsObject       = require("modules/Physics/PhysicsObject")
export PolygonPhysicsShape = require("modules/Physics/PolygonPhysicsShape")
export CirclePhysicsShape  = require("modules/Physics/CirclePhysicsShape")
export Background          = require("modules/Background")
export Particle            = require("modules/Particle")
export SPFX                = require("modules/SPFX")

export CameraManager       = require("modules/CameraManager")
export EntityManager       = require("modules/EntityManager")
export SoundManager        = require("modules/SoundManager")

-- export HUD                 = require("modules/UI/HUD")

export Entity              = require("components/Entity")
export Ship                = require("components/Ship")
export Player              = require("components/Player")
export Asteroid            = require("components/Asteroid")
export Projectile          = require("components/Projectile")
export Bullet              = require("components/Bullet")
export Emitter             = require("components/Emitter")
export Shield              = require("components/Shield")
export Enemy               = require("components/Enemy")

Game = {}

Game.init = () =>
  Physics.load()
  Background.load()
  SPFX.load()
  CameraManager.load(10, 10)

Game.enter = (previous) =>
  EntityManager.clear()
  Player(Ship(lssx.world, 10, 10, "dynamic"), 10, "Player")
  CameraManager.setLockTarget(lssx.objects["Player"])
  -- for i=1, 200
    -- Asteroid(math.random(2000), math.random(2000))
  -- for i=1, 20 do
    -- Enemy(Ship(lssx.world, math.random(2000), math.random(2000), "dynamic"), 10)  
  
  Enemy(Ship(lssx.world, 10, 10, "dynamic"), 10)

Game.update = (dt) =>
  if lssx.PAUSE then return
  Physics.update(dt)
  EntityManager.update(dt)
  SPFX.update(dt)
  CameraManager.update(dt)

Game.draw = () =>
  love.graphics.setLineStyle("smooth")
  SPFX.effect ->
    CameraManager.attach()
    Background.draw()
    love.graphics.setColor(255,255,255)
    EntityManager.draw()
    CameraManager.detach()
  Debugger.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

Game.keypressed = (key) =>
  EntityManager.keypressed(key)

Game.leave = () =>
  EntityManager.clear()
  print("Later alligator")

-- ============================================================]]

-- ============================================================]]

MainMenu = {}

MainMenu.init = () =>

MainMenu.enter = (previous) =>
  SPFX.load()
  export title = {
    font: love.graphics.newFont("assets/MainMenu/title.ttf", 50)
    textToPrint: "LSSX v2.8_a3 BIOS",
    printedText: "",
    
    typeTimer: 0.1,
    typePosition: -1,
  }
  title.font\setLineHeight(1)

  export text = {
    print: false,
    font: love.graphics.newFont("assets/MainMenu/text.ttf", 22),
    k: 1,
    printedText: "",
    content: {
      {"COMPILED 25 OCT 1962.   CCAFS", 0.8}
      {"DO NOT REDISTRIBUTE.", 0.8}
      {""}
      {"TOTAL REAL MEMORY: 7808bytes.", 0.5}
      {"BUFFER SPACE USED:  600bytes (150 4b buffers)", 0.7}
      {"AVAILABLE  MEMORY: 6552bytes", 0.5}
      {""}
      {"C000              ORG   ROM+$0000 BEGIN MONITOR"}
      {"C001 8E  70 START LDS   #STACK"}
      {""}
      {"     *************************************"}
      {"     * FUNCTION: INITA_Initialise ACIA    "}
      {"     * INPUT:    STDIN                    "}
      {"     * OUTPUT:   NONE                     "}
      {"     * CALLS:    Boot_Process.MASTER      "}
      {"     * DESTROYS: NONE                     "}
      {"     *                                    "}
      {"     * Engaging Core Modules [0x0->0xFD03]"}
      {""}
      {""}
      {"COOA B7  80       STA A ACIA   ;SET BITS 2, 4 STOP "}
      {"C00D 73  C0       JMP   SIGNON ;GO TO BOOT START"}
      {""}
      {"     STDOUT:: 'ENABLING MODULES'", 1}
      {"     STDOUT:: 'ARPANET(beta) ONLINE'", 1}
      {"     STDOUT:: 'ACK RECIEVED...'", 1}
      {"     STDIN :: 'M9 86 D0 7S 96 D0 2D 97 00 28 D7 B7'", 1}
      {""}
      {"CHECKSUM ACCEPTED", 2}
      {""}
      {"Welcome to lssxOS."}
      {"Enter 'help' for more information."}
      {""}
      {"root/> ./zephyr"}
      {""}--keep because bug
    }
  }
  text.font\setLineHeight(0.6)
  Timer.after 0.2, -> SPFX.bounceChroma(0.2, 6)
  Timer.after 6, -> SPFX.bounceChroma(2, 2, 2)

MainMenu.update = (dt) =>
  SPFX.update(dt)
  -- Decrease timer
  title.typeTimer = title.typeTimer - dt

  -- Timer done, we need to print a new letter:
  -- Adjust position, use string.sub to get sub-string
  if title.typePosition <= string.len(title.textToPrint) then
    title.typeTimer = title.typeTimer - dt
    if title.typeTimer <= 0 then
      title.typeTimer = 0.1
      title.typePosition = title.typePosition + 1
      title.printedText = string.sub(title.textToPrint,0,title.typePosition)
  else
    -- Same concept as above, except priting whole lines via concatenation
    if #text.content != text.k
      title.typeTimer -= dt
      if title.typeTimer <= 0
        title.typeTimer = text.content[text.k][2] or 0.1
        text.printedText = text.printedText .. "\n" .. text.content[text.k][1]
        text.k += 1
    -- else -- done

MainMenu.draw = () =>
  SPFX.effect ->
    love.graphics.setFont(title.font)
    love.graphics.print(title.printedText, 40, 40)
    love.graphics.setFont(text.font)
    love.graphics.print(text.printedText, 40, 100)

MainMenu.leave = () =>
  title = nil
  text = nil

MainMenu.keypressed = (key) =>
  if key == "r" then MainMenu.enter()
  if key == "s" then Gamestate.switch(Game)

-- ============================================================]]

export Splash = {}

Splash.init = () =>
  export config = {
    image: love.graphics.newImage("assets/Splash/Logo.png")
    h: love.graphics.getHeight()
  }
  splashy.addSplash(config.image, 2)
  splashy.onComplete(-> Gamestate.switch(MainMenu))
  SPFX.load()
  Timer.after 0.2, -> SPFX.bounceChroma(2, 3, 2)

Splash.update = (dt) =>
  SPFX.update(dt)
  splashy.update(dt)

Splash.draw = () =>
  SPFX.effect ->
    splashy.draw()
    -- love.graphics.print("Press 'space' to skip.", 10, config.h-20)

Splash.keypressed = (key) =>
  if key == "space"
    splashy.skipAll()

Splash.leave = () =>
  config = nil

-- ============================================================]]

love.load = () ->
  -- Debugger.load()
  -- bgm = love.audio.newSource("assets/Boot.ogg", "stream")
  -- love.audio.play(bgm)
  Timer.after 1.5, ->
    Gamestate.registerEvents()
    -- Gamestate.switch(Splash)
  -- Gamestate.switch(MainMenu)
  Gamestate.switch(Game)

love.update = (dt) ->
  Timer.update(dt)
  -- Debugger.update(dt)
  flux.update(dt)
  require("libs/lovebird/lovebird").update()

love.draw = () ->
  -- Debugger.draw()

love.keypressed = (key) ->
  fluids.keypressed(key)
  Debugger.keypressed(key)
  if key == "p"
    lssx.PAUSE = not lssx.PAUSE

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
