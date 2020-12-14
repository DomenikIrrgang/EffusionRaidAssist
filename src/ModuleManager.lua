EffusionRaidAssistModuleManager = CreateClass()

function EffusionRaidAssistModuleManager.new()
    local self = setmetatable({}, EffusionRaidAssistModuleManager)
    self.modules = {}
    EffusionRaidAssist.EventDispatcher:AddEventCallback("EFFUSION_RAID_ASSIST_INIT_FINISHED", self, self.Init)
    return self
end

function EffusionRaidAssistModuleManager:GetModules()
    return self.modules
end

function EffusionRaidAssistModuleManager:GetEnabledModules()
    local result = {}
    for _, module in pairs(self:GetModules()) do
        if (module:IsEnabled()) then
            table.insert(result, module)
        end
    end
    return result
end

function EffusionRaidAssistModuleManager:GetModuleByName(moduleName)
    for _, module in pairs(self:GetModules()) do
        if module.name == moduleName then
            return module
        end
    end
    return nil
end

function EffusionRaidAssistModuleManager:Init()
    for _, module in pairs(self.modules) do
        if (module.OnInitialize ~= nil) then
            module:OnInitialize()
        end
    end
end

function EffusionRaidAssistModuleManager:NewModule(name, object)
    local newModule = EffusionRaidAssistModule(name, object)
    self:AddModule(newModule)
    return newModule
end

function EffusionRaidAssistModuleManager:AddModule(module)
    module.id = table.getn(self.modules)
    table.insert(self.modules, module)
end

