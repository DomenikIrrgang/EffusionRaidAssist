EffusionRaidAssistFramePool = CreateClass()

function EffusionRaidAssistFramePool.new()
    local self = setmetatable({}, EffusionRaidAssistFramePool)
    self.activeFrames = {}
    self.inactiveFrames = {}
    self.createdFrames = {}
    self.customFrames = {}
    self.frame = self:GetFrame("Frame")
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

function EffusionRaidAssistFramePool:RegisterCustomType(type, definition)
    self.customFrames[type] = definition
end

function EffusionRaidAssistFramePool:IsCustomType(type)
    return self.customFrames[type] ~= nil
end

function EffusionRaidAssistFramePool:CreateFrame(type)
    if (self.createdFrames[type] == nil) then
        self.createdFrames[type] = {}
    end
    local frame = nil
    if (self:IsCustomType(type)) then
        frame = self.customFrames[type](type .. #self.createdFrames[type], UIParent)
    else
        frame = CreateFrame(type, type .. #self.createdFrames[type], UIParent, "BackdropTemplate")
    end
    table.insert(self.createdFrames[type], frame)
    EffusionRaidAssist:DebugMessage("Frame Created: ", frame:GetName())
    return frame
end

function EffusionRaidAssistFramePool:CreateTexture(type)
    if (self.createdFrames["Texture"] == nil) then
        self.createdFrames["Texture"] = {}
    end
    local texture = self.frame:CreateTexture("Texture" .. #self.createdFrames["Texture"] , type)
    table.insert(self.createdFrames["Texture"], texture)
    EffusionRaidAssist:DebugMessage("Texture Created: ", texture:GetName())
    return texture
end

function EffusionRaidAssistFramePool:GetTexture(type)
    if (self.inactiveFrames["Texture"] == nil) then
        self.inactiveFrames["Texture"] = EffusionRaidAssistStack()
    end
    local texture = nil
    if (self.inactiveFrames["Texture"]:GetSize() == 0) then
        texture = self:CreateTexture(type)
    else
        texture = self.inactiveFrames["Texture"]:Pop()
    end
    self.activeFrames[texture:GetName()] = texture
    texture:SetDrawLayer(type)
    return texture
end

function EffusionRaidAssistFramePool:Release(object)
    if (self.activeFrames[object:GetName()] ~= nil) then
        local activeFrame = self.activeFrames[object:GetName()]
        self.inactiveFrames[object:GetObjectType()]:Push(activeFrame)
        self.activeFrames[object:GetName()] = nil
    end
end