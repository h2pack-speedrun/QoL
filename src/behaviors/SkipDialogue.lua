local internal = QoLInternal
local option_fns = internal.option_fns
local hook_fns = internal.hook_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "SkipDialogue",
        label = "Auto Skip Dialogue",
        default = false,
        tooltip =
        "Automatically skips dialogue prompts during gameplay."
    })

table.insert(hook_fns, function()
    modutil.mod.Path.Wrap("PlayTextLines", function(base, source, textLines, args)
        if not internal.store.read("SkipDialogue") or not lib.isModuleEnabled(internal.store, public.definition.modpack) then
            return base(source, textLines, args)
        end

        -- Not in a run
        if CurrentRun.Hero.IsDead then
            return base(source, textLines, args)
        end

        if not textLines then return end

        -- Don't skip main story conversations (wants-to-talk icon)
        if textLines.StatusAnimation == 'StatusIconWantsToTalk' then
            return base(source, textLines, args)
        end

        -- Don't skip NPC choice dialogues
        if textLines.PrePortraitExitFunctionName then
            local hasChoice = string.find(textLines.PrePortraitExitFunctionName, 'Choice')
            if hasChoice then
                return base(source, textLines, args)
            end
        end

        return
    end)
end)
