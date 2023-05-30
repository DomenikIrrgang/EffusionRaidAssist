EffusionRaidAssistEncounterManager= CreateClass()

--[[
    Creates a new EncounterManager.
--]]
function EffusionRaidAssistEncounterManager.new()
    local self = setmetatable({}, EffusionRaidAssistEncounterManager)
    self.activeEncounters = {}
    EffusionRaidAssist.EventDispatcher:AddEventCallback("ENCOUNTER_START", self, self.StartEncounter)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("ENCOUNTER_END", self, self.EndEncounter)
    return self
end

function EffusionRaidAssistEncounterManager:StartEncounter(id, name, difficulty, size)
    local encounter = EffusionRaidAssistEncounter(id, name, difficulty, size)
    self.activeEncounters[id] = encounter
    print("ENCOUNTER_START", id, name, difficulty, size)
    print("Encounter", encounter:GetDifficultyName(), encounter.id, encounter.name, encounter.difficulty, encounter.size)
    EffusionRaidAssist:ChatMessage(encounter.name, "(" .. encounter:GetDifficultyName() .. ", " .. encounter.size .. "-man) engaged! Good luck.")
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.EncounterEngaged, encounter)
end

function EffusionRaidAssistEncounterManager:EndEncounter(id, _, _, _, result)
    local encounter = self.activeEncounters[id]
    if (encounter) then
        print("ENCOUNTER_END", id, result)
        print("Encounter", encounter:GetDifficultyName(), encounter.id, encounter.name, encounter.difficulty, encounter.size)
        encounter:End(result)
        EffusionRaidAssist:ChatMessage("Encounter against", encounter.name, "(" .. encounter:GetDifficultyName() .. ", " .. encounter.size .. "-man) ended after", string.format("%.2f", encounter:GetDuration()), " seconds.", "(" .. encounter:GetResultName() .. ")")
        self.activeEncounters[id] = nil
        self:ArchiveEncounter(encounter)
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.EncounterDisengaged, encounter)
    end
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

function EffusionRaidAssistEncounterManager:ArchiveEncounter(encounter)
    EffusionRaidAssist.Storage:GetData().encounterHistory = {} or EffusionRaidAssist.Storage:GetData().encounterHistory
    table.insert(EffusionRaidAssist.Storage:GetData().encounterHistory, encounter)
end