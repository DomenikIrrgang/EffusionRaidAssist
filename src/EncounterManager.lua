EffusionRaidAssistEncounterManager= CreateClass()

--[[
    Creates a new EncounterManager.
--]]
function EffusionRaidAssistEncounterManager.new()
    local self = setmetatable({}, EffusionRaidAssistEncounterManager)
    self.activeEncounters = {}
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

--[[
    Returns the events that this class wants to be called for.
--]]
function EffusionRaidAssistEncounterManager:GetGameEvents()
    return {
        "ENCOUNTER_START",
        "ENCOUNTER_END"
    }
end 
--[[
    Stores information about the boss encounters that started.
--]]
function EffusionRaidAssistEncounterManager:ENCOUNTER_START(id, name, difficulty, size)
    self:StartEncounter(id, name, difficulty, size)
end

--[[
    Removes information about the boss encounters that ended.
--]]
function EffusionRaidAssistEncounterManager:ENCOUNTER_END(id, name, difficulty, size, result)
    self:EndEncounter(id, name, difficulty, size, result)
end

function EffusionRaidAssistEncounterManager:StartEncounter(id, name, difficulty, size)
    local encounter = EffusionRaidAssistEncounter(id, name, difficulty, size)
    self.activeEncounters[id] = encounter
    EffusionRaidAssist:ChatMessage(encounter.name, "(" .. encounter:GetDifficultyName() .. ", " .. encounter.size .. "-man) engaged! Good luck.")
end

function EffusionRaidAssistEncounterManager:EndEncounter(id, name, difficulty, size, result)
    local encounter = self.activeEncounters[id]
    encounter:End(result)
    EffusionRaidAssist:ChatMessage("Encounter against", encounter.name, "(" .. encounter:GetDifficultyName() .. ") ended after", string.format("%.2f", encounter:GetDuration()), " seconds.", "(" .. encounter:GetResultName() .. ")")
    self.activeEncounters[id] = nil
    self:ArchiveEncounter(encounter)
end

--[[
    Returns true if the player is currently in a boss encounter.

    @return true if player is currently engaged in a boss encounter.
--]]
function EffusionRaidAssistEncounterManager:IsEncounterActive()
    return table.getn(self.IsEncounterActive) > 0
end

--[[
    Returns information about the currently engaged boss encounters.

    @return Table that contains information about the currently engaged boss encounters.
--]]
function EffusionRaidAssistEncounterManager:GetActiveEncounters()
    return self.activeEncounters
end

function EffusionRaidAssistEncounterManager:GetArchivedEncounters()
    return EffusionRaidAssist.Storage:GetData().encounterHistory or {}
end

function EffusionRaidAssistEncounterManager:ArchiveEncounter(encounter)
    EffusionRaidAssist.Storage:GetData().encounterHistory = {} or EffusionRaidAssist.Storage:GetData().encounterHistory
    table.insert(EffusionRaidAssist.Storage:GetData().encounterHistory, encounter)
end