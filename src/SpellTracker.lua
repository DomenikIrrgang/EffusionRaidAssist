SpellTracker = EffusionRaidAssist.ModuleManager:NewModule("SpellTracker")
local AceGUI = LibStub("AceGUI-3.0")

SpellTracker.trackedSpells = {
    "Healing Potion",
    "Restore Mana",
    "Fire Protection",
    "Nature Protection ",
    "Frost Protection",
    "Arcane Protection",
    "Free Action",
    "Goblin Sapper Charge",
    "Rage Potion",
    "Stoneshield",
    "Greater Healthstone",
    "Major Healthstone",
    "Anti-Venom",
    "Powerful Anti-Venom",
    "Jungle Remedy",
    "Restorative Potion",
    "Strong Anti-Venom",
    "Dispel Poison",
    "Cure Ailments"
}

function SpellTracker:SpellCastSuccess(event)
    if (ArrayContainsValue(SpellTracker.trackedSpells, event.spellName)) then
        if self:GetData().spellUsage[event.sourceName] ~= nil then
            if (self:GetData().spellUsage[event.sourceName][event.spellName] ~= nil) then
                table.insert(self:GetData().spellUsage[event.sourceName][event.spellName], event.timestamp)
            else
                self:GetData().spellUsage[event.sourceName][event.spellName] = { event.timestamp }
            end
        else
            self:GetData().spellUsage[event.sourceName] = {}
            self:GetData().spellUsage[event.sourceName][event.spellName] = { event.timestamp }
        end
    end
end

function SpellTracker:OnModuleInitialize()
    self:GetData().spellUsage = self:GetData().spellUsage or {}
    self:CombatLogEvent("SPELL_CAST_SUCCESS", nil, self.SpellCastSuccess)
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

function SpellTracker:PrintNothingUsed()
    for i = 1, GetNumGroupMembers() do
        local player = GetRaidRosterInfo(i);
        local data = self:GetData().spellUsage[player]
        if (data == nil) then
            EffusionRaidAssist:ChatMessage("Player: ", player)
            EffusionRaidAssist:ChatMessage("  Nothing used.")
        end
    end
end

function SpellTracker:ResetData()
    self:GetData().spellUsage = {}
end

function SpellTracker:CreateUserinterface()
    local content = AceGUI:Create("SimpleGroup")
    content:AddChild(AceGUI:Create("Button"))
    return content
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
        nothing = {
            order = 3,
            name = "Print Nothing used",
            desc = "Print the names of players that didnt use anything.",
            type = "execute",
            func = "PrintNothingUsed",
            width = "full",
            handler = self
        },
        reset = {
            order = 4,
            name = "Reset Data",
            desc = "Reset all gathered data.",
            type = "execute",
            func = "ResetData",
            width = "full",
            handler = self
        }
    }
end