local PhysicsObject
do
  local _class_0
  local _parent_0 = Object
  local _base_0 = {
    update = function(self, dt)
      self.x, self.y = self.body:getPosition()
    end,
    remove = function(self)
      return Physics.addToBuffer(function()
        _class_0.__parent.remove(self)
        return self.body:destroy()
      end)
    end,
    beginContact = function(self, other)
      local other_object = lssx.objects[other:getBody():getUserData().hash]
      return print("I collided with object " .. other_object.__class.__name)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, world, x, y, typeOf)
      self.x, self.y = x, y
      _class_0.__parent.__init(self)
      self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
      return self.body:setUserData({
        hash = self.hash
      })
    end,
    __base = _base_0,
    __name = "PhysicsObject",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  PhysicsObject = _class_0
  return _class_0
end
