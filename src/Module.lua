EffusionRaidAssistModule = CreateClass()

function EffusionRaidAssistModule.new(name)
    local self = setmetatable({}, EffusionRaidAssistModule)
    self.name = name
    return self
end

function EffusionRaidAssistModule:CombatLogEvent(event, event, callback)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback(event, spellId, self, callback)
end

function EffusionRaidAssistModule:CombatLogEventFromUnit(event, unitId, spellId, callback)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback(event, unitId, spellId, self, callback)
end

function EffusionRaidAssistModule:SetEnabled(enabled)
    self:GetData().enabled = enabled
    if (self:IsEnabled()) then
        if (self.OnEnable) then
            self:OnEnable()
        end
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleEnabled, self.name)
    else
        if (self.OnDisable) then
            self:OnDisable()
        end
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleDisabled, self.name)
    end
end

function EffusionRaidAssistModule:IsEnabled()
    return self:GetData().enabled
end

function EffusionRaidAssistModule:GetData()
    return EffusionRaidAssist.Storage:GetData().modules[self.name]
end

function EffusionRaidAssistModule:ChatMessage(...)
    EffusionRaidAssist:ModuleMessage(self.name, ...)
end

function EffusionRaidAssistModule:AddEventCallback(event, listener, callback)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(event, self, self:EventCallbackWrapper(listener, callback))
end

function EffusionRaidAssistModule:EventCallbackWrapper(listener, callback)
    return function(self, ...)
        if (EffusionRaidAssist.ModuleManager:GetModuleByName(self.name) and self:IsEnabled()) then
            callback(listener, ...)
        end
    end
end

function EffusionRaidAssistModule:GetOptionsTable()
    local result = {
        name = self.name,
        type = "group",
        order = self.id,
        childGroups = "select",
        args = {
            enabled = {
                order = 1,
                type = "toggle",
                name = "Enabled",
                get = function()
                    return self:IsEnabled()
                end,
                set = function(_, value)
                    self:SetEnabled(value)
                end,
            },
            remove = {
                order = 99,
                type = "execute",
                name = "Remove Module",
                func = function()
                    EffusionRaidAssist.ModuleManager:UnloadModule(self)
                end,
                width = "full",
            }
        }
    }
    if (self.GetOptions) then
        result.args = table.merge(result.args, self:GetOptions())
    end
    return result
end