local internal = QoLInternal
local option_fns = internal.option_fns
local hook_fns = internal.hook_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "KBMEscape",
        label = "KBM Escape Fix",
        default = true,
        tooltip =
        "KBM Escape will now work during boon/pom Selection, Hex selection, PoS menu, and during death sequences."
    })

table.insert(hook_fns, function()
    modutil.mod.Path.Wrap("IsPauseBlocked", function(base)
        if not store.read("KBMEscape") or not lib.coordinator.isEnabled(store, public.definition.modpack) then return base() end

        if SessionMapState.HandlingDeath then
            return false
        end
        if SessionMapState.BlockPause then
            return true
        end

        if CurrentRun ~= nil then
            if CurrentRun.Hero.FishingStarted then
                return true
            end
        end

        local excludedScreens = { UpgradeChoice = true, SpellScreen = true, TalentScreen = true }
        for screenName, screen in pairs(ActiveScreens) do
            if excludedScreens[screenName] then
                return false
            end
            if screen.BlockPause then
                return true
            end
        end

        local blockingScreens = {
            "Codex", "MetaUpgrade", "ShrineUpgrade", "MusicPlayer",
            "QuestLog", "Mutator", "GhostAdmin", "AwardMenu", "RunClear",
            "RunHistory", "GameStats", "TraitTrayScreen", "WeaponUpgradeScreen",
            "InventoryScreen", "MarketScreen", "WeaponShop",
            "DebugEnemySpawn", "DebugConversations",
        }
        for _, name in pairs(blockingScreens) do
            if ActiveScreens[name] then
                return true
            end
        end

        return false
    end)
end)
