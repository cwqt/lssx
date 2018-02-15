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
  Director.results.strings = {
    "A critical system error has occured.  ",
    "TIME SURVIVED : " .. math.floor(love.timer.getTime()-lssx.INIT_TIME, 3) ..  " sec",
    "SOVIETS KIA   : " .. "19",
    "SCORE         : " .. lssx.SCORE,
    "RANKING       : " .. "SS",
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

Director.keypressed = (key) ->
  -- if Director.canRestart and key == ("kpenter" or "return")

Director.spawnEnemies = (x, y, count) ->

return Director