class Entity extends Object
  new: (hp) =>
    super()
    hp = hp or 100
    @initalHP = hp
    @HP = hp

  update: (dt) =>
    if @HP <= 0 @die()

  draw: () =>

  takeDamage: (amount) =>
    Debugger.log("Entity took " .. amount .. " damage")
    @HP -= amount

  die: () =>
    super\remove()
    Debugger.log("Entity: '" .. @hash .. "' died.", "death")