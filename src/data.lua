-- sprite object / audio parameters
jumpscare = ui.Sprite.new(game_window)
jumpscare:SetSize(0,0,1.0,1)
jumpscare:SetPos(0,0,0.0,0)

audioParameters = audio.SoundPlaybackParams.new()
audioParameters.type = audio.SoundType.SCRIPT
audioParameters.audioBus = audio.AudioBus.MASTER
audioParameters.volume = audioVolume