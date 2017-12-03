local Object
do
  local _class_0
  local _base_0 = {
    appendUserData = function(self, key, data)
      local t = self.body:getUserData()
      t[key] = data
      return self.body:setUserData(t)
    end,
    remove = function(self)
      lssx.objects[self.hash] = nil
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.creationTime = love.timer.getTime()
      self.hash = tostring((self.creationTime - lssx.INIT_TIME)):gsub('%.', '')
      lssx.objects[self.hash] = self
    end,
    __base = _base_0,
    __name = "Object"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Object = _class_0
  return _class_0
end
