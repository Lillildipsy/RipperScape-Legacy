-- Dependencies / game window

local pluginUI = require("src/ui")
local settings = require("src/settings")
game_window = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)

-- Global functions

function round(num) -- used when generating random numbers to ensure that it only produces whole numbers
    return math.floor(num + 0.5)
end

-- Vars

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

local currentFrame = 1 -- current frame of animFrames displayed by the jumpscare sprite during jumpscare
local logicCounter = 0 -- logic event triggers 50x per second, this counter is used to more precisely control how often events happen
playAnimation = false -- determines if the plugin is rolling to jumpscare, or if a jumpscare is happening

-- PersistentDB
local PersistentDBDefault = { -- PersistentDB keys and default values
    {"jumpscareProbability", 10000},
    {"audioVolume", 0.5},
    {"animationEnabled", true}
}

function deletePersistentDB() -- Deletes every PersistentDB entry present in PersistentDBDefault
    for i = 1, #PersistentDBDefault do
        PersistentDB:Delete(PersistentDBDefault[i][1])
    end
end

function fixPersistentDB()
    for i = 1, #PersistentDBDefault do -- Check for PersistentDB entries, if absent, create and set to default
        if (PersistentDB:Get(PersistentDBDefault[i][1]) == nil) then
            print (PersistentDBDefault[i][1], " PersistentDBKeynot found, setting to default")
            PersistentDB:Set(PersistentDBDefault[i][1], PersistentDBDefault[i][2])
        end
    end
end

function getPersistentDBValues()-- Set variables to PersistentDB entries
    jumpscareProbability = PersistentDB:Get("jumpscareProbability")
    audioVolume = PersistentDB:Get("audioVolume")
    animationEnabled = PersistentDB:Get("animationEnabled")
end

fixPersistentDB()
getPersistentDBValues()

-- Jumpscare sprite and audioParameter properties
jumpscare = ui.Sprite.new(game_window)
jumpscare:SetSize(0,0,1,1)
jumpscare:SetPos(0,0,0,0)

audioParameters = audio.SoundPlaybackParams.new()
audioParameters.type = audio.SoundType.SCRIPT
audioParameters.audioBus = audio.AudioBus.MASTER
audioParameters.volume = audioVolume
audioParameters.delayTick = 1

local function logicTick(event) -- main loop; divided between jumpscare behaviour and the rng tick every second to see if it should begin the jumpscare
    logicCounter = logicCounter + 1
    if (playAnimation) then -- jumpscare behaviour; code should be self-explanatory
        if (logicCounter > 1) then
            logicCounter = 0
            jumpscare.sprite = animFrames[currentFrame]
            if (currentFrame == 1) then
                jumpscare.alpha = 1
            end
            if (currentFrame < 16) then
                currentFrame = currentFrame + 1
            else
                currentFrame = 1
                playAnimation = false
                jumpscare.alpha = 0
            end
        end
    else
        if (logicCounter == 50) then -- every second, roll rng to determine if a jumpscare should be played
            logicCounter = 0
            randomTick = round(random(0,jumpscareProbability))
            if (randomTick == jumpscareProbability) then
                print ("Jumpscare triggered")
                if (animationEnabled) then
                    playAnimation = true
                end
                if (audioParameters.volume ~= 0) then
                    audio.Play(Plugin.resources.scabariteDeath, audioParameters) -- profane scabarite death [ID: 57656] sfx
                end
            end
        end
    end
end

Event.Logic.Subscribe("logicEvent", logicTick)

function PluginShutdown()
    Event.Logic.Unsubscribe("logicEvent", logicTick)
    jumpscare:Destroy()
end