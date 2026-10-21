local PersistentDBDefault = { -- PersistentDB keys and default values
    {"jumpscareProbability", 10000},
    {"audioVolume", 0.5},
    {"animationEnabled", true}
}

local function deletePersistentDB() -- Deletes every PersistentDB entry present in PersistentDBDefault
    for i = 1, #PersistentDBDefault do
        PersistentDB:Delete(PersistentDBDefault[i][1])
    end
end

local function fixPersistentDB()
    for i = 1, #PersistentDBDefault do -- Check for PersistentDB entries, if absent, create and set to default
        if (PersistentDB:Get(PersistentDBDefault[i][1]) == nil) then
            print (PersistentDBDefault[i][1], " PersistentDBKeynot found, setting to default")
            PersistentDB:Set(PersistentDBDefault[i][1], PersistentDBDefault[i][2])
        end
    end
end

local function getPersistentDBValues()-- Set variables to PersistentDB entries
    jumpscareProbability = PersistentDB:Get("jumpscareProbability")
    audioVolume = PersistentDB:Get("audioVolume")
    animationEnabled = PersistentDB:Get("animationEnabled")
end