class Entity extends Object
  new: (hp, ...) =>
    super(...)
    hp = hp or 100
    @initalHP = hp
    @HP = hp

  update: (dt) =>

  draw: () =>

  takeDamage: (amount) =>
    Debugger.log("Entity took " .. amount .. " damage")
    SoundManager.playRandom("Hit", 1)
    @HP -= amount

  die: () =>
    super\remove()
    Debugger.log("Entity: '" .. @hash .. "' died.", "death")
