table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "SpawnLocation",
        label = "Spawn in Training Grounds",
        default = true,
        tooltip =
        "Spawns you in the Training Grounds instead of the House of Hades. Useful for testing and practicing."
    })

table.insert(hook_fns, function()
    modutil.mod.Path.Context.Wrap("KillHero", function(_, _, _)
        modutil.mod.Path.Wrap("LoadMap", function(base, argTable)
            if not config.SpawnLocation or not lib.isEnabled(config, public.definition.modpack) then
                base(argTable)
                return
            end
            if argTable.Name == "Hub_Main" then
                argTable.Name = "Hub_PreRun"
            end
            base(argTable)
        end)
    end)
end)
