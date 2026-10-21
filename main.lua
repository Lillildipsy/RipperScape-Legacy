local pluginUI = require("src/ui")

game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

local animFrames = { -- array containing a reference to each frame of the jumpscare animation
 Plugin.resources.ripper0, 
 Plugin.resources.ripper1, 
 Plugin.resources.ripper2, 
 Plugin.resources.ripper3, 
 Plugin.resources.ripper4, 
 Plugin.resources.ripper5, 
 Plugin.resources.ripper6, 
 Plugin.resources.ripper7, 
 Plugin.resources.ripper8,
 Plugin.resources.ripper9, 
 Plugin.resources.ripper10,
 Plugin.resources.ripper11, 
 Plugin.resources.ripper12, 
 Plugin.resources.ripper13, 
 Plugin.resources.ripper14,
 Plugin.resources.ripper15
}

-- vars
local currentFrame = 1 -- current frame of animFrames displayed by the jumpscare sprite during jumpscare
logicCounter = 0 -- logic event triggers 50x per second, this counter is used to more precisely control how often events happen
jumpscareActive = false -- determines if the plugin is rolling to jumpscare, or if a jumpscare is happening
jumpscareProbability = 10000 -- RNG check is between 0 and this number, must hit this number to trigger. 
audioVolume = 0.5

-- Jumpscare sprite and audioParameter properties
jumpscare = ui.Sprite.new(game_window)
jumpscare:SetSize(0,0,1.0,1)
jumpscare:SetPos(0,0,0.0,0)

audioParameters = audio.SoundPlaybackParams.new()
audioParameters.type = audio.SoundType.SCRIPT
audioParameters.audioBus = audio.AudioBus.MASTER
audioParameters.volume = audioVolume

local function logicTick(event) -- main loop; divided between jumpscare behaviour and the rng tick every second to see if it should begin the jumpscare
    logicCounter = logicCounter + 1
    print (audioParameters.volume)
    if (jumpscareActive) then -- jumpscare behaviour; code should be self-explanatory
        if (logicCounter == 2) then
            logicCounter = 0
            jumpscare.alpha = 1
            jumpscare.sprite = animFrames[currentFrame]
            if (currentFrame == 1) then
                audio.Play(57656, audioParameters) -- profane scabarite death sfx
            end
            if (currentFrame < 16) then
                currentFrame = currentFrame + 1
            else
                currentFrame = 1
                jumpscareActive = false
                jumpscare.alpha = 0
            end
        end
    else
        if (logicCounter == 50) then -- every second, roll rng to determine if a jumpscare should be played
            logicCounter = 0
            randomTick = round(random(0,jumpscareProbability))
            if (randomTick == jumpscareProbability) then
                print ("Jumpscare triggered")
                jumpscareActive = true
            end
        end
    end
end

Event.Logic.Subscribe("logicEvent", logicTick)

function round(num) -- used when generating random numbers to ensure that it only produces whole numbers
    return math.floor(num + 0.5)
end
