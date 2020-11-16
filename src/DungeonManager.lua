EffusionRaidAssistDungeonManager = CreateClass()

--[[
    Creates a new DungeonManager.
--]]
function EffusionRaidAssistDungeonManager.new()
    local self = setmetatable({}, EffusionRaidAssistDungeonManager)
    self.currentDungeon = nil
    self.activeEncounters = {}
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

--[[
    Returns the events that this class wants to be called for.
--]]
function EffusionRaidAssistDungeonManager:GetGameEvents()
    return {
        "PLAYER_ENTERING_WORLD",
        "ENCOUNTER_START",
        "ENCOUNTER_END"
    }
end

--[[
    Checks if the player enters or leaves a dungeon and dispatches according custom events.
--]]
function EffusionRaidAssistDungeonManager:PLAYER_ENTERING_WORLD()
    if (self:IsInDungeon()) then
        self.currentDungeon = self:GetDungeonName()
        EffusionRaidAssist.EventDispatcher:DispatchEvent("DUNGEON_ENTERED", self:GetDungeonName())
    end
    if (self:IsInDungeon() ~= true and self.currentDungeon ~= nil) then
        EffusionRaidAssist.EventDispatcher:DispatchEvent("DUNGEON_LEFT", self.currentDungeon)
        self.currentDungeon = nil
    end
end

--[[
    Stores information about the boss encounters that started.
--]]
function EffusionRaidAssistDungeonManager:ENCOUNTER_START(id, name, difficulty, size)
    self.activeEncounters[id] = { id = id, name = name, start = GetTime(), difficulty = difficulty }
end

--[[
    Removes information about the boss encounters that ended.
--]]
function EffusionRaidAssistDungeonManager:ENCOUNTER_END(id, name, difficulty, size)
    self.activeEncounters[id] = nil
end

--[[
    Returns true if the player is currently in a boss encounter.

    @return true if player is currently engaged in a boss encounter.
--]]
function EffusionRaidAssistDungeonManager:IsEncounterActive()
    return table.getn(self.IsEncounterActive) > 0
end

--[[
    Returns information about the currently engaged boss encounters.

    @return Table that contains information about the currently engaged boss encounters.
--]]
function EffusionRaidAssistDungeonManager:GetActiveEncounters()
    return self.activeEncounters
end

--[[
    Returns true if the player is inside of an instance.
--]]
function EffusionRaidAssistDungeonManager:IsInDungeon()
    return select(2, GetInstanceInfo()) ~= 'none'
end

--[[
    Returns the name of the instance the character is currently in. Nil if he is not in an instance.
--]]
function EffusionRaidAssistDungeonManager:GetDungeonName()
    if self:IsInDungeon() then
        local dungeonName = GetInstanceInfo()
        return dungeonName
    end
    return nil
end