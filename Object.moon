class Object
  new: () =>
    @creationTime = love.timer.getTime()
    @hash = tostring((@creationTime - lssx.INIT_TIME))\gsub('%.', '')
    lssx.objects[@hash] = self

  appendUserData: (key, data) =>
    t = @body\getUserData()
    t[key] = data
    @body\setUserData(t)

  remove: () =>
    lssx.objects[@hash] = nil
