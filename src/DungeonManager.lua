EffusionRaidAssistDungeonManager = CreateClass()

--[[
    Creates a new DungeonManager.
--]]
function EffusionRaidAssistDungeonManager.new()
    local self = setmetatable({}, EffusionRaidAssistDungeonManager)
    self.currentDungeon = nil
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

--[[
    Returns the events that this class wants to be called for.
--]]
function EffusionRaidAssistDungeonManager:GetGameEvents()
    return {
        "PLAYER_ENTERING_WORLD",
    }
end

--[[
    Checks if the player enters or leaves a dungeon and dispatches according custom events.
--]]
function EffusionRaidAssistDungeonManager:PLAYER_ENTERING_WORLD()
    if (self:IsInDungeon()) then
        self.currentDungeon = self:GetDungeonInfo()
        EffusionRaidAssist:DebugMessage("Entered Dungeon", self.currentDungeon.name, "(" .. self.currentDungeon.instanceId .. ")")
        EffusionRaidAssist.EventDispatcher:DispatchEvent("DUNGEON_ENTERED", self.currentDungeon)
    end
    if (self:IsInDungeon() ~= true and self.currentDungeon ~= nil) then
        EffusionRaidAssist:DebugMessage("Left Dungeon", self.currentDungeon.name, "(" .. self.currentDungeon.instanceId .. ")")
        EffusionRaidAssist.EventDispatcher:DispatchEvent("DUNGEON_LEFT", self.currentDungeon)
        self.currentDungeon = nil
    end
end

--[[
    Returns true if the player is inside of an instance.
--]]
function EffusionRaidAssistDungeonManager:IsInDungeon()
    return select(2, GetInstanceInfo()) == "party" or select(2, GetInstanceInfo()) == "raid"
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

--[[
    Returns information about the current dungeon. Nil if not in a dungeon.
--]]
function EffusionRaidAssistDungeonManager:GetDungeonInfo()
    if self:IsInDungeon() then
        local name, _, difficultyId, difficultyName, maxPlayers, _, _, instanceId, instanceGroupSize = GetInstanceInfo()
        return {
            name = name,
            difficultyId = difficultyId,
            difficultyName = difficultyName,
            maximumPlayers = maxPlayers,
            instanceId = instanceId,
            instanceGroupSize = instanceGroupSize
        }
    end
    return nil
end