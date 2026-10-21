local settings = require("src/settings")

local function animationToggleUpdate(group, values, changedValue, selected)
    animationEnabled = selected
    PersistentDB:SetBool("animationEnabled", animationEnabled)
    print ("RipperScape: animationEnabled set to ", animationEnabled)
end

local function volumeUpdate(slider, sliderValue)
    audioParameters.volume = sliderValue
    print ("RipperScape: volume set to ", audioParameters.volume);
end

local function activationChanceUpdate(field, textboxValue)
    if tonumber(textboxValue) == nil then
        return false
    end
    jumpscareProbability = round(tonumber(textboxValue))
    PersistentDB:SetInt("jumpscareProbability", jumpscareProbability)
    print ("RipperScape: jumpscareProbability set to ", jumpscareProbability)
end

local function jumpscareButton(button)
    print ("Jumpscare manually triggered")
    logicCounter = 0
    if (animationEnabled) then
        playAnimation = true
    end
    if (audioParameters.volume ~= 0) then
        audio.Play(Plugin.resources.scabariteDeath, audioParameters) -- profane scabarite death [ID: 57656] sfx
    end
end

local function resetPersistentDB()
    deletePersistentDB()
    fixPersistentDB()
    getPersistentDBValues()
end

local ripperScapeSettings 
function onSettingsLayerReady(settingsLayerReadyEvent)
    local rootLayer = settingsLayerReadyEvent.component
    if ripperScapeSettings then ripperScapeSettings:Destroy() end
    local settingsTab = prettyui.SimpleView.new(rootLayer, { width = rootLayer.width, height = rootLayer.height })
    ripperScapeSettings = settingsTab
    local toggleTitle = settingsTab:AddText({
        text = "Toggles", 
        tooltip = "Disables the jumpscare animation. Audio is still played unless volume is set to 0." 
    })
    local animationCheckbox = settingsTab:AddCheckboxButton({{ 
        text = "Animation", 
        value = 1, 
        selected = true }}, 
        {onChange = animationToggleUpdate }
        )
    local volumeTitle = settingsTab:AddText({
        text = "Volume slider", 
        tooltip = "Plugin volume slider. Plugin audio ignores game client settings including global mute. 0 disables audio playback." 
    })
    local volumeSlider = settingsTab:AddSlider({ 
        min = 0, 
        max = 1, 
        value = 0.5, 
        step = 0.1, 
        onChange = volumeUpdate
    })
    local activationChanceTitle = settingsTab:AddText({ 
        text = "Activation chance [0-99999]",
        tooltip = "Every second, a number between 0 and this number is rolled. If this number is hit, a jumpscare occurs. Default is 10000. Non-integer inputs will be rejected." 
    })
    local activationChanceBox = settingsTab:AddTextField({ 
        placeholder = "0", 
        text = 10000,
        onSubmit = activationChanceUpdate,
        maxLength = 5
    })
    local jumpscareButton = settingsTab:AddFancyButton(
        "Trigger jumpscare", 
        jumpscareButton, 
        { width = 270,
        marginTop = 70, 
        tooltip = "Is elaboration necessary?", 
        variant = "positive" 
    })
    local resetSettingsButton = settingsTab:AddFancyButton(
        "Clear data", 
        resetSettings, 
        { width = 270,
        inline = true,
        tooltip = "Clear all plugin data.",
        variant = "positive" 
    })
end
Event.SettingsLayerReady.Subscribe("ripperScapeSettings", onSettingsLayerReady)

function PluginShutdown()
    Event.SettingsLayerReady.Unsubscribe("ripperScapeSettings")
    if ripperScapeSettings then
        ripperScapeSettings:Destroy()
        ripperScapeSettings = nil
    end
end