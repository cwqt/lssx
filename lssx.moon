export lssx = {
  objects: {}
  -- I am a ...
  categories: {
    ["Player"]:     1,
    ["Projectile"]: 2,
    ["Ship"]:       3,
    ["Asteroid"]:   4,
  }
  groupIndices: {
    ["Friendly"]:   1,
    ["Enemy"]:      2,
    ["Neutral"]:    3,
    ["NonNeutral"]: 4,
    ["All"]:        5,
  }

  INIT_TIME: love.timer.getTime(),
  CAMERA_ZOOM: 1.5,
  WIDTH: 400,
  HEIGHT: 300,
  SCALE: 1,

  SPFX: {
    CHROMASEP: 0,
    CHROMASEP_ANGLE: 0
  }
}
-- I will collide with a...
lssx.masks = {
  ["Player"]: {
    lssx.categories["Ship"],
    lssx.categories["Projectile"],
    lssx.categories["Asteroid"],
  }
}

