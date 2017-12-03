class Object
  new: () =>
    @creationTime = love.timer.getTime() - lssx.INIT_TIME
    @hash = tostring((@creationTime))\gsub('%.', '')

    if @isOwnObject == (false or nil)
      lssx.objects[@hash] = self

  remove: () =>
    lssx.objects[@hash] = nil

  @__inherited: (child) =>
    Debugger.log("#{@__name} was inherited by #{child.__name}", "inherit")
