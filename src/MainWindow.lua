EffusionRaidAssistMainWindow = EffusionRaidAssistModule("MainWindow")
local AceGUI = LibStub("AceGUI-3.0")

function EffusionRaidAssistMainWindow:OnModuleInitialize()
    EffusionRaidAssistMainWindow:AddEventCallback("MINIMAP_ICON_CLICKED", self, self.MinimapIconClicked)
    EffusionRaidAssistMainWindow:AddEventCallback("MODULE_ENABLED", self, self.ModuleEnabled)
    EffusionRaidAssistMainWindow:AddEventCallback("MODULE_DISABLED", self, self.ModuleDisabled)
    EffusionRaidAssistMainWindow:AddEventCallback("PROFILE_CHANGED", self, self.ProfileChanged)
    self.window, self.moduleSelection, self.content = self:CreateWindow("EffusionRaidAssist")
    _G["EffusionRaidAssistMainWindow"] = self.window.frame
    table.insert(UISpecialFrames, "EffusionRaidAssistMainWindow")
    if (table.getn(self:GetModulesWithUserinterface()) > 0) then
        self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
    end
    EffusionRaidAssist:DebugMessage(self.window)
end

function EffusionRaidAssistMainWindow:CreateWindow(title)
    local window = AceGUI:Create("Frame")
    window:SetHeight(900 / 1.4)
    window:SetWidth(1600 / 1.4)
    window:SetLayout("Fill")
    window:SetTitle(title)
    window:SetStatusText("Version " .. EffusionRaidAssist.MetaData.Version .. " (" .. EffusionRaidAssist.MetaData.Date .. ") by " .. EffusionRaidAssist.MetaData.Authors)
    window:Hide()
    local windowContent = AceGUI:Create("DropdownGroup")
    windowContent:SetTitle("Module")
    windowContent:SetLayout("Fill")
    windowContent:SetGroupList(self:CreateDropdownList())
    windowContent:SetCallback("OnGroupSelected", function(container, _, moduleName) self:SetActiveModule(container, moduleName) end)
    window:AddChild(windowContent)
    local moduleContent = AceGUI:Create("SimpleGroup")
    windowContent:AddChild(moduleContent)
    return window, windowContent, moduleContent
end

function EffusionRaidAssistMainWindow:SetActiveModule(container, moduleName)
    self.selectedModule = moduleName
    container:ReleaseChildren()
    if (EffusionRaidAssist.ModuleManager:GetModuleByName(moduleName)) then
        container:AddChild(EffusionRaidAssist.ModuleManager:GetModuleByName(moduleName):CreateUserinterface())
    end
end

function EffusionRaidAssistMainWindow:CreateDropdownList()
    local result = {}
    for _, module in pairs(self:GetModulesWithUserinterface()) do
        result[module.name] = module.name
    end
    return result
end

function EffusionRaidAssistMainWindow:GetModulesWithUserinterface()
    local result = {}
    for _, module in pairs(EffusionRaidAssist.ModuleManager:GetEnabledModules()) do
        if (module["CreateUserinterface"] ~= nil) then
            table.insert(result, module)
        end
    end
    return result
end

function EffusionRaidAssistMainWindow:MinimapIconClicked(_, clickType)
    if (clickType == "LeftButton") then
        if (self.window:IsShown()) then
            self.window:Hide()
        else
            self.window:Show()
        end
    end
end

function EffusionRaidAssistMainWindow:UpdateDropdownList()
    self.moduleSelection:SetGroupList(self:CreateDropdownList())
end

function EffusionRaidAssistMainWindow:ModuleEnabled(moduleName)
    self:UpdateDropdownList()
    if (self.selectedModule == nil) then
        if (table.getn(self:GetModulesWithUserinterface()) > 0) then
            self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
        end
    end
end

function EffusionRaidAssistMainWindow:ModuleDisabled(moduleName)
    self:UpdateDropdownList()
    if (moduleName == self.selectedModule) then
        if (table.getn(self:GetModulesWithUserinterface()) > 0) then
            self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
        else
            self.moduleSelection:SetGroup(nil)
        end
    end
end

function EffusionRaidAssistMainWindow:ProfileChanged()
    self:UpdateDropdownList()
    if (table.getn(self:GetModulesWithUserinterface()) > 0) then
        self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
    else
        self.moduleSelection:SetGroup(nil)
    end
end

function EffusionRaidAssistMainWindow:GetCustomEvents()
    return {
        "MINIMAP_ICON_CLICKED",
        "MODULE_ENABLED",
        "MODULE_DISABLED",
        "PROFILE_CHANGED"
    }
end