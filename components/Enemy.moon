class Enemy extends Entity
  new: (@ship, ...) =>
    super(...)
    --Reference ship to top-level player
    @ship.hash = @hash
    @ship\appendUserData("hash", @hash)

    @ship.fixture\setGroupIndex(-1)

    @ship.components["Emitter"] = Emitter!
    -- @ship.components["Shield"]  = Shield(10, 10, 10)