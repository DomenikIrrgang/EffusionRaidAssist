EffusionRaidAssistGroupManager = CreateClass()

--[[
    Creates a new GroupManager.
--]]
function EffusionRaidAssistGroupManager.new()
    local self = setmetatable({}, EffusionRaidAssistGroupManager)
    self.group = self:CalculateCurrentGroup()
    EffusionRaidAssist.EventDispatcher:AddEventCallback("GROUP_ROSTER_UPDATE", self, self.GroupMembersChanged)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("GROUP_LEFT", self, self.GroupLeft)
    return self
end

function EffusionRaidAssistGroupManager:GroupMembersChanged(event)
    local newGroup = self:CalculateCurrentGroup()
    local playersLeft, playersJoined = self:CompareGroups(self.group, newGroup)
    for _, player in pairs(playersLeft) do
        EffusionRaidAssist:DebugMessage("Player left group", player.name, player.class, player.isOnline, player.isDead, player.level)
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.PlayerLeftGroup, player)
    end
    for _, player in pairs(playersJoined) do
        EffusionRaidAssist:DebugMessage("Player joined group", player.name, player.class, player.isOnline, player.isDead, player.level)
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.PlayerJoinedGroup, player)
    end
    self.group = newGroup
end

function EffusionRaidAssistGroupManager:CalculateCurrentGroup()
    local newGroup = {}
    for i = 1, GetNumGroupMembers() do
        local unit, _, _, level, class, _, _, isOnline, isDead = GetRaidRosterInfo(i)
        newGroup[unit] = { name = unit, level = level, class = class, isOnline = isOnline, isDead = isDead }
    end
    return newGroup
end

function EffusionRaidAssistGroupManager:CompareGroups(oldGroup, newGroup)
    local playersLeft, playersJoined = {}, {}
    for _, member in pairs(oldGroup) do
        if (newGroup[member.name] == nil) then
            table.insert(playersLeft, member)
        end
    end
    for _, member in pairs(newGroup) do
        if (oldGroup[member.name] == nil) then
            table.insert(playersJoined, member)
        end
    end
    return playersLeft, playersJoined
end

function EffusionRaidAssistGroupManager:IsUnitInGroup(name)
    return self.group[name] ~= nil
end

function EffusionRaidAssistGroupManager:GroupLeft()
    EffusionRaidAssist:DebugMessage("Group left")
    self.group = {}
end