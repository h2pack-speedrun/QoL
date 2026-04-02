local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
local chalk = mods['SGG_Modding-Chalk']
local reload = mods['SGG_Modding-ReLoad']
lib = rom.mods['adamant-ModpackLib']
local config = chalk.auto('config.lua')

QoLInternal = QoLInternal or {}
local internal = QoLInternal

-- Behavior registration tables — populated by each behaviors/*.lua file via import().
-- Each behavior file may append to any of these independently:
--   hook_fns  : sequence of functions                    — called once on load to register hooks
--   option_fns: sequence of option descriptors           — drives the Framework UI options list
internal.hook_fns = internal.hook_fns or {}
internal.option_fns = internal.option_fns or {}

local PACK_ID = "speedrun"

import 'behaviors/KBMEscape.lua'
import 'behaviors/ShowLocation.lua'
import 'behaviors/SkipDeathCutscene.lua'
import 'behaviors/SkipDialogue.lua'
import 'behaviors/SkipRunEndCutscene.lua'
import 'behaviors/SpawnLocation.lua'
import 'behaviors/VictoryScreen.lua'

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    modpack      = PACK_ID,
    id           = "QoL",
    name         = "Quality of Life",
    category     = "QoL",
    group        = "QoL",
    tooltip      = "Quality of life improvements for speedrunning.",
    default      = true,
    affectsRunData = false,
    options      = internal.option_fns,
}

public.store = lib.createStore(config, public.definition)
store = public.store

-- =============================================================================
-- MODULE LOGIC
-- =============================================================================

local function registerHooks()
    for _, fn in ipairs(internal.hook_fns) do fn() end
end

-- =============================================================================
-- Wiring
-- =============================================================================

local loader = reload.auto_single()

local function init()
    import_as_fallback(rom.game)
    registerHooks()
    if public.definition.affectsRunData and not lib.isCoordinated(public.definition.modpack) then
        SetupRunData()
    end
end

modutil.once_loaded.game(function()
    loader.load(init, init)
end)

local uiCallback = lib.standaloneUI(public.definition, store)
---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_to_menu_bar(uiCallback)
