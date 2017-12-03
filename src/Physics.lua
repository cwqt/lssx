local Physics = { }
Physics.load = function()
  lssx.world = love.physics.newWorld(0, 0, true)
end
Physics.update = function(dt)
  lssx.world:update(dt)
  return Physics.runBuffer()
end
Physics.buffer = { }
Physics.addToBuffer = function(func)
  Physics.buffer[#Physics.buffer + 1] = func
end
Physics.runBuffer = function()
  if #Physics.buffer > 0 then
    for i = #Physics.buffer, 1, -1 do
      Physics.buffer[i]()
      table.remove(Physics.buffer, i)
    end
  end
end
return Physics
