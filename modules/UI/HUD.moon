HUD = {}
px, py = love.window.getMode()
wx, wy = px, py
px = px/8
py = py/8
HUD.elements = {}
HUD.elements.crosses = {
  Cross(px, py)
  Cross(wx-px, py)
  Cross(wx-px, wy-py)
  Cross(px, wy-py)

  Cross(px+((wx-2*px)/2), py)
  Cross(px+((wx-2*px)/2), wy-py)
  Cross(px, py+((wy-2*py)/2))  
  Cross(wx-px, py+((wy-2*py)/2))  
}

HUD.load = (player) ->
  HUD.camera = Camera()
  HUD.camera\setFollowStyle('NO_DEADZONE')

  HUD.player = player
  HUD.hash   = player.hash
  HUD.elements.active = {}
  HUD.elements.bar(0,   0, HUD.player, "HP",     {0,255,0},   {102,204,0})
  HUD.elements.bar(150,   0, HUD.player, "slomo", {255,255,255}, {230, 230, 230})
  HUD.elements.bar(300, 0, HUD.player, "ammo",   {255,0,0},   {204,0,0})
  HUD.elements.bar(450, 0, HUD.player, "oxygen", {0,0,255},   {102,0,255})
  HUD.elements.bar(600, 0, HUD.player, "fuel",   {255,255,0}, {255,255,255})
  HUD.elements.Killstreak(-335, 0)

  HUD.startTimer = HUD.elements.timer(love.graphics.getWidth()/2-40, love.graphics.getHeight()/4+120, 80, 10, 8)

HUD.update = (dt) ->
  for k, element in pairs(HUD.elements.active) do
    element\update(dt)

  if lssx.objects[HUD.hash] == nil then return
  x, y = HUD.player.ship.body\getLinearVelocity()
  HUD.camera\follow(love.graphics.getWidth()/2+x/15, love.graphics.getHeight()/2+y/15)
  HUD.camera\update(dt)

HUD.draw = () ->
  HUD.camera\attach()
  HUD.startTimer\draw()
  
  love.graphics.setLineWidth(0.2)
  love.graphics.setColor(255,255,255,100)
  love.graphics.line(px,py, wx-px,py, wx-px,wy-py, px,wy-py, px,py)
  -- love.graphics.line(40, 40, 1060, 40, 1060, 560, 40, 560, 40, 40)
  love.graphics.setLineWidth(2)
  for k, cross in pairs(HUD.elements.crosses) do cross\draw()

  love.graphics.setLineWidth(1)

  love.graphics.setColor(255,255,255)
  love.graphics.print(
    "SCORE: " .. lssx.SCORE .. "\n" .. 
    "KILLS: " .. lssx.KILLS
    px+15, py+15)

  love.graphics.push()
  love.graphics.translate(px+((wx-2*px)/2)-350, wy-py*1.5)
  for k, element in pairs(HUD.elements.active) do
    element\draw()
  love.graphics.pop()
  love.graphics.setColor(255,255,255)

  HUD.camera\detach()
  HUD.camera\draw()

HUD.shake = (intensity, duration, frequency) ->
  frequency = frequency or 60
  HUD.camera\shake(intensity, duration, frequency)

class HUD.elements.timer 
  new: (@x, @y, @w, @h, @t) =>
    @wi = @w
    @o = 255
    flux.to(@, @t, {w: 0})\ease("linear")
    Timer.after @t, ->
      flux.to(@, 0.5, {o: 0})

  update: (dt) =>

  draw: () =>
    love.graphics.setColor(255,255,255,@o)
    love.graphics.rectangle("line", @x, @y, @wi, @h)
    love.graphics.rectangle("fill", @x, @y, @w, @h)
    love.graphics.setColor(255,255,255,255)

class HUD.elements.bar
  new: (@x, @y, @pointer, @value, @color, @bgcolor) =>
    @config = {
      boxW: 100
      originalV: @pointer[@value]
      currentV: @pointer[@value]
      oldV: @pointer[@value]
      lagV: @pointer[@value]
      text: {}
    }
    @config.text.h = lssx.TEXTF\getHeight()
    table.insert(HUD.elements.active, self)

  update: (dt) =>
    if @pointer[@value] != @config.oldV
      @config.oldV = @config.currentV
      flux.to(@config, 0.2, {currentV: @pointer[@value]})
      flux.to(@config, 0.5, {lagV: @pointer[@value]})\delay(0.1)

  draw: () =>
    if @config.currentV <= @config.originalV*0.4 and (@value == "HP") --bleeeehh
      lssx.camera\shake(1, 0.1)
      HUD.shake(1, 0.1)
      lssx.SPFX.CHROMASEP = math.random(10)
      love.graphics.setColor(255,0,0)
      love.graphics.setFont(lssx.TITLEF)
      love.graphics.print("SYSTEM CRITICAL", -1.25*px, -5.25*py)
      love.graphics.setFont(lssx.TEXTF)
      love.graphics.setColor(255,255,255)
      love.graphics.print("CODE 102: LOW " .. string.upper(@value), -1.25*px, -5.25*py+60)

    love.graphics.setFont(lssx.TEXTF)
    love.graphics.setColor(unpack(@bgcolor))
    love.graphics.rectangle("fill", @x, @y, (@config.boxW/@config.originalV)*@config.lagV, 10)
    love.graphics.setColor(unpack(@color))
    love.graphics.rectangle("fill", @x, @y, (@config.boxW/@config.originalV)*@config.currentV, 10)

    love.graphics.printf(math.floor(@config.currentV).."/"..@config.originalV, @x, @y-@config.text.h, @config.boxW, "center")
    love.graphics.printf(string.upper(@value), @x, @y+@config.text.h-15, @config.boxW, "center")

    love.graphics.rectangle("line", @x, @y, @config.boxW, 10)

class HUD.elements.Killstreak
  new: (@x, @y) =>
    @s = ""
    table.insert(HUD.elements.active, self)
    @y = -100
    @done = false
    @done2 = false
    @oldKills = 0

  appear: (n) =>
    @oldKills = n
    @y = -180
    @s = n .. " KILLS"
    Timer.after 0.5, ->
      SoundManager.playRandom("Killstreak", 1)
      lssx.SLOW_MO = true
      flux.to(@, 1, {y: wy/2-50})\ease("cubicout")\oncomplete(-> lssx.SLO_MO = false)\after(@, 0.2, {y: wy})\oncomplete(->
        @y=-180
        lssx.SLOW_MO = false)

  update: (dt) =>
    -- :nauseated:
    if lssx.KILLS > 0
      if lssx.KILLS < 11 --first 10 kills
        if (lssx.KILLS % 10) == 0 and not @done
          @appear(10)
          @done = true
      elseif lssx.KILLS < 26 -- first 25
        if (lssx.KILLS % 25) == 0 and not @done2
          @appear(25)
          @done2 = true
      else -- then every 50
        if (lssx.KILLS % 50) == 0 and (lssx.KILLS != @oldKills)
          @appear(lssx.KILLS)

  draw: () =>
    love.graphics.push()
    love.graphics.translate(@x, @y-(wy-py*1.5))
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill", 0,0, wx, 100)

    love.graphics.setColor(255,230,255,255)
    love.graphics.setFont(lssx.TITLEF)
    love.graphics.print(@s, wx/2-lssx.TITLEF\getWidth(@s)/2, 50-lssx.TITLEF\getHeight(@s)/2)
    love.graphics.pop()
    love.graphics.setFont(lssx.TEXTF)

return HUD