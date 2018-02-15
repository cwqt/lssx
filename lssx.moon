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
  CAMERA_ZOOM: 1.8,
  WIDTH: 400,
  HEIGHT: 300,
  SCALE: 1,
  W_HEIGHT: 600,
  W_WIDTH: 1100,
  PLAYER_DEAD: false
  PAUSE: false,
  TITLEF: love.graphics.newFont("assets/MainMenu/title.ttf", 50)
  TEXTF:  love.graphics.newFont("assets/MainMenu/text.ttf", 26)
  SCORE: 0
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

lssx.StringPad = (str, len, char) ->
  return i .. string.rep(char, len-#str)