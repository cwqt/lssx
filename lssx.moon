export lssx = {
  objects: {}
  -- I am a ...
  categories: {
    ["Player"]:     1,
    ["Projectile"]: 2,
    ["Ship"]:       3,
  }
  groupIndices: {
    ["FriendlyFire"]: 1
  }

  INIT_TIME: love.timer.getTime()
  CAMERA_ZOOM: 1.5
  WIDTH: 400
  HEIGHT: 300
  SCALE: 1
}
-- I will collide with a...
lssx.masks = {
  ["Player"]: {
    lssx.categories["Projectile"]
    lssx.categories["Asteroid"]
    lssx.categories["AI"]
  }
}

