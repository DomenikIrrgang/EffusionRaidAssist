EffusionRaidAssistModuleManager = CreateClass()

function EffusionRaidAssistModuleManager.new()
    local self = setmetatable({}, EffusionRaidAssistModuleManager)
    self.modules = {}
    EffusionRaidAssist.EventDispatcher:AddEventCallback("PLAYER_LOGIN", self, self.Init)
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
        self:LoadModule(module)
    end
end

function EffusionRaidAssistModuleManager:LoadModule(module)
    if (module.OnModuleInitialize ~= nil) then
        module:OnModuleInitialize()
    end
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleLoaded, module.name)
end

function EffusionRaidAssistModuleManager:UnloadModule(module)
    if (module.OnModuleUninitialize) then
        module:OnModuleUninitialize()
    end
    self:RemoveModule(module)
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ModuleUnloaded, module.name)
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

function EffusionRaidAssistModuleManager:RemoveModule(module)
    for index, value in pairs(self:GetModules()) do
        if (module.name == value.name) then
            table.remove(self.modules, index)
        end
    end
end