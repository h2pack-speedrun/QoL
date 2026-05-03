local mods = rom.mods
mods["SGG_Modding-ENVY"].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods["SGG_Modding-ModUtil"]
local chalk = mods["SGG_Modding-Chalk"]
local reload = mods["SGG_Modding-ReLoad"]
---@module "adamant-ModpackLib"
---@type AdamantModpackLib
lib = mods["adamant-ModpackLib"]

local dataDefaults = import("config.lua")
local config = chalk.auto("config.lua")

local PACK_ID = "speedrun"
local MODULE_ID = "QoL"
local PLUGIN_GUID = _PLUGIN.guid

---@class QoLInternal
---@field store ManagedStore|nil
---@field standaloneUi StandaloneRuntime|nil
---@field PACK_ID string|nil
---@field MODULE_ID string|nil
---@field BuildStorage fun(): StorageSchema|nil
---@field RegisterHooks fun()|nil
---@field DrawTab fun(imgui: table, session: AuthorSession)|nil
---@field DrawQuickContent fun(imgui: table, session: AuthorSession)|nil
QoLInternal = QoLInternal or {}
---@type QoLInternal
local internal = QoLInternal

internal.PACK_ID = PACK_ID
internal.MODULE_ID = MODULE_ID

internal.standaloneUi = nil

local function registerGui()
    rom.gui.add_imgui(function()
        if internal.standaloneUi and internal.standaloneUi.renderWindow then
            internal.standaloneUi.renderWindow()
        end
    end)

    rom.gui.add_to_menu_bar(function()
        if internal.standaloneUi and internal.standaloneUi.addMenuBar then
            internal.standaloneUi.addMenuBar()
        end
    end)
end

local function init()
    import_as_fallback(rom.game)

    import("data.lua")
    import("logic.lua")
    import("ui.lua")

    local definition = lib.prepareDefinition(internal, dataDefaults, {
        modpack = PACK_ID,
        id = MODULE_ID,
        name = "Quality of Life",
        tooltip = "Quality of life improvements for speedrunning.",
        default = dataDefaults.Enabled,
        affectsRunData = false,
        storage = internal.BuildStorage(),
    })

    local store, session = lib.createStore(config, definition)
    internal.store = store

    lib.createModuleHost({
        pluginGuid = PLUGIN_GUID,
        definition = definition,
        store = store,
        session = session,
        hookOwner = internal,
        registerHooks = internal.RegisterHooks,
        drawTab = internal.DrawTab,
        drawQuickContent = internal.DrawQuickContent,
    })
    internal.standaloneUi = lib.standaloneHost(PLUGIN_GUID)
end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(registerGui, init)
end)
