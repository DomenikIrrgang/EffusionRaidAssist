local MainWindow = EffusionRaidAssist.ModuleManager:NewModule("MainWindow")
local AceGUI = LibStub("AceGUI-3.0")

function MainWindow:OnModuleInitialize()
    self.window, self.moduleSelection, self.content = self:CreateWindow("EffusionRaidAssist")
    if (table.getn(self:GetModulesWithUserinterface()) > 0) then
        self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
    end
end

function MainWindow:CreateWindow(title)
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

function MainWindow:SetActiveModule(container, moduleName)
    self.selectedModule = moduleName
    container:ReleaseChildren()
    if (EffusionRaidAssist.ModuleManager:GetModuleByName(moduleName)) then
        container:AddChild(EffusionRaidAssist.ModuleManager:GetModuleByName(moduleName):CreateUserinterface())
    end
end

function MainWindow:CreateDropdownList()
    local result = {}
    for _, module in pairs(self:GetModulesWithUserinterface()) do
        result[module.name] = module.name
    end
    return result
end

function MainWindow:GetModulesWithUserinterface()
    local result = {}
    for _, module in pairs(EffusionRaidAssist.ModuleManager:GetEnabledModules()) do
        if (module["CreateUserinterface"] ~= nil) then
            table.insert(result, module)
        end
    end
    return result
end

function MainWindow:MINIMAP_ICON_CLICKED(_, clickType)
    if (clickType == "LeftButton") then
        if (self.window:IsShown()) then
            self.window:Hide()
        else
            self.window:Show()
        end
    end
end

function MainWindow:UpdateDropdownList()
    self.moduleSelection:SetGroupList(self:CreateDropdownList())
end

function MainWindow:MODULE_ENABLED(moduleName)
    self:UpdateDropdownList()
    if (self.selectedModule == nil) then
        if (table.getn(self:GetModulesWithUserinterface()) > 0) then
            self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
        end
    end
end

function MainWindow:MODULE_DISABLED(moduleName)
    self:UpdateDropdownList()
    if (moduleName == self.selectedModule) then
        if (table.getn(self:GetModulesWithUserinterface()) > 0) then
            self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
        else
            self.moduleSelection:SetGroup(nil)
        end
    end
end

function MainWindow:PROFILE_CHANGED()
    self:UpdateDropdownList()
    if (table.getn(self:GetModulesWithUserinterface()) > 0) then
        self.moduleSelection:SetGroup(self:GetModulesWithUserinterface()[1].name)
    else
        self.moduleSelection:SetGroup(nil)
    end
end

function MainWindow:GetCustomEvents()
    return {
        "MINIMAP_ICON_CLICKED",
        "MODULE_ENABLED",
        "MODULE_DISABLED",
        "PROFILE_CHANGED"
    }
end