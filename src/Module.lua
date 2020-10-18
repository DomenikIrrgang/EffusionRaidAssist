EffusionRaidAssistModule = CreateClass()

function EffusionRaidAssistModule.new(name)
    local self = setmetatable({}, EffusionRaidAssistModule)
    self.name = name
    self.enabled = true
    self:InitEventListener()
    return self
end

function EffusionRaidAssistModule:InitEventListener()
    self.frame = CreateFrame("Frame")
    self.callbacks = {}
    self.frame:SetScript("OnEvent", function(_, event, ...)
        if (self.enabled == true) then
            self.callbacks[event](self, ...)
        end
    end)
end

function EffusionRaidAssistModule:SetEnabled(enabled)
    self.enabled = enabled
end

function EffusionRaidAssistModule:RegisterEventListener(event, callback)
    self.frame:RegisterEvent(event);
    self.callbacks[event] = callback
end

function EffusionRaidAssistModule:UnregisterEventListener(event)
    self.frame:UnregisterEvent(event)
    self.callbacks[event] = nil
end