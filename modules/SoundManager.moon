SoundManager = {}

SoundManager.playLooping = (track) ->
  TEsound.playLooping("assets/Game/Sound/" .. track, "music")
  TEsound.volume("music")

SoundManager.playRandom = (pre, count, volume) ->
  volume = volume or 1
  TEsound.play("assets/Game/Sound/" .. pre .. math.random(count) .. ".wav", {}, volume)

return SoundManager