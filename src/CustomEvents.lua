EffusionRaidAssist.CustomEvents = {
    DungeonEntered = "DUNGEON_ENTERED", -- (name)
    DungeonLeft = "DUNGEON_LEFT", -- (name)
    EffusionRaidAssistInitStarted = "EFFUSION_RAID_ASSIST_INIT_STARTED", -- ()
    EffusionRaidAssistInit = "EFFUSION_RAID_ASSIST_INIT", -- ()
    EffusionRaidAssistInitFinished = "EFFUSION_RAID_ASSIST_INIT_FINISHED", -- ()
    MinimapIconClicked = "MINIMAP_ICON_CLICKED", -- ()
    OptionsTableInit = "OPTIONS_TABLE_INIT", -- ()
    ProfileChanged = "PROFILE_CHANGED", -- ()
    ModuleEnabled = "MODULE_ENABLED", -- (name)
    ModuleDisabled = "MODULE_DISABLED", -- (name)
    EncounterEngaged = "ENCOUNTER_ENGAGED", -- (encounterInformation)
    EncounterEnded = "ENCOUNTER_ENDED", -- (encounterInformation),
    CombatEntered = "COMBAT_ENTERED", -- ()
    CombatLeft = "COMBAT_LEFT", -- ()
    UnitLeftCombat = "UNIT_LEFT_COMBAT", -- (unitName, unitId, unitGuid)
    UnitJoinedCombat = "UNIT_JOINED_COMBAT", -- (unitName, unitId, unitGuid)
}