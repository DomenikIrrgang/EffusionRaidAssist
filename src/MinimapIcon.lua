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

function EffusionRaidAssistMinimapIcon.Click(...)
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.MinimapIconClicked, ...)
end

function EffusionRaidAssistMinimapIcon:PROFILE_CHANGED()
    self:SetVisible(self:GetData().hideMinimap == false or self:GetData().hideMinimap == nil)
end

function EffusionRaidAssistMinimapIcon:OnEnable()
    self:SetVisible(self:GetData().hideMinimap == false or self:GetData().hideMinimap == nil)
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
            get = function()
                return self:GetData().hideMinimap
            end,
            set = function(_, value)
                self:GetData().hideMinimap = value
                self:SetVisible(self:GetData().hideMinimap == false)
            end,
        }
    }
end

function EffusionRaidAssistMinimapIcon:GetCustomEvents()
    return {
        "PROFILE_CHANGED"
    }
end