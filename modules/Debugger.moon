Debugger = {}
dbg = {}
dbg.print = {}
dbg.start = love.timer.getTime()
dbg.currentCommand = ""

Debugger.load = () ->
  for i=1, 10 do print ""
  print "Game started"
  theme = {{"WindowRounding", 0}}
  fluids.ApplyTheme(theme)

  -- love.profiler = require('../libs/profile')
  -- love.profiler.hookall("Lua")
  -- love.frame = 0

  --Set up a function to updated love.profiler
  --Run it first time
  -- collectNewReport = () ->
  --   love.report = love.profiler.report('time', 9)
  --   love.profiler.reset()

  -- Timer.every(1, -> collectNewReport())

  -- profileData = () ->
  --   if not debugging
  --     imgui.Text("Not updating...")
  --   imgui.Text(love.report or "Please wait...")
  -- profiler = fluids.Window("profiler", profileData, {0, love.graphics.getHeight()-200, love.graphics.getWidth(), 200}, {"NoTitleBar"})

  console = () ->
    dbg.consoleEntered, dbg.currentCommand = imgui.InputText("", dbg.currentCommand, 200, {"EnterReturnsTrue"})
    imgui.SetKeyboardFocusHere(-1)
    imgui.SameLine()
    imgui.Text("FPS " .. love.timer.getFPS())
    imgui.Separator()
    if dbg.consoleEntered
      switch dbg.currentCommand
        when "quit"
          love.event.quit()
        when "clear"
          dbg.print = {}
        when "profiler"
          debugging = not debugging
        else
          Debugger.log(dbg.currentCommand, "stdin")
          Debugger.execute(dbg.currentCommand)
      dbg.currentCommand = ""
    imgui.BeginChild(1,imgui.GetWindowWidth(),imgui.GetWindowHeight()-60)
    for k, value in pairs(dbg.print) do
      if value[2] ~= nil
        imgui.TextColorHex(value[2], value[1])
      else
        imgui.Text(value[1])
    imgui.SetScrollHere()
    imgui.EndChild()

  fluids.Window("Console", console, {love.graphics.getWidth()-400, 0, 400, love.graphics.getHeight()-200})

Debugger.update = (dt) ->
  lovebird.update()
  if #dbg.print > 50
    table.remove(dbg.print, 1)

Debugger.draw = () ->
  fluids.Update(dt)
  fluids.Draw()

Debugger.keypressed = (key) ->
  if key == "`"
    debugging = not debugging

Debugger.log = (msg, classification) ->
  if classification == nil
    classification == "none"
  switch classification
    when "error"
      export color = "ff6961"
    when "spawn"
      export color = "6666ff"
    when "stdout"
      export color = "FFA500"
    when "stdin"
      export color = "ffd27f"
    when "death"
      export color = "ff3232"
    when "inherit"
      export color = "46df46"
    else
      classification = "game"

  time = love.timer.getTime() - dbg.start
  classification = string.sub(classification .. "        ", 1, 7)
  time = string.sub(time .. "           ", 1, 5).. "s"
  string = "[" .. tostring(classification) .. "] " .. time .. ": " .. msg
  table.insert(dbg.print, {string, color})
  export color = nil

Debugger.execute = (command) ->
  -- Capture stdout + stderr
  file = assert(io.popen(command .. " 2>&1", "r"))
  output = file\read('*all')
  file\close()
  output = string.gsub(tostring(output), "sh: 1: ", "")
  Debugger.log(output, "stdout")

imgui.TextColorHex = (hex, value) ->
  r, g, b = tonumber("0x"..hex\sub(1,2)), tonumber("0x"..hex\sub(3,4)), tonumber("0x"..hex\sub(5,6))
  imgui.TextColored((r*1/255), (g*1/255), (b*1/255), 1, value)

return Debugger