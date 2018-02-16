-- lssx
-- twentytwoo 2017/18

io.stdout\setvbuf("no")
math.randomseed(os.time())
require("moonscript")

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
export ChainPhysicsShape   = require("modules/Physics/ChainPhysicsShape")
export Background          = require("modules/Background")
export Particle            = require("modules/Particle")
export SPFX                = require("modules/SPFX")
export Director            = require("modules/Director")

export CameraManager       = require("modules/CameraManager")
export EntityManager       = require("modules/EntityManager")
export SoundManager        = require("modules/SoundManager")

export Cross               = require("modules/UI/Cross")
export HUD                 = require("modules/UI/HUD")
export FlashSq             = require("modules/UI/FlashSq")

export Entity              = require("components/Entity")
export Ship                = require("components/Ship")
export Player              = require("components/Player")
export Asteroid            = require("components/Asteroid")
export Projectile          = require("components/Projectile")
export Bullet              = require("components/Bullet")
export Shield              = require("components/Shield")
export Enemy               = require("components/Enemy")

-- ============================================================]]

Game = {}

Game.init = () =>
  Physics.load()
  Background.load()
  -- SPFX.load()
  CameraManager.load(1000, 1000)

Game.enter = (previous) =>
  love.graphics.setLineStyle("smooth")
  love.graphics.setDefaultFilter("nearest","nearest")
  EntityManager.clear()
  Player(Ship(lssx.world, 1000, 1000, "dynamic"), 10, "Player")

  CameraManager.setLockTarget(lssx.objects["Player"])
  HUD.load(lssx.objects["Player"])
  Director.load()

  ChainPhysicsShape({0,0,2000,0,2000,2000,0,2000}, 1, lssx.world, 0, 0, "static")

  for i=1, 100
    Asteroid(100+math.random(1800), 100+math.random(1800))
  for i=1, 10 do
    Enemy(Ship(lssx.world, math.random(2000), math.random(2000), "dynamic"), 10)  
  -- Enemy(Ship(lssx.world, 900, 1000, "dynamic"), 10)  
 
Game.update = (dt) =>
  if lssx.PAUSE then return
  Physics.update(dt)
  EntityManager.update(dt)
  CameraManager.update(dt)
  HUD.update(dt)
  Director.update(dt)

Game.draw = () =>
  SPFX.effect ->
    CameraManager.attach()
    Background.draw()
    EntityManager.draw()
    CameraManager.detach()
    HUD.draw()
    Director.draw()

  love.graphics.setFont(lssx.TEXTF)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)

Game.keypressed = (key) =>
  EntityManager.keypressed(key)
  Director.keypressed(key)

Game.leave = () =>
  EntityManager.clear()
  print("Later alligator")

-- ============================================================]]

MainMenu = {}

MainMenu.init = () =>

MainMenu.enter = (previous) =>
  export title = {
    font: love.graphics.newFont("assets/MainMenu/title.ttf", 50)
    textToPrint: "LSSX v2.8_a3 BIOS",
    printedText: "",
    
    typeTimer: 0.1,
    typePosition: -1,
  }
  title.font\setLineHeight(1)

  export text = {
    sound: love.audio.newSource("assets/MainMenu/typeSound.wav", "static")
    print: false,
    font: love.graphics.newFont("assets/MainMenu/text.ttf", 22),
    k: 1,
    printedText: "",
    content: {
      --{"some text", delay_time}
      {"", 2}
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
      {"     STDOUT:: 'CONNECTING AT 155.2.0.192.in-addr.arpa:2000'", 1}
      {"     STDOUT:: 'ARPANET(beta) ONLINE'", 1}
      {"     STDOUT:: 'ACK RECIEVED...'", 1}
      {"     STDIN :: 'M9 86 D0 7S 96 D0 2D 97 00 28 D7 B7'", 1}
      {"     STDIN :: 'CHECKING PARITY BITS'", 1.3}
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
  text.sound\setVolume(0.3)
  text.sound\setPitch(0.6)
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
      love.audio.play(text.sound)
  else
    -- Same concept as above, except printing whole lines via concatenation
    if #text.content != text.k
      title.typeTimer -= dt
      if title.typeTimer <= 0
        love.audio.stop(text.sound)
        title.typeTimer = text.content[text.k][2] or 0.1
        text.printedText = text.printedText .. "\n" .. text.content[text.k][1]
        love.audio.play(text.sound)
        text.k += 1
    else
      love.timer.sleep(1) --ehhhh
      Gamestate.switch(Game)

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
  if key == "space" then Gamestate.switch(Game)

-- ============================================================]]

export Splash = {}

Splash.init = () =>
  export config = {
    image: love.graphics.newImage("assets/Splash/Logo.png")
    h: love.graphics.getHeight()
  }
  splashy.addSplash(config.image, 2)
  splashy.onComplete(-> Gamestate.switch(MainMenu))
  Timer.after 0.2, -> SPFX.bounceChroma(2, 3, 2)

Splash.update = (dt) =>
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
  Debugger.load()
  SPFX.load() 
  -- bootSound = love.audio.newSource("assets/Boot.ogg", "stream")
  -- love.audio.play(bootSound)
  -- Timer.after 1.5, ->
  --   Gamestate.registerEvents()
  --   Gamestate.switch(Splash)

  Gamestate.registerEvents()
  Gamestate.switch(Game)

love.update = (dt) ->
  Timer.update(dt)
  SPFX.update(dt)
  flux.update(dt)
  Debugger.update(dt)

love.draw = () ->

love.keypressed = (key) ->
  Debugger.keypressed(key)
  if key == "p"
    lssx.PAUSE = not lssx.PAUSE

love.keyreleased = (key) ->

love.mousemoved = (x, y) ->

love.mousepressed = (x, y, button) ->

love.mousereleased = (x, y, button) ->

love.wheelmoved = (x, y) ->

love.textinput = (t) ->

love.quit = () ->

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

export UUID = () ->
  fn = (x) ->
    r = math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef")\sub(r, r)
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", fn))