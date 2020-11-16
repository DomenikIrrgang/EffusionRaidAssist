EffusionRaidAssistEncounter = CreateClass()

--[[
    Creates a new Encounter.

    @param name Name of the Encounter.
    @param id EncounterId of the encounter.
    @param difficulty DifficultyId of the encounter.
    @param size Size of the raid.
--]]
function EffusionRaidAssistEncounter.new(id, name, difficulty, size)
    local self = setmetatable({}, EffusionRaidAssistEncounter)
    self.active = true
	self.startTime = GetTime()
	self.endTime = GetTime()
	self.id = id
	self.difficulty = difficulty
    self.name = name
    self.size = size
    return self
end

--[[
    Returns the id of the encounter.

    @return Id of the encounter.
--]]
function EffusionRaidAssistEncounter:GetId()
    return self.id
end

--[[
    Returns the duration of the encounter.

    @return Duration of the encounter.
--]]
function EffusionRaidAssistEncounter:GetDuration()
    return self.endTime - self.startTime
end

--[[
    Returns true if the encounter is on Mythic difficutly.

    @return True if encounter is Mythic difficulty.
--]]
function EffusionRaidAssistEncounter:IsMythic()
	return self.difficulty == 16
end

--[[
    Returns true if the encounter is on Heroic difficutly.

    @return True if encounter is Heroic difficulty.
--]]
function EffusionRaidAssistEncounter:IsHeroic()
	return self.difficulty == 15
end

--[[
    Returns true if the encounter is on Normal difficutly.

    @return True if encounter is Normal difficulty.
--]]
function EffusionRaidAssistEncounter:IsNormal()
	return self.difficulty == 14
end

--[[
    Returns the name of the difficulty.

    @return Name of the difficulty.
--]]
function EffusionRaidAssistEncounter:GetDifficultyName()
    return self.difficultyMap[self.difficulty]
end

--[[
    Ends the this encounter and measure the time and result.

    @param result 1 if encounter was successful.
--]]
function EffusionRaidAssistEncounter:End(result)
    self.endTime = GetTime()
    self.active = false
    self.result = result
end

--[[
    Returns the starttime of the encounter.

    @return Starttime of the encounter.
--]]
function EffusionRaidAssistEncounter:GetStartTime()
    return self.startTime
end

--[[
    Returns the endtime of the encounter.

    @return Endtime of the encounter.
--]]
function EffusionRaidAssistEncounter:GetEndTime()
    return self.endTime
end

function EffusionRaidAssistEncounter:GetResultName()
    if (self:IsActive()) then
        return nil
    else
        if (self.result == 1) then
            return "Success"
        else
            return "Wipe"
        end
    end
end

function EffusionRaidAssistEncounter:IsActive()
    return self.active
end

EffusionRaidAssistEncounter.difficultyMap = {}
EffusionRaidAssistEncounter.difficultyMap[14] = "Normal"
EffusionRaidAssistEncounter.difficultyMap[15] = "Heroic"
EffusionRaidAssistEncounter.difficultyMap[16] = "Mythic"