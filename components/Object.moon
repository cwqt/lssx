class Object
  new: (customHash) =>
    @creationTime = love.timer.getTime() - lssx.INIT_TIME
    if customHash != nil then
      @hash = tostring(customHash)
    else
      @hash = UUID()

    if @isOwnObject == (false or nil)
      lssx.objects[@hash] = self

    Debugger.log("Spawned " .. @@.__name, "spawn")

  remove: () =>
    lssx.objects[@hash] = nil
    Debugger.log("Object " .. @hash .. " removed", "important")

  @__inherited: (child) =>
    Debugger.log("#{@__name} was inherited by #{child.__name}", "inherit")