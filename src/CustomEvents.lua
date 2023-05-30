EffusionRaidAssist.CustomEvents = {
    DungeonEntered = "DUNGEON_ENTERED", -- (name)
    DungeonLeft = "DUNGEON_LEFT", -- (name)
    EffusionRaidAssistInitStarted = "EFFUSION_RAID_ASSIST_INIT_STARTED", -- ()
    EffusionRaidAssistInit = "EFFUSION_RAID_ASSIST_INIT", -- ()
    EffusionRaidAssistInitFinished = "EFFUSION_RAID_ASSIST_INIT_FINISHED", -- ()
    MinimapIconClicked = "MINIMAP_ICON_CLICKED", -- ()
    OptionsTableInit = "OPTIONS_TABLE_INIT", -- ()
    ProfileChanged = "PROFILE_CHANGED", -- ()
    ModuleLoaded = "MODULE_LOADED", -- (name)
    ModuleUnloaded = "MODULE_UNLOADED", -- (name)
    ModuleEnabled = "MODULE_ENABLED", -- (name)
    ModuleDisabled = "MODULE_DISABLED", -- (name)
    AllModulesInitialized = "ALL_MODULES_INITIALIZED", -- (modules)
    EncounterEngaged = "ENCOUNTER_ENGAGED", -- (encounterInfo)
    EncounterDisengaged = "ENCOUNTER_DISENGAGED", -- (encounterInfo)
    CombatEntered = "COMBAT_ENTERED", -- ()
    CombatLeft = "COMBAT_LEFT", -- ()
    UnitLeftCombat = "UNIT_LEFT_COMBAT", -- (unitName, unitId, unitGuid)
    UnitJoinedCombat = "UNIT_JOINED_COMBAT", -- (unitName, unitId, unitGuid)
    PlayerJoinedGroup = "PLAYER_JOINED_GROUP", -- (playerInfo = { name, level, class, isOnline, isDead, })
    PlayerLeftGroup = "PLAYER_LEFT_GROUP", -- (playerInfo = { name, level, class, isOnline, isDead, })
    NamePlateAdded = "NAMEPLATE_ADDED", -- (unitId)
    NamePlateRemoved = "NAMEPLATE_REMOVED", -- (unitId)
}