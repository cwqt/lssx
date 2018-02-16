Director = {}

Director.load = () ->
  Director.results = {
    result: ""
    typeTimer: 0.8
    k: 1
    canRestart: false
  }

Director.update = (dt) ->

  if lssx.PLAYER_DEAD
    Director.getStats()
    if #Director.results.strings != Director.results.k
      Director.results.typeTimer -= dt
      if Director.results.typeTimer <= 0
        Director.results.typeTimer = 0.2
        Director.results.result = Director.results.result .. "\n" .. Director.results.strings[Director.results.k]
        Director.results.k += 1
    else
      Director.canRestart = true
  else --player alive
    lssx.SCORE = lssx.SCORE + 1

Director.draw = () ->
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
  lssx.SCORE = lssx.SCORE + (lssx.KILLS*500)
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
  if lssx.SCORE > 20000
    rank = "SS"
  elseif lssx.SCORE > 15000
    rank = "S"
  elseif lssx.SCORE > 10000
    rank = "A"
  elseif lssx.SCORE > 75000
    rank = "B"
  elseif lssx.SCORE > 5000
    rank = "C"
  elseif lssx.SCORE > 2500
    rank = "D"
  elseif lssx.SCORE > 1000
    rank = "E"
  else
    rank = "F"
  return rank

Director.keypressed = (key) ->
  -- if Director.canRestart and key == ("kpenter" or "return")

Director.spawnEnemies = (x, y, count) ->

return Director