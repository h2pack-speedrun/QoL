local mods = rom.mods
mods["SGG_Modding-ENVY"].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods["SGG_Modding-ModUtil"]
local chalk = mods["SGG_Modding-Chalk"]
local reload = mods["SGG_Modding-ReLoad"]
lib = mods["adamant-ModpackLib"]

local dataDefaults = import("config.lua")
local config = chalk.auto("config.lua")

local PACK_ID = "speedrun"

QoLInternal = QoLInternal or {}
local internal = QoLInternal

public.definition = {
    modpack = PACK_ID,
    id = "QoL",
    name = "Quality of Life",
    tooltip = "Quality of life improvements for speedrunning.",
    default = dataDefaults.Enabled,
    affectsRunData = false,
}

public.store = nil
store = nil
internal.standaloneUi = nil

local function registerHooks()
    if internal.RegisterHooks then
        internal.RegisterHooks()
    end

    public.DrawTab = internal.DrawTab
    -- public.DrawQuickContent = internal.DrawQuickContent
end

local function init()
    import_as_fallback(rom.game)

    import("data.lua")
    import("ui.lua")

    public.store = lib.store.create(config, public.definition, dataDefaults)
    store = public.store

    registerHooks()

    internal.standaloneUi = lib.host.standaloneUI(
        public.definition,
        store,
        store.uiState,
        {
            getDrawTab = function()
                return public.DrawTab
            end,
        }
    )
end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(init, init)
end)

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_imgui(function()
    if internal.standaloneUi and internal.standaloneUi.renderWindow then
        internal.standaloneUi.renderWindow()
    end
end)

---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_to_menu_bar(function()
    if internal.standaloneUi and internal.standaloneUi.addMenuBar then
        internal.standaloneUi.addMenuBar()
    end
end)
