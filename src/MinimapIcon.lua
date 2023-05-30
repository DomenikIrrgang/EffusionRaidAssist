EffusionRaidAssistMinimapIcon = EffusionRaidAssistModule("Minimap")

function EffusionRaidAssistMinimapIcon:OnModuleInitialize()
    self.icon = LibStub("LibDBIcon-1.0")
    self.ldbName = "EffusionRaidAssist_LDB"
    self.ldb = LibStub("LibDataBroker-1.1"):NewDataObject(self.ldbName, {
        type = "launcher",
        text = self.ldbName,
        icon = "Interface/Icons/inv_potion_62",
        OnClick = self.Click,
        OnTooltipShow = self.GetToolTip,
    })
    self.icon:Register("EffusionRaidAssist_LDB", self.ldb, { hide = self:GetData().hideMinimap == true or not self:IsEnabled() })
    self:RegisterDataCallback("hideMinimap", BindCallback(self, self.Hide))
end

function EffusionRaidAssistMinimapIcon.GetToolTip(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine("EffusionRaidAssist")
    tooltip:AddLine("Version " .. EffusionRaidAssist.MetaData.Version)
end

function EffusionRaidAssistMinimapIcon:SetVisible(visible)
    if ((visible or nil) and self:IsEnabled()) then
        self.icon:Show(self.ldbName)
    else
        self.icon:Hide(self.ldbName)
    end
end

function EffusionRaidAssistMinimapIcon:Hide(hide)
    self:SetVisible(hide == false)
end

function EffusionRaidAssistMinimapIcon.Click(...)
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.MinimapIconClicked, ...)
end

function EffusionRaidAssistMinimapIcon:PROFILE_CHANGED()
    self:SetVisible(self:GetData().hideMinimap)
end

function EffusionRaidAssistMinimapIcon:OnEnable()
    self:SetVisible(self:GetData().hideMinimap == false)
end

function EffusionRaidAssistMinimapIcon:OnDisable()
    self:SetVisible(false)
end

function EffusionRaidAssistMinimapIcon:GetOptions()
    return {
        hide = {
            order = 1,
            type = "toggle",
            name = "Hide Minimapicon",
            get = self:OptionsGetter("hideMinimap"),
            set = self:OptionsSetter("hideMinimap"),
        }
    }
end

function EffusionRaidAssistMinimapIcon:GetDefaultSettings()
    return {
        hideMinimap = false
    }
end

function EffusionRaidAssistMinimapIcon:GetCustomEvents()
    return {
        "PROFILE_CHANGED"
    }
end