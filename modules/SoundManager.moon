SoundManager = {}

SoundManager.playLooping = (track) ->
  TEsound.playLooping("assets/Game/Sound/" .. track, "music")
  TEsound.volume("music", .6)

SoundManager.playRandom = (pre, count) ->
  TEsound.play("assets/Game/Sound/" .. pre .. math.random(count) .. ".wav")

return SoundManager