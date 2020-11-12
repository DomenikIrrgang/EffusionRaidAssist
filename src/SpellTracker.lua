SpellTracker = EffusionRaidAssist.ModuleManager:NewModule("SpellTracker")

SpellTracker.trackedSpells = {
    "Healing Potion",
    "Mana Potion",
    "Fire Protection",
    "Nature Protection ",
    "Frost Protection",
    "Arcane Protection",
    "Free Action",
    "Goblin Sapper Charge",
    "Rage Potion",
    "Stoneshield",
    "Healthstone",
    "Anti-Venom",
    "Powerful Anti-Venom",
    "Jungle Remedy",
    "Restorative Potion",
    "Strong Anti-Venom"
}

function SpellTracker:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventName, _, _, sourceName, _, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()
    if (eventName == "SPELL_CAST_SUCCESS" and ArrayContainsValue(SpellTracker.trackedSpells, spellName)) then
        if self:GetData().spellUsage[sourceName] ~= nil then
            if (self:GetData().spellUsage[sourceName][spellName] ~= nil) then
                table.insert(self:GetData().spellUsage[sourceName][spellName], timestamp)
            else
                self:GetData().spellUsage[sourceName][spellName] = { timestamp }
            end
        else
            self:GetData().spellUsage[sourceName] = {}
            self:GetData().spellUsage[sourceName][spellName] = { timestamp }
        end
    end
end

function SpellTracker:OnModuleInitialize()
    self:GetData().spellUsage = self:GetData().spellUsage or {}
end

function SpellTracker:PrintData()
    EffusionRaidAssist:ChatMessage("Spellusage:")
    for player, data in pairs(self:GetData().spellUsage) do
        EffusionRaidAssist:ChatMessage("Player: ", player)
        for spell, counter in pairs(data) do
            EffusionRaidAssist:ChatMessage("  ", spell, table.getn(counter))
        end
    end
end

function SpellTracker:ResetData()
    self:GetData().spellUsage = {}
end

function SpellTracker:GetGameEvents()
    return {
        "COMBAT_LOG_EVENT_UNFILTERED"
    }
end

function SpellTracker:GetOptions()
    return {
        print = {
            order = 2,
            name = "Print Data",
            desc = "Print the currently gathered data in chat.",
            type = "execute",
            func = "PrintData",
            width = "full",
            handler = self
        },
        reset = {
            order = 2,
            name = "Reset Data",
            desc = "Reset all gathered data.",
            type = "execute",
            func = "ResetData",
            width = "full",
            handler = self
        }
    }
end