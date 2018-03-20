SoundManager = {}

SoundManager.playLooping = (track) ->
  TEsound.volume("all", 0.5)
  TEsound.playLooping("assets/Game/Sound/" .. track, "music")
  TEsound.volume("music", 2)
  TEsound.pitch("music", 1.5)

SoundManager.playRandom = (pre, count, volume) ->
  volume = volume or 1
  TEsound.play("assets/Game/Sound/" .. pre .. math.random(count) .. ".wav", {}, volume)

return SoundManager