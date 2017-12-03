class Object
  new: () =>
    @creationTime = love.timer.getTime() - lssx.INIT_TIME
    @hash = tostring((@creationTime))\gsub('%.', '')
    lssx.objects[@hash] = self

  appendUserData: (key, data) =>
    t = @body\getUserData()
    t[key] = data
    @body\setUserData(t)

  remove: () =>
    lssx.objects[@hash] = nil
