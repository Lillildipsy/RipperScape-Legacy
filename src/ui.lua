local function animationToggleUpdate(group, values, changedValue, selected)
end

local function volumeUpdate(slider, sliderValue)
    audioParameters.volume = sliderValue
end

local function activationChanceUpdate(field, textboxValue)
    if tonumber(textboxValue) == nil then
        return false
    end
    jumpscareProbability = round(tonumber(textboxValue))
end

local function jumpscareButton(button)
    print ("Jumpscare manually triggered")
    logicCounter = 0
    jumpscareActive = true
end


local ripperScapeSettings 
function onSettingsLayerReady(settingsLayerReadyEvent)
    local rootLayer = settingsLayerReadyEvent.component
    if ripperScapeSettings then ripperScapeSettings:Destroy() end
    local settingsTab = prettyui.SimpleView.new(rootLayer, { width = rootLayer.width, height = rootLayer.height })
    ripperScapeSettings = settingsTab
    settingsTab:AddText({
        text = "Toggles", 
        tooltip = "Disables the jumpscare animation. Audio is still played unless volume is set to 0." 
    })
    settingsTab:AddCheckboxButton({{ 
        text = "Animation", 
        value = 1, 
        selected = true }}, 
        {onChange = animationToggleUpdate }
        )
    settingsTab:AddText({
        text = "Volume slider", 
        tooltip = "Plugin volume slider. Plugin audio ignores game client settings including global mute. 0 disables audio playback." 
    })
    settingsTab:AddSlider({ 
        min = 0, 
        max = 1, 
        value = 0.5, 
        step = 0.01, 
        onChange = volumeUpdate
    })
    settingsTab:AddText({ 
        text = "Activation chance [0-99999]",
        tooltip = "Every second, a number between 0 and this number is rolled. If this number is hit, a jumpscare occurs. Default is 10000. Non-integer inputs will be rejected." 
    })
    settingsTab:AddTextField({ 
        placeholder = "0", 
        text = 10000,
        onSubmit = activationChanceUpdate,
        maxLength = 5
    })
    settingsTab:AddFancyButton(
        "Trigger Jumpscare", 
        jumpscareButton, 
        { marginTop = 80, 
        tooltip = "Is elaboration necessary?", 
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