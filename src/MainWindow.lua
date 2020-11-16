local MainWindow = EffusionRaidAssist.ModuleManager:NewModule("MainWindow")
local AceGUI = LibStub("AceGUI-3.0")

function MainWindow:OnModuleInitialize()
    self.window = self:CreateWindow("EffusionRaidAssist")
end

function MainWindow:CreateWindow(title)
    local window = AceGUI:Create("Frame")
    window:SetTitle(title)
    window:SetLayout("Flow")
    window:Hide()
    return window
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

function MainWindow:GetCustomEvents()
    return {
        "MINIMAP_ICON_CLICKED"
    }
end