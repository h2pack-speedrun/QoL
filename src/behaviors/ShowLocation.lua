local internal = QoLInternal
local option_fns = internal.option_fns
local hook_fns = internal.hook_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "ShowLocation",
        label = "Always Show Location",
        default = true,
        tooltip =
        "Always displays the current location in the UI."
    })

local function ShowDepthCounter()
    local screen = { Name = "RoomCount", Components = {} }
    screen.ComponentData = {
        RoomCount = DeepCopyTable(ScreenData.TraitTrayScreen.ComponentData.RoomCount)
    }
    CreateScreenFromData(screen, screen.ComponentData)
end

table.insert(hook_fns, function()
    modutil.mod.Path.Wrap("ShowHealthUI", function(baseFunc)
        baseFunc()
        if store.read("ShowLocation") and lib.isEnabled(store, public.definition.modpack) then
            ShowDepthCounter()
        end
    end)
end)
