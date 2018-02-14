Debugger = {}
dbg = {}
dbg.start = love.timer.getTime()

Debugger.load = () ->
  os.execute("rm log.txt")
  os.execute("touch log.txt")

Debugger.update = (dt) ->
  lovebird.update(dt)

Debugger.draw = () ->

Debugger.log = (message, genre) ->
  genre = genre or "game"
  time = love.timer.getTime()-dbg.start
  time = string.sub(time .. "           ", 1, 5).. "s "
  str = time .. "[" .. tostring(genre .. string.rep(" ", 10-#genre)) .. "] " .. message
  print(str)
  -- os.execute("echo '" .. str .. "' >> log.txt")

Debugger.keypressed = () ->

return Debugger