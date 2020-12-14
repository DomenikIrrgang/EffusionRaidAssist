EffusionRaidAssistFramePool = CreateClass()

function EffusionRaidAssistFramePool.new()
    local self = setmetatable({}, EffusionRaidAssistFramePool)
    self.activeFrames = {}
    self.inactiveFrames = {}
    self.createdFrames = {}
    return self
end

function EffusionRaidAssistFramePool:GetFrame(type)
    if (self.inactiveFrames[type] == nil) then
        self.inactiveFrames[type] = EffusionRaidAssistStack()
    end
    local frame = nil
    if (self.inactiveFrames[type]:GetSize() == 0) then
        frame = self:CreateFrame(type)
    else
        frame = self.inactiveFrames[type]:Pop()
    end
    self.activeFrames[frame:GetName()] = frame
    return frame
end

function EffusionRaidAssistFramePool:CreateFrame(type)
    if (self.createdFrames[type] == nil) then
        self.createdFrames[type] = {}
    end
    local frame = CreateFrame(type, type .. #self.createdFrames[type], UIParent, "BackdropTemplate")
    table.insert(self.createdFrames[type], frame)
    EffusionRaidAssist:DebugMessage("Frame Created: ", frame:GetName())
    return frame
end

function EffusionRaidAssistFramePool:ReleaseFrame(frame)
    if (self.activeFrames[frame:GetName()] ~= nil) then
        local activeFrame = self.activeFrames[frame:GetName()]
        self.inactiveFrames[activeFrame:GetObjectType()]:Push(activeFrame)
        self.activeFrames[activeFrame:GetName()] = nil
    end
end