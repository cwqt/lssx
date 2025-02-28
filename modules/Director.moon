Director = {}

Director.load = () ->
  Director.results = {
    result: ""
    typeTimer: 0.8
    k: 1
    canRestart: false
    canCount:   false
  }

Director.gameStart = () ->
  EntityManager.clear()
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
    Director.canCount = true
    SoundManager.playRandom("RoundStart", 1)
    lssx.SHOW_INSTRUCTIONS = false
    Timer.every 1, ->
      if not lssx.PLAYER_DEAD
        Pickup(100+math.random(1800), 100+math.random(1800))
    Timer.every 1.5, ->    
      if not lssx.PLAYER_DEAD
        -- probably should be changed to spawn more enemies when player has more kills
        -- side note: this is gross
        if lssx.KILLS > 400
          Director.spawnEnemies(7)
        elseif lssx.KILLS > 300
          Director.spawnEnemies(6)
        elseif lssx.KILLS > 200
          Director.spawnEnemies(5)
        elseif lssx.KILLS > 100
          Director.spawnEnemies(4)
        elseif lssx.KILLS > 50
          Director.spawnEnemies(3)
        elseif lssx.KILLS > 25
          Director.spawnEnemies(2)
        else
          Director.spawnEnemies(1)

    Timer.every 1.5, ->
      if not lssx.PLAYER_DEAD
        Asteroid(100+math.random(1700), 100+math.random(1700))

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
    if Director.canCount
      lssx.SCORE = lssx.SCORE + 1

Director.draw = () ->
  if lssx.SHOW_INSTRUCTIONS
    love.graphics.printf("'MOUSE' TO MOVE \n 'F' TO FIRE \n 'W' TO BOOST \n\n MOVE OR DIE. \n GOODLUCK PILOT.", 0, love.graphics.getHeight()/4-20, love.graphics.getWidth(), "center")
  if lssx.PLAYER_DEAD
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setFont(lssx.TITLEF)
    love.graphics.setColor(255,0,0)
    love.graphics.printf("HCF - 0x9D", 0, 200, love.graphics.getWidth(), "center")
    lssx.TEXTF\setLineHeight(0.9)
    love.graphics.setFont(lssx.TEXTF)
    love.graphics.setColor(255,255,255)
    love.graphics.print(Director.results.result, love.graphics.getWidth()/2-180, 230)
    love.graphics.setColor(255,0,0)
    lssx.TEXTF\setLineHeight(1)
  if lssx.PAUSE
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(lssx.TITLEF)
    love.graphics.printf("PAUSED", 0, love.graphics.getHeight()/2-100, love.graphics.getWidth(), "center")
    love.graphics.setFont(lssx.TEXTF)

Director.getStats = () ->
  if Director.results.canUpdateStats == false then return
  lssx.SCORE = lssx.SCORE + (lssx.KILLS*1000)
  Director.results.strings = {
    "A critical system error has occured.  ",
    "TIME SURVIVED : " .. tostring(math.floor(love.timer.getTime()-lssx.GAME_TIME, 3)*(10^(2)+0.5)/10^(2)) ..  " sec",
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
  do -- could possibly export to some file format
     -- for autistic stat tracking
    l = {
      ["date"]: os.date("%x/%X")
      ["time_survived"]: tostring(math.floor(love.timer.getTime()-lssx.GAME_TIME, 3)*(10^(2)+0.5)/10^(2))
      ["kills"]: lssx.KILLS
      ["score"]: lssx.SCORE
      ["rank"]: Director.calculateRank(),
    }
    t = ""
    y = ""
    for column, value in pairs(l)
      if lssx.FIRST_TIME
        t = t .. column .. " | "
      y = y .. value .. ","
    if lssx.FIRST_TIME 
      print(t)
    print(y\sub(1, -2))
  lssx.FIRST_TIME = false
  Director.results.canUpdateStats = false

Director.calculateRank = () ->
  rank = ""
  if lssx.SCORE > 1000000
    rank = "ACE"
  elseif lssx.SCORE > 500000
    rank = "SS"
  elseif lssx.SCORE > 250000
    rank = "S"
  elseif lssx.SCORE > 100000
    rank = "A"
  elseif lssx.SCORE > 75000
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
  if Director.canRestart and (key == "kpenter" or key == "return") and lssx.PLAYER_DEAD -- and lssx.PLAYER_DEAD, rm to show PG
    Gamestate.switch(Reset)

Director.spawnEnemies = (amount) ->
  for i=1, amount
    Enemy(Ship(lssx.world, math.random(2000), math.random(2000), "dynamic"), 10) 

return Director