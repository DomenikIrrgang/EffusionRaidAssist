EffusionRaidAssistGroupManager= CreateClass()

--[[
    Creates a new GroupManager.
--]]
function EffusionRaidAssistGroupManager.new()
    local self = setmetatable({}, EffusionRaidAssistGroupManager)
    self.group = {}
    EffusionRaidAssist.EventDispatcher:AddEventCallback("GROUP_ROSTER_UPDATE", self, self.GroupMemberChanged)
    return self
end

function EffusionRaidAssistGroupManager:GroupMemberChanged(event)
    local newGroup = {}
    for i = 1, GetNumGroupMembers() do
        local unit, _, _, level, class, _, _, isOnline, isDead = GetRaidRosterInfo(i)
        newGroup[unit] = { level = level, class = class, isOnline = isOnline, isDead = isDead }
    end
    local playersLeft, playersJoined = self:CompareGroups(self.group, newGroup)
    for _, player in pairs(playersLeft) do
        EffusionRaidAssist.EventDispatcher:DispatchEvent()
    end
    self.group = newGroup
end

function EffusionRaidAssistGroupManager:CompareGroups(oldGroup, newGroup)
    local playersLeft, playersJoined = {}, {}
    for member in ipairs(oldGroup) do
        if (newGroup[member] == nil) then
            table.insert(playersLeft, member)
        end
    end
    for member in ipairs(newGroup) do
        if (oldGroup[member] == nil) then
            table.insert(playersJoined, member)
        end
    end
    return playersLeft, playersJoined
end

function EffusionRaidAssistGroupManager:IsUnitInGroup(name)
    return self.group[name] ~= nil
end