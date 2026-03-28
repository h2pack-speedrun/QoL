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
    modutil.mod.Path.Context.Wrap("DeathPresentation", function()
        modutil.mod.Path.Wrap("wait", function(base, duration, tag, persist)
            if not config.SkipDeathCutscene or not lib.isEnabled(config, public.definition.modpack) then
                return base(duration, tag, persist)
            end
            return
        end)
    end)
end)
