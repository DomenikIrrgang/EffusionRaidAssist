EffusionRaidAssistModuleManager = CreateClass()

function EffusionRaidAssistModuleManager.new()
    local self = setmetatable({}, EffusionRaidAssistModuleManager)
    self.modules = {}
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
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

function EffusionRaidAssistModuleManager:GetCustomEvents()
    return {
        "EFFUSION_RAID_ASSIST_INIT_FINISHED"
    }
end

function EffusionRaidAssistModuleManager:EFFUSION_RAID_ASSIST_INIT_FINISHED()
    for _, module in pairs(self.modules) do
        if (module.OnInitialize ~= nil) then
            module:OnInitialize()
        end
    end
end

function EffusionRaidAssistModuleManager:NewModule(name)
    local newModule = EffusionRaidAssistModule(name)
    newModule.id = table.getn(self.modules)
    table.insert(self.modules, newModule)
    return newModule
end

