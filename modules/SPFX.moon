SPFX = {}

SPFX.load = () ->
  SPFX.effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.scanlines).chain(moonshine.effects.chromasep)
  SPFX.effect.parameters = {
    scanlines: {opacity: 0.3}
    chromasep: {angle: lssx.SPFX.CHROMASEP_ANGLE, radius: lssx.SPFX.CHROMASEP}
  }

SPFX.update = (dt) ->
  SPFX.effect.chromasep.angle = lssx.SPFX.CHROMASEP_ANGLE
  SPFX.effect.chromasep.radius = lssx.SPFX.CHROMASEP

SPFX.bounceChroma = (length, radius, angle) ->
  length = length/2 -- back and forth
  radius = radius or 0
  angle = angle or 0
  flux.to(lssx.SPFX, length, {CHROMASEP: radius, CHROMASEP_ANGLE: angle})\after(lssx.SPFX, length, {CHROMASEP: 0, CHROMASEP_ANGLE: 0})

return SPFX
