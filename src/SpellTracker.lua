local SpellTracker = EffusionRaidAssist.ModuleManager:NewModule("SpellTracker")

SpellTracker.trackedSpells = {
    "Healing Potion",
    "Mana Potion",
    "Fire Protection",
    "Nature Protection",
    "Frost Protection",
    "Arcane Protection",
    "Free Action",
    "Goblin Sapper Charge",
    "Rage Potion",
    "Stoneshield",
    "Healthstone",
    "Heal"
}

function SpellTracker:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventName, _, _, sourceName, _, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()
    if (eventName == "SPELL_CAST_SUCCESS" and ArrayContainsValue(SpellTracker.trackedSpells, spellName)) then
        if EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName] ~= nil then
            table.insert(EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName], timestamp)
        else
            EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName] = { timestamp }
        end
    end
end

function SpellTracker:OnModuleInitialize()
    for index, player in pairs(EffusionRaidAssist:GetCurrentRaid()) do
        EffusionRaidAssist:GetCurrentRaid()[index].spellUsage = {}
    end
end

function SpellTracker:GetGameEvents()
    return {
        "COMBAT_LOG_EVENT_UNFILTERED"
    }
end

function SpellTracker:GetCustomEvents()
    return {}
end