local MinimapIcon = EffusionRaidAssist.ModuleManager:NewModule("MinimapIcon")

function MinimapIcon:OnModuleInitialize()
    self.icon = LibStub("LibDBIcon-1.0")
    self.ldbName = "EffusionRaidAssist_LDB"
    self.ldb = LibStub("LibDataBroker-1.1"):NewDataObject(self.ldbName, {
        type = "launcher",
        text = self.ldbName,
        icon = "Interface/Icons/inv_potion_62",
        OnClick = self.Click,
        OnTooltipShow = self.GetToolTip,
    })
    self.icon:Register("EffusionRaidAssist_LDB", self.ldb, { hide = MinimapIcon:GetData().hideMinimap == true or not self:IsEnabled() })
end

function MinimapIcon.GetToolTip(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine("EffusionRaidAssist")
    tooltip:AddLine("Version " .. EffusionRaidAssist.MetaData.Version)

end

function MinimapIcon:SetVisible(visible)
    if ((visible or nil) and self:IsEnabled()) then
        self.icon:Show(self.ldbName)
    else
        self.icon:Hide(self.ldbName)
    end
end

function MinimapIcon.Click(...)
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.MinimapIconClick, ...)
end

function MinimapIcon:PROFILE_CHANGED()
    self:SetVisible(MinimapIcon:GetData().hideMinimap == false or MinimapIcon:GetData().hideMinimap == nil)
end

function MinimapIcon:OnEnable()
    self:SetVisible(MinimapIcon:GetData().hideMinimap == false or MinimapIcon:GetData().hideMinimap == nil)
end

function MinimapIcon:OnDisable()
    self:SetVisible(false)
end

function MinimapIcon:GetOptions()
    return {
        hide = {
            order = 1,
            type = "toggle",
            name = "Hide Minimapicon",
            get = function()
                return MinimapIcon:GetData().hideMinimap
            end,
            set = function(_, value)
                MinimapIcon:GetData().hideMinimap = value
                MinimapIcon:SetVisible(MinimapIcon:GetData().hideMinimap == false)
            end,
        }
    }
end

function MinimapIcon:GetCustomEvents()
    return {
        "PROFILE_CHANGED"
    }
end