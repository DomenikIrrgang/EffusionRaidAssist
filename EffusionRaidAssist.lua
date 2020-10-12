EffusionRaidAssist = LibStub("AceAddon-3.0"):NewAddon("EffusionRaidAssist", "AceConsole-3.0")

function EffusionRaidAssist:HandleCombatLogEvent()
    local timestamp, eventName, _, _, sourceName, _, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()
    print(CombatLogGetCurrentEventInfo())
    if (eventName == "SPELL_CAST_SUCCESS" and EffusionRaidAssist:ArrayContainsValue(EffusionRaidAssist.trackedSpells, spellName)) then
        if EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName] ~= nil then
            table.insert(EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName], timestamp)
        else
            EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName] = { timestamp }
        end
        print(table.getn(EffusionRaidAssist:GetCurrentRaid()[sourceName].spellUsage[spellName]))
    end    
end

function EffusionRaidAssist:OnInitialize()
    print("EffusionRaidAsssist inititalized")
    local newFrame = CreateFrame("Frame")
    newFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    newFrame:SetScript("OnEvent", EffusionRaidAssist.HandleCombatLogEvent)
    for index, player in pairs(self:GetCurrentRaid()) do
        self:GetCurrentRaid()[index].spellUsage = {}        
    end
end

EffusionRaidAssist.trackedSpells = {
    "Healing Potion",
    "Mana Potion",
    "Fire Protection",
    "Nature Protection",
    "Frost Protection",
    "Free Action",
    "Flash of Light"
}

EffusionRaidAssist.raidInfo = {
    Acurielle = {}
    --Raids--> Acurielle --> spellsUsed/Enchants --> real spell/concrete enchants
}

function EffusionRaidAssist:GetCurrentRaid()
    return self.raidInfo
end