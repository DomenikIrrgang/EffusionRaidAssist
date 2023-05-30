EffusionRaidAssistModule = CreateClass()

function EffusionRaidAssistModule.new(name)
    local self = setmetatable({}, EffusionRaidAssistModule)
    self.name = name
    return self
end

function EffusionRaidAssistModule:CombatLogEvent(event, data, callback)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback(event, data, self, callback)
end

function EffusionRaidAssistModule:SetEnabled(enabled)
    if (not self:IsEnabled() and enabled == true) then
        self:GetData().enabled =  true
        if (self.OnEnable) then
            self:OnEnable()
        end
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleEnabled, self.name)
    end
    if (self:IsEnabled() and enabled == false) then
        if (self.OnDisable) then
            self:OnDisable()
        end
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleDisabled, self.name)
        self:GetData().enabled = false
    end
end

function EffusionRaidAssistModule:IsEnabled()
    return self:GetData().enabled
end

function EffusionRaidAssistModule:GetData(name)
    local path = "modules." .. self.name

    if (EffusionRaidAssist.Storage:HasData(path) == nil) then
        EffusionRaidAssist.Storage:ChangeData(path, self:GetDefaultOptions())
    end

    if (name) then
        path = path .. "." .. name
    end
    return EffusionRaidAssist.Storage:GetData(path)
end

function EffusionRaidAssistModule:RegisterDataCallback(path, callback)
    EffusionRaidAssist.Storage:RegisterDataCallback("modules." .. self.name .. "." .. path, callback)
end

function EffusionRaidAssistModule:ChangeData(path, value)
    EffusionRaidAssist.Storage:ChangeData("modules." .. self.name .. "." .. path, value)
end

function EffusionRaidAssistModule:ChatMessage(...)
    EffusionRaidAssist:ModuleMessage(self.name, ...)
end

function EffusionRaidAssistModule:AddEventCallback(event, listener, callback)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(event, self, self:EventCallbackWrapper(listener, callback))
end

function EffusionRaidAssistModule:GetDefaultOptions()
    local data = {
        enabled = true
    }
    if (self.GetDefaultSettings) then
        for key, value in pairs(self:GetDefaultSettings()) do
            data[key] = value
        end
    end
    return data
end

function EffusionRaidAssistModule:OptionsGetter(path)
    return function() return self:GetData(path) end
end

function EffusionRaidAssistModule:OptionsSetter(path)
    return function(_, value) return self:ChangeData(path, value) end
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
            --[[remove = {
                order = 99,
                type = "execute",
                name = "Remove Module",
                func = function()
                    EffusionRaidAssist.ModuleManager:UnloadModule(self)
                end,
                width = "full",
            }--]]
        }
    }
    if (self.GetOptions) then
        result.args = table.merge(result.args, self:GetOptions())
    end
    return result
end