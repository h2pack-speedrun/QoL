-- luacheck: globals QoLInternal public
local internal = QoLInternal

internal.hook_fns = {}
internal.option_fns = {}

local PACK_ID = "speedrun"

local function BuildStorage(options)
    local storage = {}
    for _, option in ipairs(options) do
        if option.type == "checkbox" then
            table.insert(storage, {
                type = "bool",
                alias = option.configKey,
                configKey = option.configKey,
            })
        else
            error(("Unsupported option type '%s' in %s"):format(tostring(option.type), PACK_ID .. ".QoL"))
        end
    end
    return storage
end

import("behaviors/KBMEscape.lua")
import("behaviors/ShowLocation.lua")
import("behaviors/SkipDeathCutscene.lua")
import("behaviors/SkipDialogue.lua")
import("behaviors/SkipRunEndCutscene.lua")
import("behaviors/SpawnLocation.lua")
import("behaviors/VictoryScreen.lua")

public.definition.storage = BuildStorage(internal.option_fns)

function internal.RegisterHooks()
    for _, fn in ipairs(internal.hook_fns) do
        fn()
    end
end

return internal
