Director = {}

Director.load = () ->
  Director.results = {
    result: ""
    typeTimer: 0.8
    k: 1
    canRestart: false
  }

Director.gameStart = () ->
  EntityManager.clear()
  SoundManager.playLooping("DONBOR.ogg")
  TEsound.pitch("music", 1)
  TEsound.pitch("alarm", 1)
  ChainPhysicsShape({0,0,2000,0,2000,2000,0,2000}, 1, lssx.world, 0, 0, "static")

  Player(Ship(lssx.world, 1000, 1000, "dynamic"), 20, "Player")

  CameraManager.setLockTarget(lssx.objects["Player"])
  HUD.load(lssx.objects["Player"])

  lssx.PLAYER_DEAD = false
  lssx.SCORE = 0
  lssx.KILLS = 0

  for i=1, 50
    Asteroid(100+math.random(1800), 100+math.random(1800))
  for i=1, 10 do 
    Pickup(math.random(2000), math.random(2000))

  if lssx.FIRST_TIME 
    lssx.SHOW_INSTRUCTIONS = true
  Timer.after 8, ->  
    lssx.SHOW_INSTRUCTIONS = false
    for i=1, 1 do
      Enemy(Ship(lssx.world, math.random(2000), math.random(2000), "dynamic"), 10) 

    Timer.every 0.5, ->
      Enemy(Ship(lssx.world, math.random(2000), math.random(2000), "dynamic"), 10) 
    
    Timer.every 2, ->
      Pickup(math.random(2000), math.random(2000))
      Asteroid(100+math.random(1800), 100+math.random(1800))

Director.update = (dt) ->

  if lssx.PLAYER_DEAD
    Director.getStats()
    if #Director.results.strings != Director.results.k
      Director.results.typeTimer -= dt
      if Director.results.typeTimer <= 0
        Director.results.typeTimer = 0.1
        Director.results.result = Director.results.result .. "\n" .. Director.results.strings[Director.results.k]
        Director.results.k += 1
    else
      Director.canRestart = true
  else --player alive
    lssx.SCORE = lssx.SCORE + 1

Director.draw = () ->
  if lssx.SHOW_INSTRUCTIONS
    love.graphics.printf("'MOUSE' TO MOVE \n 'F' TO FIRE \n 'W' TO BOOST \n\n MOVE OR DIE. \n GOODLUCK PILOT.", 0, 100, 1100, "center")
  if lssx.PLAYER_DEAD
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill",0,0,1150,600)
    love.graphics.setFont(lssx.TITLEF)
    love.graphics.setColor(255,0,0)
    love.graphics.print("HCF - 0x9D", 350, 200)
    lssx.TEXTF\setLineHeight(0.9)
    love.graphics.setFont(lssx.TEXTF)
    love.graphics.setColor(255,255,255)
    love.graphics.print(Director.results.result, 350, 230)
    love.graphics.setColor(255,0,0)
    lssx.TEXTF\setLineHeight(1)

Director.getStats = () ->
  if Director.results.canUpdateStats == false then return
  lssx.SCORE = lssx.SCORE + (lssx.KILLS*1000)
  Director.results.strings = {
    "A critical system error has occured.  ",
    "TIME SURVIVED : " .. tostring(math.floor(love.timer.getTime()-lssx.INIT_TIME, 3)*(10^(2)+0.5)/10^(2)) ..  " sec",
    "SOVIETS KIA   : " .. lssx.KILLS,
    "SCORE         : " .. lssx.SCORE,
    "RANKING       : " .. Director.calculateRank(),
    ""
    "* STACKTRACE: L.0xC0"
    "*   0x83F800  cmp eax, 0"
    "*   0x09C0    or  eax, eax"
    "*   0x85C0    HP  eax, eax ;GGWP"
    ""
    "Press 'Enter' to recover."
    ""
  }
  Director.results.canUpdateStats = false

Director.calculateRank = () ->
  rank = ""
  if lssx.SCORE > 200000
    rank = "ACE"
  elseif lssx.SCORE > 200000
    rank = "SS"
  elseif lssx.SCORE > 150000
    rank = "S"
  elseif lssx.SCORE > 100000
    rank = "A"
  elseif lssx.SCORE > 750000
    rank = "B"
  elseif lssx.SCORE > 50000
    rank = "C"
  elseif lssx.SCORE > 25000
    rank = "D"
  elseif lssx.SCORE > 10000
    rank = "E"
  else
    rank = "F"
  return rank

Director.keypressed = (key) ->
  if Director.canRestart and key == ("kpenter" or "return")
    -- love.event.quit( "restart" )
    Gamestate.switch(Reset)

  if key == "v"
    for i=1, 10
      LineExplosion(math.random(-100, 100)+1100, math.random(-100, 100)+1000, math.random(10)+4)  

Director.spawnEnemies = (x, y, count) ->

return Director