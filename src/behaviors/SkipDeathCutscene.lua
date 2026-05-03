local internal = QoLInternal
local option_fns = internal.option_fns
local hook_fns = internal.hook_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "SkipDeathCutscene",
        label = "Skip Death Cutscene",
        default = true,
        tooltip =
        "Skip the death cutscene. The death screen will still appear, but you will be immediately returned to the main menu."
    })

table.insert(hook_fns, function()
    lib.hooks.Context.Wrap(internal, "DeathPresentation", function()
        lib.hooks.Wrap(internal, "wait", function(base, duration, tag, persist)
            if not internal.store.read("SkipDeathCutscene") or not lib.isModuleEnabled(internal.store, internal.PACK_ID) then
                return base(duration, tag, persist)
            end
            return
        end)
    end)
end)
