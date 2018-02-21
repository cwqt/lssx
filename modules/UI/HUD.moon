HUD = {}
HUD.elements = {}
HUD.elements.active = {}
HUD.elements.crosses = {
  Cross(40, 30)
  Cross(1060, 30)
  Cross(1060, 550)
  Cross(40, 550)
  Cross(540, 30)
  Cross(1060, 300)
  Cross(540, 550)
  Cross(40, 300)
}

HUD.load = (player) ->
  HUD.camera = Camera()
  HUD.camera\setFollowStyle('NO_DEADZONE')

  HUD.player = player
  HUD.hash   = player.hash
  HUD.elements.bar(0,   lssx.W_HEIGHT-80, HUD.player, "HP",     {0,255,0},   {102,204,0})
  HUD.elements.bar(150, lssx.W_HEIGHT-80, HUD.player, "ammo",   {255,0,0},   {204,0,0})
  HUD.elements.bar(300, lssx.W_HEIGHT-80, HUD.player, "oxygen", {0,0,255},   {102,0,255})
  HUD.elements.bar(450, lssx.W_HEIGHT-80, HUD.player, "fuel",   {255,255,0}, {255,255,255})

HUD.update = (dt) ->
  for k, element in pairs(HUD.elements.active) do
    element\update(dt)

  if lssx.objects[HUD.hash] == nil then return
  x, y = HUD.player.ship.body\getLinearVelocity()
  HUD.camera\follow(550+x/15, 300+y/15)
  HUD.camera\update(dt)

HUD.draw = () ->
  HUD.camera\attach()
  
  love.graphics.setLineWidth(0.2)
  love.graphics.setColor(255,255,255,100)
  love.graphics.line(40, 40, 1060, 40, 1060, 560, 40, 560, 40, 40)
  love.graphics.setLineWidth(2)
  for k, cross in pairs(HUD.elements.crosses) do cross\draw()

  love.graphics.setLineWidth(1)

  love.graphics.setColor(255,255,255)
  love.graphics.print(
    "SCORE: " .. lssx.SCORE .. "\n" .. 
    "KILLS: " .. lssx.KILLS
    50, 50)

  love.graphics.push()
  love.graphics.translate((lssx.W_WIDTH/2)-285, 0)
  for k, element in pairs(HUD.elements.active) do
    element\draw()
  love.graphics.pop()
  love.graphics.setColor(255,255,255)

  HUD.camera\detach()
  HUD.camera\draw()

HUD.shake = (intensity, duration, frequency) ->
  frequency = frequency or 60
  HUD.camera\shake(intensity, duration, frequency)

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
    if @config.currentV <= @config.originalV*0.2 and (@value == "HP") --bleeeehh
      love.graphics.setColor(255,0,0)
      love.graphics.setFont(lssx.TITLEF)
      love.graphics.print("SYSTEM CRITICAL", -210, 45)
      love.graphics.setFont(lssx.TEXTF)
      -- love.graphics.print("CODE 102: LOW " .. string.upper(@value), -210, 95)
      lssx.camera\shake(1, 0.1)
      HUD.shake(1, 0.1)
      lssx.SPFX.CHROMASEP = math.random(10)

    love.graphics.setFont(lssx.TEXTF)
    love.graphics.setColor(unpack(@bgcolor))
    love.graphics.rectangle("fill", @x, @y, (@config.boxW/@config.originalV)*@config.lagV, 10)
    love.graphics.setColor(unpack(@color))
    love.graphics.rectangle("fill", @x, @y, (@config.boxW/@config.originalV)*@config.currentV, 10)

    love.graphics.printf(math.floor(@config.currentV).."/"..@config.originalV, @x, @y-@config.text.h, @config.boxW, "center")
    love.graphics.printf(string.upper(@value), @x, @y+@config.text.h-15, @config.boxW, "center")

    love.graphics.rectangle("line", @x, @y, @config.boxW, 10)

return HUD