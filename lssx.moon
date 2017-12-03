export lssx = {
  objects: {}
  INIT_TIME: love.timer.getTime()
  -- I am a ...
  categories: {
    ["Player"]:     1,
    ["Projectile"]: 2,
    ["Ship"]:       3,
  }
  groupIndices: {
    ["FriendlyFire"]: 1
  }
}
-- I will collide with a...
lssx.masks = {
  ["Player"]: {
    lssx.categories["Projectile"]
    lssx.categories["Asteroid"]
    lssx.categories["AI"]
  }
}