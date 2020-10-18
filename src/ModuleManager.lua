EffusionRaidAssistModuleManager = CreateClass()

function EffusionRaidAssistModuleManager.new()
    local self = setmetatable({}, EffusionRaidAssistModuleManager)
    self.modules = {}
    return self
end

function EffusionRaidAssistModuleManager:GetModules()
    return self.modules
end

function EffusionRaidAssistModuleManager:Init()
    for _, module in pairs(self.modules) do
        if (module.OnInitialize ~= nil) then
            module:OnInitialize()
        end
    end
end

function EffusionRaidAssistModuleManager:NewModule(name)
    local newModule = EffusionRaidAssistModule(name)
    table.insert(self.modules, newModule)
    return newModule
end

