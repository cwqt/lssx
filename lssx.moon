export lssx = {
  objects: {}
  -- I am a ...
  categories: {
    ["Ship"]:       1,
    ["Projectile"]: 2,
    ["Shield"]:     3,
    ["Asteroid"]:   4,
    ["EN_Fov"]:     5,
  }
  groupIndices: {
    ["Friendly"]:   -1,
    ["Enemy"]:      -2,
    ["All"]:        3,
  }

  INIT_TIME: love.timer.getTime(),
  CAMERA_ZOOM: 1.6,
  WIDTH: 400,
  HEIGHT: 300,
  SCALE: 1,
  W_HEIGHT: 600,
  W_WIDTH: 1100,
  SHOW_INSTRUCTIONS: false
  FIRST_TIME: true,
  PLAYER_DEAD: false
  PAUSE: false,
  TITLEF: love.graphics.newFont("assets/MainMenu/title.ttf", 50)
  TEXTF:  love.graphics.newFont("assets/MainMenu/text.ttf", 26)

  SCORE: 0
  KILLS: 0

  SPFX: {
    CHROMASEP: 0,
    CHROMASEP_ANGLE: 0
  }
}
-- I WON'T collide with...
lssx.masks = {
  ["Ship"]: {

  }
  ["Player"]: {
    -- lssx.categories["Ship"],
    -- lssx.categories["Projectile"],
  }
  ["Shield"]: {
    lssx.categories["Asteroid"],
    lssx.categories["Ship"],
  }
  ["EN_Fov"]: {
    -- lssx.categories["Ship"],
    lssx.categories["Projectile"],
  }
}

lssx.StringPad = (str, len, char) ->
  return i .. string.rep(char, len-#str)