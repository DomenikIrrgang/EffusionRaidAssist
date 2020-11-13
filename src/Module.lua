EffusionRaidAssistModule = CreateClass()

function EffusionRaidAssistModule.new(name)
    local self = setmetatable({}, EffusionRaidAssistModule)
    self.name = name
    return self
end

function EffusionRaidAssistModule:OnInitialize()
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    if (self.OnModuleInitialize) then
        self:OnModuleInitialize()
    end
    self:SetEnabled(self:IsEnabled())
end

function EffusionRaidAssistModule:CombatLogEvent(event, spellName, callback)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback(event, spellName, self, callback)
end

function EffusionRaidAssistModule:SetEnabled(enabled)
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
                    return self:GetData().enabled
                end,
                set = function(_, value)
                    self:GetData().enabled = value
                    self:SetEnabled(self:GetData().enabled)
                end,
            }
        }
    }
    if (self.GetOptions) then
        result.args = table.merge(result.args, self:GetOptions())
    end
    return result
end